require "./views/tp bank systeme/bank"
enable :sessions

$file = "./views/tp bank systeme/bank.json"


def get_data()
    db = JSON.parse(File.read($file))

    #création des utilisateurs existant dans le json
    db["users"].each do |u|
        user = User.new(u["name"])
        #création des comptes de l utlisateur'
        db["accounts"].each do |acc|

            if (acc["user"] == u["id"])
                account = user.add_account()

                 #les opération du compte
                db["operations"].each do |op|

                    if(op["account"]==acc["id"])
                        if(op["typ"]=="Dépot")
                            account.deposit(op["amount"])
                        else
                            account.pull(op["amount"])
                        end
                    end
                end
            end
        end
    end
    #puts db.inspect
end

def persiste_data()
    my_json = {
        "users" => [],
        "accounts" => [],
        "operations" => []
    }

    Account.get_all_account.each do |account|
        my_json["accounts"] << {
            "id"=>account.id,
            "account_number" => account.number,
            "account_state" => account.state,
            "account_blance" => account.balance,
            "user" => account.user.id
        }
    end

    User.all.each do |user|
        my_json["users"] << {
            "id"=>user.id,
            "name" => user.name,
        }
    end

    Operations.all.each do |op|
        my_json["operations"] << {
            "id"=>op.id,
            "typ" => op.typ,
            "amount" => op.amount,
            "account" => op.account.id,
        }
    end

    #puts my_json.inspect

    File.write($file, JSON.pretty_generate(my_json))
end

get_data()


get '/bank' do

    @success_message = session.delete(:success_message)
    @error_message = session.delete(:error_message)

    search_user = params["name"] ? params["name"] : ''
    search_account = params["account_number"] ? params["account_number"].to_i : ''

    accounts = if search_account==''
        Account.get_all_account
      else
        Account.get_all_account.find_all { |account| account.number == search_account }
      end

    users = if search_user==''
        User.all
        else
            User.all.find_all { |user| user.name == search_user }
        end

    operations = Operations.all

    erb :"tp bank systeme/bank", locals:{accounts: accounts, users:users, operations:operations, search_user: search_user}
end

get '/bank/account/:id/setstate' do
    id = params[:id].to_i
    account = Account.get_all_account.find{|account| account.id == id}

    account.state ? account.desable_account() : account.active_account()
    
    persiste_data()

    redirect '/bank'
end

#effectuer une operation (dépot / rerait)
post '/bank/operation' do
    accound_id = params["account_id"].to_i
    amount = params["amount"].to_i
    typ = params["type"]

    account = Account.get_all_account.find{|account| account.id == accound_id}

    result = typ == "Dépot" ? account.deposit(amount) : account.pull(amount)
    persiste_data()
   if(result[:value]==1)
    session[:success_message] = "Opération réussie : #{typ} de #{amount} FCFA sur le compte #{account.number}"
    else
    session[:error_message] = result[:msg]
   end
    redirect '/bank'
end

post '/bank/add_user' do

    name = params["name"]

    User.new(name)

    session[:success_message] = "Utilisateur créer avec succès !"
    
    persiste_data()

    redirect '/bank'
end

#creation compte
get '/bank/user/:id/create_account' do
    user_id = params["id"].to_i
    user = User.all.find{|user| user.id==user_id}

    if(user)
        account = user.add_account()
        session[:success_message] = "Compte créer avec succès sous le numéro #{account.number}, propriétaire #{account.user.name} !"
    
        persiste_data()

    end
    
    redirect '/bank'
end

get '/bank/user/:id' do
    user_id = params[:id].to_i
    user = User.all.find { |u| u.id == user_id }

    if user
        accounts = Account.get_all_account.select { |acc| acc.user.id == user_id }
        erb :"tp bank systeme/user_details", locals: { user: user, accounts: accounts }
    else
        session[:error_message] = "Utilisateur non trouvé."
        redirect '/bank'
    end
end