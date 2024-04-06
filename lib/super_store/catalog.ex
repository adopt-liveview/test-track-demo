defmodule SuperStore.Catalog do
  alias SuperStore.Repo
  alias SuperStore.Catalog.Product

  def create_product(attrs) do
    Product.changeset(%Product{}, attrs)
    |> Repo.insert()
  end
end
