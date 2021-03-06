require 'rack-flash'

class SongsController < ApplicationController
  use Rack::Flash
  get '/songs' do
    @songs = Song.all 
    erb :'/songs/index'
  end

  get '/songs/new' do
    @genres = Genre.all 
    erb :'/songs/new'
  end

  get '/songs/:slug/edit' do
    @song = Song.find_by_slug(params[:slug])
    erb :'/songs/edit'
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    erb :'/songs/show'
  end

  post '/songs' do
    @artist = Artist.find_or_create_by(name: params[:artist][:name])
    @genre = Genre.find(params[:genres])
    @song = Song.create(name: params[:song][:name], artist: @artist)
    @song.genres << @genre
    @song.save

    flash[:message] = "Successfully created song."
    redirect to "/songs/#{@song.slug}"
  end

  patch '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    @artist = Artist.find_or_create_by(name: params[:artist][:name])
    @song.genres.clear
    @song.name = params[:song][:name]
    @song.artist = @artist
    params[:genres].each do |genre|
      @song.genres << Genre.find(genre)
    end

    @song.save

    flash[:message] = "Successfully updated song."
    redirect to "/songs/#{@song.slug}"
  end
end