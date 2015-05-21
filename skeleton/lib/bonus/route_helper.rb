module RouteHelper
  def get_url_helper(action)
    regex = /(new_|edit_)*(\w+)_url\(*(\d+)*\)*/
    matchdata = action.match(regex)

    prefix = matchdata[1]
    resource = matchdata[2]
    id = matchdata[3]

    url = if prefix
            if prefix == "new_"
              "\"\/#{resource}s\/new\""
            elsif prefix == "edit_"
              "\"\/#{resource}s\/#{id}\/edit\""
            end
          else
            if id
              "\"\/#{resource}s\/#{id}\""
            else
              "\"\/#{resource}\""
            end
          end
  end
end
