$.fn.select2.defaults.set("theme", "bootstrap4")

API_HOST = "https://dev.wikirate.org"
# API_HOST = "https://wikirate.org"
WIKIRATE_AUTH = "wikirate:wikirat"
SUPPLIER_METRIC_ID = 2929009 # Commons+Supplied By
SUPPLIER_PROJECT_ID = 7611147

if WIKIRATE_AUTH
  $.ajaxSetup(
    beforeSend: (xhr) ->
      xhr.setRequestHeader "Authorization", "Basic " + btoa(WIKIRATE_AUTH)
  )

BRAND_LIST_URL = "#{API_HOST}/company.json?view=brands_select2"
BRANDS_ANSWERS_URL = "content/brand_answers.json"

BRANDS_METRIC_MAP = {
  location: 5456201,
  transparency_score: 5780639,
  living_wages_score: 5990097,
  action_plan: 5768881,
  policy_promise_score: 5780757,
  isolating_labor: 5768917
}

SUPPLIERS_METRIC_MAP = {
  location: 5456201,
  female: 3233894,
  male: 3233883,
  other: 6019448,
  permanent: 6019621,
  temporary: 6019632,
  average: 6019687,
  gap: 7347357,
  cba: 6020927,
  know_brand: 6019511,
  pregnancy: 6019786
}


window.FC = {}

$(document).ready ->
  prepareSearch()
  prepareFlipCards()

  params = new URLSearchParams(window.location.search)
  if params.has "q"
    loadBrandInfo params.get "q"
  else
    loadBrandsTable()

#~~~~~~~~ FLIP CARDS ~~~~~~~~~~

prepareFlipCards = () ->
  $("body").on "click", ".flip-card", ->
  $(this).toggleClass("flipped")

#~~~~~~~~ SEARCH ~~~~~~~~~~

prepareSearch = () ->
  loadSearchOptions()
  activateSearch()

loadSearchOptions = () ->
  $.ajax(url: BRAND_LIST_URL, dataType: "json").done (data) ->
    $("._brand-search").select2(
      placeholder: "search for brand"
      allowClear: true
      data: data["results"]
    ).val(null).trigger('change')

activateSearch = () ->
  $("body").on "change", "._brand-search", ->
    selected = $("._brand-search").select2("data")
    if (selected.length > 0)
      company_id = selected[0].id
      if $(this).data("redirect")?
        redirectSearch company_id
      else
        loadBrandInfo company_id

redirectSearch = (company_id) ->
  href = "/brand-profile.html?q=#{company_id}"
  current = window.location.href
  if /(\/$|html)/.test current
    prefix = "."
  else
    prefix = current
  window.location.href = prefix + href

#~~~~~~~~ BRANDS ~~~~~~~~~~

loadBrandsTable = () ->
  $.ajax(url: BRANDS_ANSWERS_URL, dataType: "json").done((data) ->
    FC.companyTable data,"#brands-table", BRANDS_METRIC_MAP
  )

loadBrandInfo = (company_id) ->
  $.ajax(url: brandInfoURL(company_id), dataType: "json").done((data) ->
    $output = $("#result")
    $output.empty()

    new BrandInfo(data).render($output)
    $('[data-toggle="popover"]').popover()

    $.ajax(url: supplierURL(company_id), dataType: "json").done((data) ->
      FC.companyTable data,"#suppliers-table", SUPPLIERS_METRIC_MAP
    )
  )

supplierURL = (company_id) ->
  query = $.param(
    limit: 0,
    filter: {
      relationship: {
        company_id: company_id,
        metric_id: SUPPLIER_METRIC_ID
      },
      project_metric: "~#{SUPPLIER_PROJECT_ID}"
    }
  )
  "#{API_HOST}/Answer/compact.json?#{query}"


brandInfoURL = (company_id) ->
  "#{API_HOST}/~#{company_id}.json?view=transparency_info"

# filter: {
#   relationship: { company_id: (brand), metric_id: (commons_supplier_of) },
#   project_metric: projec
