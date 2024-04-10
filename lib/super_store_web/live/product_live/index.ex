defmodule SuperStoreWeb.ProductLive.Index do
  use SuperStoreWeb, :live_view
  alias SuperStore.Catalog
  alias SuperStoreWeb.ProductLive.FormComponent
  alias SuperStore.Catalog.Product

  def mount(_params, _session, socket) do
    socket = stream(socket, :products, Catalog.list_products())
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    product = Catalog.get_product!(id)
    assign(socket, product: product)
  end

  defp apply_action(socket, :index, _params) do
    assign(socket, product: nil)
  end

  defp apply_action(socket, :new, _new) do
    product = %Product{}
    assign(socket, product: product)
  end

  def handle_event("delete", %{"id" => id}, socket) do
    product = Catalog.get_product!(id)
    {:ok, _} = Catalog.delete_product(product)

    {:noreply, stream_delete(socket, :products, product)}
  end

  def render(assigns) do
    ~H"""
    <.header>
      Listing Products
      <:actions>
        <.link patch={~p"/new"}>
          <.button>New Product</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="products"
      rows={@streams.products}
      row_click={fn {_id, product} -> JS.navigate(~p"/products/#{product}") end}
    >
      <:col :let={{_id, product}} label="Name"><%= product.name %></:col>
      <:col :let={{_id, product}} label="Description"><%= product.description %></:col>
      <:action :let={{_id, product}}>
        <.link patch={~p"/#{product}/edit"}>Quick Edit</.link>
      </:action>
      <:action :let={{id, product}}>
        <.link
          phx-click={JS.push("delete", value: %{id: product.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal :if={@live_action in [:edit, :new]} id="product-modal" show on_cancel={JS.patch(~p"/")}>
      <.live_component
        module={FormComponent}
        id="quick-edit-form"
        product={@product}
        action={@live_action}
        patch={~p"/"}
      >
        <h1>Editing a product</h1>
      </.live_component>
    </.modal>
    """
  end
end
