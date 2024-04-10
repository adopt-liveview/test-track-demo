defmodule SuperStoreWeb.ProductLive.FormComponent do
  use SuperStoreWeb, :live_component
  alias SuperStore.Catalog
  alias SuperStore.Catalog.Product

  def update(%{product: product} = assigns, socket) do
    form =
      Product.changeset(product)
      |> to_form()

    {:ok,
     socket
     |> assign(form: form)
     |> assign(assigns)}
  end

  def handle_event("validate", %{"product" => product_params}, socket) do
    form =
      socket.assigns.product
      |> Product.changeset(product_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    case socket.assigns.action do
      :new ->
        case Catalog.create_product(product_params) do
          {:ok, product} ->
            {:noreply,
             socket
             |> put_flash(:info, "Product created successfully")
             |> push_navigate(to: ~p"/")}

          {:error, %Ecto.Changeset{} = changeset} ->
            form = to_form(changeset)
            {:noreply, assign(socket, form: form)}
        end

      :edit ->
        case Catalog.update_product(socket.assigns.product, product_params) do
          {:ok, product} ->
            {:noreply,
             socket
             |> put_flash(:info, "Product updated successfully")
             |> push_navigate(to: ~p"/products/#{product.id}/edit")}

          {:error, %Ecto.Changeset{} = changeset} ->
            form = to_form(changeset)
            {:noreply, assign(socket, form: form)}
        end
    end
  end

  def render(assigns) do
    ~H"""
    <div class="bg-grey-100">
      <.form
        for={@form}
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="flex flex-col max-w-96 mx-auto bg-gray-100 p-24"
      >
        <%= render_slot(@inner_block) %>
        <.input field={@form[:name]} placeholder="Name" />
        <.input field={@form[:description]} placeholder="Description" />

        <.button type="submit">Send</.button>
      </.form>
    </div>
    """
  end
end
