# @return [{ name: name, metric_id1: val, metric_id2: val ...}]
companies = (data) ->
  companies = {}

  $.each data.companies, (id, name) ->
    companies[id] = { name: name }

  $.each data.answers, (_id, hash) ->
    companies[hash["company"]][hash["metric"]] = hash["value"]

  companies

#companyLink = (name, id) ->
#  "<a class='red' target='_wikirate' href=\"#{LINK_TARGET_HOST}/~#{id}\">#{name}</a>"


FC.companyTable = (data, tableSelector, metricMap) ->
  @data = data
  @table = $(tableSelector)
  @metricMap = metricMap

  @render = () ->
    return unless @table[0]

    @tbody = @table.children "tbody"
    @addRows()
    @table.DataTable autoWidth: false

  @addRows = () ->
    t = this
    $.each companies(@data), (_id, companyHash) ->
      t.addRow companyHash

  @addRow = (hash) ->
    t = this
    cells = [@td hash["name"]]
    $.each @metricMap, (_key, id) ->
      val = hash[id] || "-"
      cells.push t.td(val)

    @tbody.append "<tr>#{cells.join()}</tr>"

  @td = (cell_content)->
    "<td>" + cell_content + "</td>"

  @render()
