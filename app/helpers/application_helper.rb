module ApplicationHelper
  def sidebar_link(label, path, icon: nil)
    active = current_page?(path)
    css = active ?
      "bg-indigo-700 text-white" :
      "text-indigo-200 hover:text-white hover:bg-indigo-700"

    content_tag(:li) do
      link_to path, class: "group flex gap-x-3 rounded-md p-2 text-sm leading-6 font-semibold #{css}" do
        sidebar_icon(icon) + label
      end
    end
  end

  def sidebar_icon(name)
    icons = {
      "home" => "M2.25 12l8.954-8.955c.44-.439 1.152-.439 1.591 0L21.75 12M4.5 9.75v10.125c0 .621.504 1.125 1.125 1.125H9.75v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21h4.125c.621 0 1.125-.504 1.125-1.125V9.75M8.25 21h8.25",
      "users" => "M15 19.128a9.38 9.38 0 002.625.372 9.337 9.337 0 004.121-.952 4.125 4.125 0 00-7.533-2.493M15 19.128v-.003c0-1.113-.285-2.16-.786-3.07M15 19.128v.106A12.318 12.318 0 018.624 21c-2.331 0-4.512-.645-6.374-1.766l-.001-.109a6.375 6.375 0 0111.964-3.07M12 6.375a3.375 3.375 0 11-6.75 0 3.375 3.375 0 016.75 0zm8.25 2.25a2.625 2.625 0 11-5.25 0 2.625 2.625 0 015.25 0z",
      "calendar" => "M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0v-7.5A2.25 2.25 0 015.25 9h13.5A2.25 2.25 0 0121 11.25v7.5",
      "user-plus" => "M19 7.5v3m0 0v3m0-3h3m-3 0h-3m-2.25-4.125a3.375 3.375 0 11-6.75 0 3.375 3.375 0 016.75 0zM4 19.235v-.11a6.375 6.375 0 0112.75 0v.109A12.318 12.318 0 0110.374 21c-2.331 0-4.512-.645-6.374-1.766z",
      "tag" => "M9.568 3H5.25A2.25 2.25 0 003 5.25v4.318c0 .597.237 1.17.659 1.591l9.581 9.581c.699.699 1.78.872 2.607.33a18.095 18.095 0 005.223-5.223c.542-.827.369-1.908-.33-2.607L11.16 3.66A2.25 2.25 0 009.568 3z M6 6h.008v.008H6V6z",
      "settings" => "M9.594 3.94c.09-.542.56-.94 1.11-.94h2.593c.55 0 1.02.398 1.11.94l.213 1.281c.063.374.313.686.645.87.074.04.147.083.22.127.324.196.72.257 1.075.124l1.217-.456a1.125 1.125 0 011.37.49l1.296 2.247a1.125 1.125 0 01-.26 1.431l-1.003.827c-.293.24-.438.613-.431.992a6.759 6.759 0 010 .255c-.007.378.138.75.43.99l1.005.828c.424.35.534.954.26 1.43l-1.298 2.247a1.125 1.125 0 01-1.369.491l-1.217-.456c-.355-.133-.75-.072-1.076.124a6.57 6.57 0 01-.22.128c-.331.183-.581.495-.644.869l-.213 1.28c-.09.543-.56.941-1.11.941h-2.594c-.55 0-1.02-.398-1.11-.94l-.213-1.281c-.062-.374-.312-.686-.644-.87a6.52 6.52 0 01-.22-.127c-.325-.196-.72-.257-1.076-.124l-1.217.456a1.125 1.125 0 01-1.369-.49l-1.297-2.247a1.125 1.125 0 01.26-1.431l1.004-.827c.292-.24.437-.613.43-.992a6.932 6.932 0 010-.255c.007-.378-.138-.75-.43-.99l-1.004-.828a1.125 1.125 0 01-.26-1.43l1.297-2.247a1.125 1.125 0 011.37-.491l1.216.456c.356.133.751.072 1.076-.124.072-.044.146-.087.22-.128.332-.183.582-.495.644-.869l.214-1.281z M15 12a3 3 0 11-6 0 3 3 0 016 0z"
    }
    path_d = icons[name] || ""
    content_tag(:svg, content_tag(:path, nil, "stroke-linecap": "round", "stroke-linejoin": "round", d: path_d),
      class: "h-5 w-5 shrink-0", fill: "none", viewBox: "0 0 24 24", "stroke-width": "1.5", stroke: "currentColor")
  end

  def page_header(title, &block)
    content_for(:page_title) { title }
    content_tag(:div, class: "sm:flex sm:items-center sm:justify-between mb-6") do
      content_tag(:h2, title, class: "text-2xl font-bold text-gray-900") +
        (block ? capture(&block) : "".html_safe)
    end
  end

  def badge(text, color: "gray")
    colors = {
      "gray" => "bg-gray-100 text-gray-700",
      "green" => "bg-green-100 text-green-700",
      "red" => "bg-red-100 text-red-700",
      "yellow" => "bg-yellow-100 text-yellow-700",
      "blue" => "bg-blue-100 text-blue-700",
      "indigo" => "bg-indigo-100 text-indigo-700"
    }
    content_tag(:span, text, class: "inline-flex items-center rounded-full px-2 py-1 text-xs font-medium #{colors[color]}")
  end

  def appointment_status_badge(status)
    colors = { "scheduled" => "blue", "completed" => "green", "canceled" => "red", "no_show" => "yellow" }
    badge(status.humanize, color: colors[status] || "gray")
  end
end
