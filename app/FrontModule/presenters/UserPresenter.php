<?php

namespace App\FrontModule\Presenters;

use App\FrontModule\Forms\CartQuantityFormFactory;
use Nette;
use App\FrontModule\Model;
use App\FrontModule\Model\CartManager;
use App\FrontModule\Model\OrderManager;
use App\FrontModule\Model\PriceInvalidException;


class UserPresenter extends BasePresenter
{
	/**
	 * @var CartManager $cartManager
	 * @var OrderManager $orderManager
	 */
	private $cartManager, $orderManager;


	public function __construct(CartManager $cartManager, OrderManager $orderManager)
	{
		parent::__construct();

		$this->cartManager = $cartManager;
		$this->orderManager = $orderManager;
	}

	protected function startup() {
		parent::startup();

		if (!$this->parameters['eshop']) {
			$this->error(); //Error 404
		}
	}

	/**
	 * @return Navbar
	 */
	protected function createComponentNavbar()
	{
		if ($this->getUser()->isLoggedIn()) {
			$items = $this->parameters['logged_menu'];
		} else {
			$items = [
				'Košík' => ['User:cart'],
				'Přihlásit se' => ['Sign:in', $this->storeRequest()],
				'Zaregistrovat se' => ['Register:default'],
			];
		}
		$control = new Navbar('Můj účet', $items);
		return $control;
	}


	public function renderOrders()
	{
		if (!$this->getUser()->isLoggedIn()) {
			$this->redirect('Sign:in', ['state' => $this->storeRequest()]);
		}
		$this->template->items = $this->orderManager->getUserOrders($this->getUser()->id);
	}


	public function renderOrder($id)
	{
		if (!$this->getUser()->isLoggedIn()) {
			$this->redirect('Sign:in', ['state' => $this->storeRequest()]);
		}
		$this->template->order = $this->orderManager->getOrder($id);
		$this->template->products = $this->orderManager->getOrderedProducts($id);
		$this->template->show_order_code = $this->parameters['product']['show_order_code'];
		if ($this->template->order['customerId'] != $this->user->id) {
			$this->error();
		}
	}


	/**
	 * @return Order
	 */
	public function createComponentOrder()
	{
		$control = new Order($this->template->order, $this->template->products, $this->template->show_order_code);
		return $control;
	}


	public function renderCart()
	{
		if ($this->getUser()->isLoggedIn()) {
			$this->template->show_order_code = $this->parameters['product']['show_order_code'];
			$this->template->items = $this->cartManager->getItems($this->getUser()->id);
			try {
				$this->template->total = $this->cartManager->getPrice($this->getUser()->id);
			} catch (PriceInvalidException $e) {}
		} else {
			$this->template->items = [];
		}
	}


	/**
	 * Remove selected product from cart
	 * @param int $itemId
	 */
	public function actionRemoveFromCart($itemId)
	{
		if ($this->getUser()->isLoggedIn()) {
			if ($this->cartManager->removeItem($this->user->id, $itemId)) {
				$this->flashMessage('Položka byla z košíku odebrána');
			} else {
				$this->flashMessage('Položku nebylo možné z košíku odebrat, patrně se v něm nenachází', 'flash-error');
			}
			$this->redirect('User:cart');
		} else {
			// TO-DO cart for unregistred users
		}
	}


	/**
	 * Add selected product to cart
	 * @param int $itemId
	 * @param $redirect
	 */
	public function actionAddToCart($itemId, $redirect)
	{
		if ($this->getUser()->isLoggedIn()) {
			if ($this->cartManager->addItem($this->user->id, $itemId)) {
				$this->flashMessage('Položka byla přidána do košíku');
			} else {
				$this->flashMessage('Položku nebylo možné přidat do košíku', 'flash-error');
			}
		} else {
			// TO-DO cart for unregistred users
		}
		if (isset($redirect)) {
				$this->redirect($redirect);
		}
		$this->redirect('User:cart');
	}


	/**
	 * @return Nette\Application\UI\Form
	 */
	public function createComponentCartQuantityForm()
	{
		$form = new CartQuantityFormFactory($this->cartManager, $this);
		return $form->create($this->cartManager->getItems($this->user->id));
	}
}
