resource_groups = {
  team1 = {
    resource_group_name     = "rg-team1-dev"
    location = "Central India"
    tags = {
      team = "team1"
      env  = "dev"
    }
  }

  team2 = {
    resource_group_name    = "rg-team2-dev"
    location = "East US"
    tags = {
      team = "team2"
      env  = "dev"
    }
  }
}