<?php

namespace App\FrontModule\Model;

use Nette;


/**
 * Cart management.
 */
class CartManager extends Nette\Object
{
	const
		TABLE_BASKETS = 'baskets',
		TABLE_PRODUCTS = 'products',
		COLUMN_USERS_ID = 'users_id',
		COLUMN_PRODUCTS_ID = 'products_id',
		COLUMN_QUANTITY = 'quantity';


	/** @var Nette\Database\Context */
	private $database;


	public function __construct(Nette\Database\Context $database)
	{
		$this->database = $database;
	}

	/**
	 * Return number of items in cart of user.
	 * @param int $userId
	 * @return int
	 */
	public function getCount($userId)
	{
		$query = $this->database->table(self::TABLE_BASKETS)->where(self::COLUMN_USERS_ID, $userId);

		$ret = 0;
		foreach ($query as $row) {
			$ret+= $row->quantity;
		}
		return $ret;
	}

	/**
	 * Return total price of cart of user.
	 * @param int $userId
	 * @return int
	 */
	public function getPrice($userId)
	{
		$query = $this->database->table(self::TABLE_BASKETS)->where(self::COLUMN_USERS_ID, $userId);

		$ret = 0;
		foreach ($query as $row) {
			$ret+= $row->quantity * $row->products->price;
		}
		return $ret;
	}

	/**
	 * Return array of items in cart of user.
	 * @param int $userId
	 * @return array
	 */
	public function getItems($userId)
	{
		$query = $this->database->table(self::TABLE_BASKETS)->where(self::COLUMN_USERS_ID, $userId);

		$ret = array();
		foreach ($query as $row) {
			$ret[]= [
				'id' => $row->products_id,
				'count' => $row->quantity,
				'name' => $row->products->name,
				'quantity' => $row->products->quantity,
				'price' => $row->products->price,
				'show' => $row->products->show,
			];
		}
		return $ret;
	}

	/**
	 * Remove product from user cart.
	 * @param $userId
	 * @param $productId
	 * @return int Return number of removed products.
	 */
	public function removeItem($userId, $productId)
	{
		$state = $this->database->table(self::TABLE_BASKETS)
			->where(self::COLUMN_USERS_ID." = ? AND ".self::COLUMN_PRODUCTS_ID." = ?", $userId, $productId)
			->delete();
		return $state;
	}

	/**
	 * Add product from database to user basket or increase quantity.
	 * @param $userId
	 * @param $productId
	 * @return int Return number of added products.
	 */
	public function addItem($userId, $productId)
	{
			$product = $this->database->table(self::TABLE_PRODUCTS)->get($productId);
			if ($product && $product->show) {
				$basket = $this->database->table(self::TABLE_BASKETS)
					->where(self::COLUMN_USERS_ID." = ? AND ".self::COLUMN_PRODUCTS_ID." = ?", $userId, $productId)->fetch();
				if ($basket) {
					$basket->update(array(
						'quantity' => $basket->quantity + 1,
					));
				} else {
					$state = $this->database->table(self::TABLE_BASKETS)->insert(array(
						self::COLUMN_USERS_ID => (int)$userId,
						self::COLUMN_PRODUCTS_ID => (int)$productId,
						self::COLUMN_QUANTITY => (int) 1,
					));
				}
				return 1;
			}
			return 0;
	}
}