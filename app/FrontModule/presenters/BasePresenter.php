<?php
declare(strict_types=1);

namespace App\FrontModule\Presenters;

use App\Model\UserAuthenticator;
use Nette;
use App\Model\CartManager;
use App\Model\ProductManager;
use App\FrontModule\Forms\SearchFormFactory;
use App\Model\Parameters;
use Nette\Application\UI\Control;
use Nette\Application\UI\Form;


/**
 * Base presenter for all application presenters.
 */
abstract class BasePresenter extends Nette\Application\UI\Presenter
{
	/**
	 * @var Parameters $parameters
	 */
	protected $parameters;

	public function injectParameters(Parameters $parameters)
	{
		$this->parameters = $parameters->getParam();

	}

	/**
	 * @var CartManager $cartManager
	 */
	private $cartManager;

	public function injectCartManager(CartManager $cartManager)
	{
		$this->cartManager = $cartManager;
	}

	/**
	 * @var ProductManager $productManager
	 */
	private $productManager;

	public function injectProductManager(ProductManager $productManager)
	{
		$this->productManager = $productManager;
	}

	/**
	 * @var UserAuthenticator $userAuthenticator
	 */
	private $userAuthenticator;

	public function injectUserAuthenticator(UserAuthenticator $userAuthenticator)
	{
		$this->userAuthenticator = $userAuthenticator;
	}

	protected function startup()
	{
		parent::startup();

		$this->user->getStorage()->setNamespace('Front');
		$this->user->setAuthenticator($this->userAuthenticator);

		$this->template->page = $this->getName();
		$this->template->phone = $this->parameters['contact']['phone'];
	}

	protected function createComponentSearch(): Form
	{
		$form = new SearchFormFactory($this->productManager, $this);
		return $form->create();
	}

	protected function createComponentCart(): Control
	{
		$user = $this->getUser();
		$control = new Cart($user, $this->cartManager, $this->productManager, $this->getHttpRequest(), $this->getHttpResponse());
		return $control;
	}

	protected function createComponentNavbar(): Navbar
	{
		$items = $this->parameters['category_menu'];
		$control = new Navbar('Kategorie', $items, 'cat');
		return $control;
	}
}
