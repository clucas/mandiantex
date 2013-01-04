require 'will_paginate/array'

class MediaItemsController < ApplicationController
  # GET /media_items
  # GET /media_items.json
  def index
    params[:search] = {} unless params[:search]
    init_search_sort
    @media_items = MediaItem.search(params[:search].merge({:page => params[:page], :per_page => 10}))
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @media_items }
    end
  end

  # GET /media_items/1
  # GET /media_items/1.json
  def show
    @media_item = MediaItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @media_item }
    end
  end

  # # GET /media_items/new
  # # GET /media_items/new.json
  # def new
  #   @media_item = MediaItem.new
  # 
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.json { render json: @media_item }
  #   end
  # end
  # 
  # # GET /media_items/1/edit
  # def edit
  #   @media_item = MediaItem.find(params[:id])
  # end
  # 
  # # POST /media_items
  # # POST /media_items.json
  # def create
  #   @media_item = MediaItem.new(params[:media_item])
  # 
  #   respond_to do |format|
  #     if @media_item.save
  #       format.html { redirect_to @media_item, notice: 'Media item was successfully created.' }
  #       format.json { render json: @media_item, status: :created, location: @media_item }
  #     else
  #       format.html { render action: "new" }
  #       format.json { render json: @media_item.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # PUT /media_items/1
  # # PUT /media_items/1.json
  # def update
  #   @media_item = MediaItem.find(params[:id])
  # 
  #   respond_to do |format|
  #     if @media_item.update_attributes(params[:media_item])
  #       format.html { redirect_to @media_item, notice: 'Media item was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: "edit" }
  #       format.json { render json: @media_item.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # DELETE /media_items/1
  # # DELETE /media_items/1.json
  # def destroy
  #   @media_item = MediaItem.find(params[:id])
  #   @media_item.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to media_items_url }
  #     format.json { head :no_content }
  #   end
  # end
  
  private
  
  def init_search_sort
    if params[:sort].to_s.start_with?("title")
      title_direction = params[:sort].to_s.split("!").first
      title_direction.slice!("title_")
      params[:search][:sort] = {}
      params[:search][:sort][:title] = title_direction
    end
    if params[:sort].to_s.start_with?("author")
      author_direction = params[:sort].to_s.split("!").first
      author_direction.slice!("author_")
      params[:search][:sort] = {}
      params[:search][:sort][:author] = author_direction
    end
    if params[:sort].to_s.start_with?("unit_cost")
      price_direction = params[:sort].to_s.split("!").first
      price_direction.slice!("unit_cost_")
      params[:search][:sort] = {}
      params[:search][:sort][:price] = price_direction
    end
  end
  
  # def price_sort
  #   if params[:sort].to_s.start_with?("unit_cost")
  #     unit_cost_direction = params[:sort].to_s.split("!").first
  #     unit_cost_direction.slice!("unit_cost_")
  #     @media_items = price_direction_sort(unit_cost_direction)
  #   end
  # end
  # 
  # def price_direction_sort(direction)
  #   @media_items = direction.eql?("asc") ? @media_items.sort{|a,b|a.price<=>b.price} : @media_items.sort{|a,b|a.price<=>b.price}.reverse!
  #   @media_items = @media_items.paginate(:page => params[:page], :per_page => 10)
  # end
end
