class Admin::OrganizationsController < ApplicationController
  def index
    @organizations = Organization.page(params[:page])
  end

  def show
    @organization = Organization.find_by(id: params[:id])
  end

  def new
    @organization = Organization.new
  end

  def edit
    @organization = Organization.find_by(id: params[:id])
  end

  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      redirect_to admin_organization_url(@organization), notice: "Organization was successfully created."
    else
      render :new
    end
  end

  def update
    @organization = Organization.find_by(id: params[:id])
    if @organization.update(organization_params)
      redirect_to admin_organization_url(@organization)
    else
      render :edit
    end
  end

  def destroy
    @organization = Organization.find_by(id: params[:id])
    @organization.destroy
    redirect_to admin_organizations_path
  end

  private

  def organization_params
    params.require(:organization).permit(:name)
  end
end
