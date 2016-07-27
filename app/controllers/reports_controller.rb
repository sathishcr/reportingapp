class ReportsController < ApplicationController
	before_filter :signed_in_user
	before_filter :before_creating_reports, only: :create

	def create
		if @report.save
			flash[:success] = "Report posted!"
			redirect_to root_url
		else
			render 'static_pages/home'
		end
	end

	def destroy

	end
	private
		def before_creating_reports
			@report = current_user.reports.build(params[:report])
		end
end