// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import UserSearchController from "./user_search_controller"
application.register("user-search", UserSearchController)

import ToggleSearchController from "./toggle_search_controller"
application.register("toggle-search", ToggleSearchController)
