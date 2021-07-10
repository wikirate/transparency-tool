LINK_TARGET_HOST = "https://wikirate.org"

FIELDS = ["name", "country_name", "revenue", "location", "owned_by", "profit",
  "number_of_workers", "top_production_countries"]

SCORE_MAP = {
  living_wage_score: {
    "E": 1
    "D": 2
    "C": 3
    "B": 4
    "A": 5
  }
  transparency_score: {
    "0.0": 1
    "2.5": 2
    "5.0": 3
    "7.5": 4
    "10.0": 5
  }
  commitment_score: {
    "No": 1,
    "Partial": 2,
    "Yes": 3,
    "Yes, Other": 3,
    "Yes, ACT": 3,
    "Yes, Fair Wear Foundation": 3,
  }
}
class window.BrandInfo
  constructor: (@data) ->

  render: ($output) ->
    data = @data
    $template = $(".template._brand-item").clone()
    $template.removeClass("template")

    $template.find("._wikirate-link").attr("href", wikirateUrl(data.id))

    for index, name of FIELDS
      $template.find("._#{name}").text(data[name])

    selectImage($template.find("._living-wage-score"), "wage_score", data.scores.living_wage)
    transparencyScore($template, data.scores.transparency)
    commitmentScore($template, "public-commitment", data.scores.commitment.public_commitment)
    commitmentScore($template, "action-plan", data.scores.commitment.action_plan)
    commitmentScore($template, "isolating-labour-cost", data.scores.commitment.isolating_labour_cost)

    $template.find("._commitment-total-score").text(data.scores.commitment.total)

    tweetTheBrand $template.find("._tweet-the-brand"), data.twitter_handle
    showScoreDesc($template, "living_wage", data.scores.living_wage_key)
    showScoreDesc($template, "transparency", data.scores.transparency_key)

    showLogo $template.find("._logo"), data.logo

    for index, brand of data.brands
      addBrand brand, $template
    $output.append $template

  showScoreDesc = ($template, score_name, score_key) ->
    $template.find("._#{score_name}_score-text").text scoreTranslation[score_key]

  # scoreClass = (score_name, score_value ) ->
  #  "_score-#{SCORE_MAP[score_name][score_value]}"

  transparencyScore = ($template, score) ->
    return unless (stars = SCORE_MAP["transparency_score"][score])
    current = 1
    while (current <= stars)
      starImg = $template.find "._transparency-stars ._star-#{current}"
      selectImage starImg, "transparency_score", "star_solid", "svg"
      current++

  commitmentScore = ($el, name, value) ->
    $el.find("._#{name}").text(value)
    $el.find("._#{name}-help").attr("data-target", "##{name}-score-#{SCORE_MAP.commitment_score[value]}")
    value = "Yes" if value.includes("Yes")
    selectImage($el.find("._#{name}-smiley"), "smiley", value, "svg")

  showLogo = (tag, url) ->
    if url
      tag.attr "src", url
    else
      tag.hide()

  selectImage = ($el, folder, score, ext) ->
    ext ||= "png"
    $el.attr("src", "/images/#{folder}/#{score}.#{ext}")


  addBrand = (brand, $container) ->
    $container.find("#brands").append $("<li>#{brand}</li>")



  tweetTheBrand = (link, handle) ->
    if handle
      tweetText = "#{handle}\n#{window.location.href} #LivingWageNow"
      tweetUrl = link.attr("href") + $.param({ text: tweetText })
      link.attr "href", tweetUrl
      link.show()
    else
      link.hide()



  wikirateUrl = (company_id) ->
    "#{LINK_TARGET_HOST}/~#{company_id}?contrib=N" +
      "&filter%5Bwikirate_topic%5D%5B%5D=Filling%20the%20Gap"
