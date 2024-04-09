defmodule SuperStoreWeb.ProductLive.FormComponent do
  use SuperStoreWeb, :html

  attr :form, Phoenix.HTML.Form
  attr :rest, :global, include: ~w(phx-change phx-submit)
  slot :inner_block

  def render(assigns) do
    ~H"""
    <div class="bg-grey-100">
      <.form for={@form} class="flex flex-col max-w-96 mx-auto bg-gray-100 p-24" {@rest}>
        <%= render_slot(@inner_block) %>
        <.input field={@form[:name]} placeholder="Name" />
        <.input field={@form[:description]} placeholder="Description" />

        <.button type="submit">Send</.button>
      </.form>
    </div>
    """
  end
end
