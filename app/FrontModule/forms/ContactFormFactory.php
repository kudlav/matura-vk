<?php
declare(strict_types=1);

namespace App\FrontModule\Forms;

use Nette;
use Nette\Application\UI\Form;
use Nette\Mail\Message;
use Nette\Mail\SendmailMailer;
use Nette\Application\UI\Presenter;
use Nette\Utils\ArrayHash;


class ContactFormFactory
{
	use Nette\SmartObject;

	/**
	 * @var string $operator_email
	 * @var Presenter $presenter
	 */
	private $operator_email, $presenter;

	public function __construct(string $operator_email, Presenter $presenter)
	{
		$this->operator_email = $operator_email;
		$this->presenter = $presenter;
	}

	/**
	 * @return Form
	 */
	public function create(): Form
	{
		$form = new Form;

		$form->addText('email','Váš email:')
			->setAttribute('class','form-input')
			->addRule(Form::EMAIL, 'Zadejte platnou emailovou adresu.')
			->setRequired('Zadejte váš email');

		$form->addText('customer','Vaše jméno:')
			->setAttribute('class','form-input')
			->setRequired('Zadejte vaše jméno');

		$form->addTextArea('message','Váš dotaz:')
			->setAttribute('class','frm-note form-input')
			->setRequired('Zadejte váš dotaz');

		$form->addSubmit('send','Poslat email')
			->setAttribute('class','form-button');

		$form->onSuccess[] = array($this, 'onSuccess');
		return $form;
	}


	public function onSuccess(Form $form, ArrayHash $values): void
	{
		$mail = new Message();
		$mail->setFrom('IIShop <'.$this->operator_email.'>')
			->addTo($this->operator_email)
			->setSubject('[IIShop] - dotaz od '.$values->customer)
			->setBody('Zákazník '.$values->customer.' ('.$values->email.')\n\n'.$values->message);

		$mailer = new SendmailMailer();
		$mailer->send($mail);

		$this->presenter->flashMessage('Zpráva byla odeslána');
		$this->presenter->redirect('this');
	}
}
