defmodule SuperStoreWeb.ProductLive.New do
  use SuperStoreWeb, :live_view
  import SuperStoreWeb.CoreComponents
  alias SuperStore.Catalog
  alias SuperStore.Catalog.Product
  alias SuperStoreWeb.ProductLive.FormComponent

  def mount(_params, _session, socket) do
    form =
      Product.changeset(%Product{})
      |> to_form()

    {:ok, assign(socket, form: form)}
  end

  def handle_event("validate_product", %{"product" => product_params}, socket) do
    form =
      Product.changeset(%Product{}, product_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("create_product", %{"product" => product_params}, socket) do
    socket =
      case Catalog.create_product(product_params) do
        {:ok, %Product{} = product} ->
          put_flash(socket, :info, "Product ID #{product.id} created!")

        {:error, %Ecto.Changeset{} = changeset} ->
          form = to_form(changeset)

          socket
          |> assign(form: form)
          |> put_flash(:error, "Invalid product!")
      end

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>
      New Product
      <:subtitle>Use this form to create product records in your database.</:subtitle>
    </.header>

    <FormComponent.render form={@form} phx-change="validate_product" phx-submit="create_product">
      <h1>Creating a product</h1>
    </FormComponent.render>

    <.back navigate={~p"/"}>Back to products</.back>
    """
  end
end
