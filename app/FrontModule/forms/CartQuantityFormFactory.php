<?php
declare(strict_types=1);

namespace App\FrontModule\Forms;

use App\Model\CartManager;
use Nette;
use Nette\Application\UI\Form;
use Nette\Application\UI\Presenter;
use Nette\Utils\ArrayHash;


class CartQuantityFormFactory
{
	use Nette\SmartObject;

	/**
	 * @var CartManager $cartManager
	 * @var Presenter $presenter
	 */
	private $cartManager, $presenter;

	public function __construct(CartManager $cartManager, Presenter $presenter)
	{
		$this->cartManager = $cartManager;
		$this->presenter = $presenter;
	}

	/**
	 * @param array $items
	 * @return Form
	 */
	public function create(array $items): Form
	{
		$form = new Form;

		foreach ($items as $item) {
			$form->addText('i'.$item['id'])
				->setValue($item['count'])
				->setRequired(true)
				->addRule(Form::INTEGER, 'Zadejte celé číslo, větší než 0.');
		}

		$form->addSubmit('recalc', 'Přepočítat')
			->setAttribute('class','submit');

		$form->onSuccess[] = [$this, 'formSucceeded'];
		return $form;
	}

	/**
	 * @param Form $form
	 * @param ArrayHash $values
	 */
	public function formSucceeded(Form $form, ArrayHash $values): void
	{
		if ($this->presenter->isAjax()) {
			foreach ($values as $id => $value) {
				if(!$this->cartManager->addItem($this->presenter->user->id, str_replace('i', '', $id), $value)){
					$this->presenter->flashMessage('Chyba, množství musí být celé číslo, větší než 0.','flash-error');
				}
			}
			$this->presenter->redrawControl('flashMessage');
			$this->presenter->redrawControl('cartCards');
			$this->presenter->redrawControl('total');
			$this->presenter->redrawControl('cart');
		}
	}

}
