defmodule SuperStoreWeb.ProductLive.Edit do
  use SuperStoreWeb, :live_view
  alias SuperStore.Catalog
  alias SuperStore.Catalog.Product
  alias SuperStoreWeb.ProductLive.FormComponent

  def mount(%{"id" => id}, _session, socket) do
    product = Catalog.get_product!(id)

    form =
      Product.changeset(product)
      |> to_form()

    {:ok, assign(socket, form: form, product: product)}
  end

  def handle_event("validate_product", %{"product" => product_params}, socket) do
    form =
      Product.changeset(socket.assigns.product, product_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save_product", %{"product" => product_params}, socket) do
    socket =
      case Catalog.update_product(socket.assigns.product, product_params) do
        {:ok, %Product{} = product} ->
          put_flash(socket, :info, "Product ID #{product.id} updated!")

        {:error, %Ecto.Changeset{} = changeset} ->
          form = to_form(changeset)

          socket
          |> assign(form: form)
          |> put_flash(:error, "Invalid data!")
      end

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>
      Editing Product <%= @product.id %>
      <:subtitle>Use this form to edit product records in your database.</:subtitle>
    </.header>

    <FormComponent.render form={@form} phx-change="validate_product" phx-submit="save_product">
      <h1>Editing a product</h1>
    </FormComponent.render>

    <.back navigate={~p"/products/#{@product}"}>Back to product</.back>
    """
  end
end
