defmodule SuperStore.Catalog do
  alias SuperStore.Repo
  alias SuperStore.Catalog.Product

  def list_products() do
    Product
    |> Repo.all()
  end

  def get_product!(id), do: Repo.get!(Product, id)

  def create_product(attrs) do
    Product.changeset(%Product{}, attrs)
    |> Repo.insert()
  end

  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end
end
