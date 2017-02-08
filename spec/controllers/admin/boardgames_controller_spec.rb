require "rails_helper"

RSpec.describe Admin::BoardgamesController, type: :controller do
  login_user
  describe "GET #index" do
    it "populates an array of all boardgames" do
      carcassonne = create(:boardgame, name: "Carcassonne")
      catan       = create(:boardgame, name: "Los Colonos de Catan")
      get :index
      expect(assigns(:boardgames)).to match_array([carcassonne, catan])
    end
    it "renders the :index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    it "assigns the requested boardgame to @boardgame" do
      boardgame = create(:boardgame)
      get :show, params: { id: boardgame }
      expect(assigns(:boardgame)).to eq(boardgame)
    end
    it "renders the :show template" do
      boardgame = create(:boardgame)
      get :show, params: { id: boardgame }
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    it "assigns a new Boardgame to @boardgame" do
      get :new
      expect(assigns(:boardgame)).to be_a_new(Boardgame)
    end
    it "renders the :new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "GET #edit" do
    it "assigns the requested boardgame to @boardgame" do
      boardgame = create(:boardgame)
      get :edit, params: { id: boardgame }
      expect(assigns(:boardgame)).to eq(boardgame)
    end
    it "renders the :edit template" do
      boardgame = create(:boardgame)
      get :edit, params: { id: boardgame }
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new boardgame at database" do
        expect do
          post :create, params:
            { boardgame: attributes_for(:boardgame) }
        end.to change(Boardgame, :count).by(1)
      end
      it "redirects to boardgames#show" do
        post :create, params: { boardgame: attributes_for(:boardgame) }
        expect(response).to redirect_to(admin_boardgame_path(assigns(:boardgame)))
      end
    end
    context "with invalid attributes" do
      it "not to save the new boardgame at database" do
        expect do
          post :create, params:
            { boardgame: attributes_for(:invalid_boardgame) }
        end.not_to change(Boardgame, :count)
      end
      it "re-renders the new template" do
        post :create, params: { boardgame: attributes_for(:invalid_boardgame) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    before :each do
      @boardgame = create(:boardgame, name: "Catan", maxplayers: 4)
    end

    context "with valid attributes" do
      it "finds the requested @boardgame" do
        patch :update, params: { id: @boardgame, boardgame: attributes_for(:boardgame) }
        expect(assigns(:boardgame)).to eq(@boardgame)
      end
      it "updates the @boardgame in the database" do
        patch :update, params: { id: @boardgame, boardgame: attributes_for(
          :boardgame,
          name: "Aventureros al tren",
          maxplayers: 5
        ) }
        @boardgame.reload
        expect(@boardgame.name).to eq("Aventureros al tren")
        expect(@boardgame.maxplayers).to eq(5)
      end

      it "redirects to the boardgame" do
        patch :update, params: { id: @boardgame, boardgame: attributes_for(:boardgame) }
        expect(response).to redirect_to(admin_boardgame_path(@boardgame))
      end
    end
    context "with invalid attributes" do
      it "not to update the boardgame" do
        patch :update, params: { id: @boardgame, boardgame: attributes_for(
          :boardgame,
          name: "Aventureros al tren",
          maxplayers: nil
        ) }
        @boardgame.reload
        expect(@boardgame.name).not_to eq("Aventureros al tren")
        expect(@boardgame.maxplayers).to eq(4)
      end
      it "re-renders the edit template" do
        patch :update, params: { id: @boardgame, boardgame: attributes_for(:invalid_boardgame) }
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      @boardgame = create(:boardgame, name: "Catan", maxplayers: 4)
    end
    it "deletes the boardgame from the database" do
      expect do
        delete :destroy, params: { id: @boardgame }
      end.to change(Boardgame, :count).by(-1)
    end
    it "redirects to boardgames#index" do
      delete :destroy, params: { id: @boardgame }
      expect(response).to redirect_to admin_boardgames_path
    end
  end
end
