class Operations
    @@history = []
    @@last_id = 0
    def initialize(typ,account,amount)
        @id = @@last_id + 1
        @account = account
        @amount = amount
        @typ = typ

        @@history  << self
    end

    def id
        @id
    end
    def typ
        @typ        
    end
    def created_at
        @created_at        
    end
    def account
        @account        
    end

    def amount
        @amount
    end
    def self.all
        @@history
    end
end

class Account
    @@accounts = []
    @@last_account_number = 85001
    @@account_last_id = 0

    def initialize(user)
        @@account_last_id += 1 
        @@last_account_number += 1

        @id =  @@account_last_id
        @account_number =  @@last_account_number

        @account_state = true
        @account_blance = 0
        @user = user
        @@accounts << self
    end

    #depposer de l'argent
    def deposit(amount)
        if(@account_state && amount > 0)
            @account_blance += amount
            Operations.new("Dépot", self, amount)
            return {value: 1, msg: "Opération réussi !"}
        else
            return {value: 0, msg: "Opération échoué, compte déactivé ou montant invalide !"}
        end
    end

    #retirer de l'argent
    def pull(amount)
        if (amount <= 0)
            return {value:0, msg:"Montant invalide !"}
        end
        if(@account_state)
            if(@account_blance >= amount)
                @account_blance -= amount
                Operations.new("Retrait", self, amount)
                return {value:1, msg:"Compte céer avec succès !"}
            else
                return {value:0, msg:"Solde insuffisant !"}
            end
        else
            return {value:0, msg:"Ce compte est déactivé !"}
        end
    end

    #déactivé un compte
    def desable_account()
        @account_state = false
    end
    def active_account()
        @account_state = true
    end

    #recuperer le solde
    def balance
        @account_blance
    end
    def id
        @id
    end
    #propri
    def user
        @user
    end

    def number
       @account_number
    end
    
    def state
        @account_state
    end

    def self.get_all_account
        @@accounts
    end

    def self.search_account_by_number(number)
        account = @@accounts.find{|account| account.get_account_number() == number}
       return account
    end

    def self.search_account_by_user(name)
        accounts = [] 
        @accounts.each do |account|
            if(account.get_proprio() == name)
                accounts << account
            end
        end
        return accounts
    end
end

class User
    @@users = []
    @@last_id = 0

    def initialize(name)
        @@last_id+=1
        @name = name
        @id = @@last_id
        @@users << self
    end

    def id
        @id
    end
    def name
        @name
    end
    def add_account()
        account = Account.new(self)
        return account
    end

    def self.all
        @@users
    end
end


