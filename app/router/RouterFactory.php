<?php
declare(strict_types=1);

namespace App;

use Nette;
use Nette\Application\IRouter;
use Nette\Application\Routers\RouteList;
use Nette\Application\Routers\Route;


class RouterFactory
{

	/**
	 * @return IRouter
	 */
	public static function createRouter(): IRouter
	{
		$router = new RouteList;
		$router[] = new Route('kontakty', 'Front:Info:kontakty');
		$router[] = new Route('obchodni-podminky', 'Front:Info:podminky');
		$router[] = new Route('doprava-platba', 'Front:Info:nakup');
		$router[] = new Route('produkt/<id [0-9A-Za-z]+>', 'Front:Product:default');

		$router[] = new Route('administrace/<presenter>/<action>[/<id>]', array(
			'module' => 'Admin',
			'presenter' => 'Homepage',
			'action' => 'default',
		));

		$router[] = new Route('<presenter>/<action>[/<id>]', array(
			'module' => 'Front',
			'presenter' => 'Homepage',
			'action' => 'default',
		));
		return $router;
	}

}
