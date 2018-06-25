class BoardsController < ApplicationController
    before_action :set_board, only: [:show, :edit, :update, :destroy]
    
    def index
        @boards = Board.all 
    end
    
    def show
    end
    
    def new
    end
    
    def create
        @board = Board.new(board_params)
        if @board.save
            redirect_to "/boards/#{@board.id}"
        else
            redirect_to :back
        end
    end
    
    def edit
    end
    
    def update
        if @board.update(board_params)
            redirect_to "/boards/#{@board.id}"
        else
            redirect_to :back
        end
        
    end
    
    def destroy
        @board.destroy
        @board.save
        redirect_to "/boards"
    end
    
    private
    
    def set_board
        @board = Board.find(params[:id])
    end
    
    def board_params
        {title: params[:title], contents: params[:contents]}
    end
    
    
end
