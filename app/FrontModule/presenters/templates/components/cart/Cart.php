<?php
declare(strict_types=1);

namespace App\FrontModule\Presenters;

use Nette;
use Nette\Application\UI\Control;
use App\Model\CartManager;
use Nette\Security\User;


class Cart extends Control
{

	/**
	 * @var User $user
	 * @var CartManager $cartManager
	 */
	private $user, $cartManager;


	public function __construct(User $user, CartManager $cartManager)
	{
		parent::__construct();

		$this->user = $user;
		$this->cartManager = $cartManager;
	}

	public function render()
	{
		$template = $this->template;
		$template->setFile(__DIR__ . '/cart.latte');
		$template->cart = $this->getCounts();

		$template->render();
	}

	/**
	 * Gets the count and price of items in user cart.
	 * @return array with 'count' and 'price'
	 */
	private function getCounts(): array
	{
		if ($this->user->isLoggedIn()) {
			$ret = [];
			$ret['count'] = $this->cartManager->getCount($this->user->getId());
			$ret['price'] = $this->cartManager->getPrice($this->user->getId());
		} else {
			$ret = [
				'count' => 0,
				'price' => 0,
			];
		}
		return $ret;
	}
}
