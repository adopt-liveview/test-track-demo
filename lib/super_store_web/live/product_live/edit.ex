defmodule SuperStoreWeb.ProductLive.Edit do
  use SuperStoreWeb, :live_view
  alias SuperStore.Catalog
  alias SuperStoreWeb.ProductLive.FormComponent

  def mount(%{"id" => id}, _session, socket) do
    product = Catalog.get_product!(id)
    {:ok, assign(socket, product: product)}
  end

  def render(assigns) do
    ~H"""
    <.header>
      Editing Product <%= @product.id %>
      <:subtitle>Use this form to edit product records in your database.</:subtitle>
    </.header>

    <.live_component module={FormComponent} id={@product.id} product={@product} action={@live_action}>
      <h1>Editing a product</h1>
    </.live_component>

    <.back navigate={~p"/products/#{@product}"}>Back to product</.back>
    """
  end
end
