defmodule SuperStoreWeb.ProductLive.Index do
  use SuperStoreWeb, :live_view
  alias SuperStore.Catalog

  def mount(_params, _session, socket) do
    socket = stream(socket, :products, Catalog.list_products())
    {:ok, socket}
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
        <.link patch={~p"/products/new"}>
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
      <:action :let={{id, product}}>
        <.link
          phx-click={JS.push("delete", value: %{id: product.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>
    """
  end
end
