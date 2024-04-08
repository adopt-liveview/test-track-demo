defmodule SuperStoreWeb.ProductLive.Show do
  use SuperStoreWeb, :live_view
  alias SuperStore.Catalog

  def handle_params(%{"id" => id}, _uri, socket) do
    product = Catalog.get_product!(id)
    socket = assign(socket, product: product)
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>
      Product <%= @product.id %>
      <:subtitle>This is a product record from your database.</:subtitle>
    </.header>

    <.list>
      <:item title="Name"><%= @product.name %></:item>
      <:item title="Description"><%= @product.description %></:item>
    </.list>

    <.back navigate={~p"/"}>Back to products</.back>
    """
  end
end
