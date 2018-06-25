## Day12 : form_for, 랜더링, Scaffold

### 복습

- `!(bang)`원본이 손상될 수 있거나, 사용자가 생각하는 방향과는 다른 결과값이 나올 수 있다는 것을 알려주기 위함
- **filter** : `before_action :set_post, only: [:show, :edit, :update, :destroy]`
- **1:n** : n쪽의 db에 user_id를 추가하고 controller에 정의하기 / `has many - belongs to`
- **method chaining** : Ex. (1..45).to_a.sample(6).sort





### form_for

참고자료 : https://apidock.com/rails/ActionView/Helpers/FormHelper/form_for



### 랜더링

- 원하는 곳에 원하는 데이터를 넣음

- 파편화 시켜 조립해 사용할 때, 파편화의 파일 이름을 `_`를 붙여 생성함 

  Ex. *_form.html.erb, _ad.html.erb, _ranking.html.erb*



분해된 파일에서 사용하고자 하는 변수명: 실제 변수명



### Scaffold

`$ rails d scaffold theme title:string contents:text `

*routes에서 `resources :themes`로 설정했을 때*

````
kyueun:~/daum_cafe_app (master) $ rake routes

    Prefix Verb   URI Pattern                Controller#Action
    themes GET    /themes(.:format)          themes#index
           POST   /themes(.:format)          themes#create
 new_theme GET    /themes/new(.:format)      themes#new
edit_theme GET    /themes/:id/edit(.:format) themes#edit
     theme GET    /themes/:id(.:format)      themes#show
           PATCH  /themes/:id(.:format)      themes#update
           PUT    /themes/:id(.:format)      themes#update
           DELETE /themes/:id(.:format)      themes#destroy

````

*routes에서 `resources :theme`로 설정했을 때*

```
kyueun:~/daum_cafe_app (master) $ rake routes
     Prefix Verb   URI Pattern               Controller#Action
theme_index GET    /theme(.:format)          theme#index
            POST   /theme(.:format)          theme#create
  new_theme GET    /theme/new(.:format)      theme#new
 edit_theme GET    /theme/:id/edit(.:format) theme#edit
      theme GET    /theme/:id(.:format)      theme#show
            PATCH  /theme/:id(.:format)      theme#update
            PUT    /theme/:id(.:format)      theme#update
            DELETE /theme/:id(.:format)      theme#destroy
```





### 간단과제. Scaffold를 사용하지 않고, CRUD 만들기

1. Model, Controller 만들기

   `rails g model board title, contents`

   `rails g controller boards show, edit, index, new`

2. *config/routes.rb*

   ```ruby
   # symbol을 사용해서 routes에서 url과 action을 연결함
   resources :boards
   ```

   위의 결과는 `$ rake routes`를 통해 아래의 결과를 사용할 수 있음

   ```command
   kyueun:~/crud_test $ rake routes
       Prefix Verb   URI Pattern                Controller#Action
       boards GET    /boards(.:format)          boards#index
              POST   /boards(.:format)          boards#create
    new_board GET    /boards/new(.:format)      boards#new
   edit_board GET    /boards/:id/edit(.:format) boards#edit
        board GET    /boards/:id(.:format)      boards#show
              PATCH  /boards/:id(.:format)      boards#update
              PUT    /boards/:id(.:format)      boards#update
              DELETE /boards/:id(.:format)      boards#destroy
   ```

3. *app/boards_controller.rb*

   ```ruby
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
   ```

   - 빈번하게 사용되는 코드를 `set_board`와 `board_params`로 묶어 사용함

     이때 filter인 `before_action :`를 통해 해당 메소드 실행 전에 반드시 먼저 사용되도록 설정함

   - ```ruby
     # @board = Board.new(title: params[:title], contents: params[:contents])와 동일함
     # @board = Board.new(board_params)로 줄여서 사용
     def board_params
     	{title: params[:title], contents: params[:contents]}
     end
     ```

   - ```ruby
     p1 = Post.new(title: params[:title], contents: params[:contents], user_id: current_user.id)
     p1.save
     
     # 위의 2줄을 한 줄로 아래와 같이 줄일 수 있음
     p1 = Post.create(title: params[:title], contents: params[:contents], user_id: current_user.id)
     ```

   

4. views 생성

   *views/index.html.erb*

   ```html
   <h2>목차</h2>
   <hr>
   <table>
       <thead>
           <tr>
               <th>Title</th>
               <th>Contents</th>
               <th colspan = "3"></th>
           </tr>
       </thead>
       <tbody>
           <% @boards.each do |board| %>
           <tr>
               <td><%= board.title %></td>
               <td><%= board.contents %></td>
               <td><%= link_to "보기", "/boards/#{board.id}" %></td>
               <td><%= link_to "수정", "/boards/#{board.id}/edit" %></td>
               <td><%= link_to "삭제", "/boards/#{board.id}", method: "delete" %></td>
           </tr>
           <% end %>
       </tbody>
   </table>
   ```

   

   *views/show.html.erb*

   ```html
   <h2>상세보기</h2>
   <%= @board.title %>
   <%= @board.contents %>
   <%= link_to "목록", "/boards" %>
   <%= link_to "수정", "/boards/#{@board.id}/edit" %>
   <%= link_to "삭제", "/boards/#{@board.id}", method: "delete" %>
   ```

   

   *views/edit.html.erb*

   ```html
   <%= form_tag("/boards/#{@board.id}", method: "patch") do %>
       <%= text_field_tag(:title, @board.title ) %>
       <%= text_area_tag(:contents, @board.contents) %>
       <%= submit_tag("등록") %>
       
   <% end %>
   ```

   

   *views/new.html.erb*

   ```html
   <%= form_tag("/boards") do %>
       <%= text_field_tag :title %>
       <%= text_area_tag :contents %>
       <%= submit_tag("등록") %>
   <% end %>
   ```

   - /boards ulr에서 `POST`형식일 때 실행되는  new.html.erb





> Today's Error
>
> - `create` 단에서 <%= form_tag("/boards/#{@board.id}) do %>의 오류는?
>
>   :  <%= form_tag("/boards") %>로 적어야 함, `rake routes`를 통해 봤을 때 `post '/boards' => 'boards#create'`으로 설정해두었기 때문에
>
> - <%= form_tag**(**"/boards/#{@board.id}"), method: "patch" do %> 에서 오류는?
>
>   : **(**"/boards/#{@board.id}", **method: "patch")**  괄호 잘 닫기