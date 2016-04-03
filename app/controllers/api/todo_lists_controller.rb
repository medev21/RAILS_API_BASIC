class Api::TodoListsController < ApplicationController
	skip_before_filter :verify_authenticity_token
	def index
    render json: TodoList.all
  end

	def show
		list = TodoList.find(params[:id])
		# render json: list only shows list
		render json: list.as_json(include:[:todo_items])
		#this is how you want to include associations, add more associations in the array
		#to include one thing do this below
		# render json: list.as_json(include: :todo_items)

	end

	def create
		list = TodoList.new(list_params)
		if list.save
			render status: 200, json: {
				message: "Successfully created to-do list",
				todo_list: list
			}.to_json
			#give sucessful message in json
		else
			render status: 422, json: {
				errors: list.errors
			}.to_json
			#this give error message in json
		end
	end

	def destroy
		list = TodoList.find(params[:id])
		list.destroy
		render status: 200, json: {
			message: "Successfully deleted todo list"
		}.to_json
	end

	def update
		list = TodoList.find(params[:id])
		if list.update(list_params)
			render status: 200, json: {
				message: "Successfully updated to-do list",
				todo_list: list
			}.to_json
		else
			render status: 422, json: {
				message: "Todo list could not be updated",
				todo_list: list
			}.to_json
		end
	end

	private
		def list_params
			params.require("todo_list").permit("title")
		end
end
