#Isogram
def verif_isogram(mots)

  except = ['-'," "]

  if mots==nil
    return false
  end
  
  letters = mots.downcase.chars
  
  letters.each do |lettre|
      nbre = 0
      letters.each do |l|
          if ! except.include?(l)
              if lettre==l
                  nbre += 1
              end
          end
      end
      if nbre> 1
          return false
      end
  end
  return true
end

#calculatrice
OPERATORS = ["plus", "moins","divisé","multiplié"]

def calculatrice(operation)
  if operation==nil
    return "Vous n'avez rien saisi encore ..."
  end
  if is_string(operation)
    return "Désolé, votre expression n'est que du text !"
  end

  operateur_trouver = []

  nombre_trouver = []

  ooperation = operation.split

  ooperation.each do |op|
    if OPERATORS.include?(op)
      operateur_trouver << op
    end
    if is_numeric(op)
      nombre_trouver << op.to_f
    end
  end

  #gestion des expressions incorrects
  if(operateur_trouver.size >= nombre_trouver.size)
    return "Le nombre d'opérateurs doit etre strictement inférieur au nombre d'opérants !"
  end
  if (nombre_trouver.size != operateur_trouver.size+1)
    return "Vous avez un nombre insuffisant d'opérateurs dans votre expression !"
  end
  expression = []
  nombre_trouver.each_with_index do |n,i|
    expression << n.to_f
    expression << operateur_trouver[i]
  end
  expression.pop

  # Démarrer avec la première valeur
  resultat = expression[0]

  #puts "Expressiom : #{expression.inspect}"
  # Parcourir le tableau et appliquer les opérations
  (1...expression.length).step(2) do |i|
    operateur = expression[i]
    nombre = expression[i + 1]
    case operateur
    when "plus"
      resultat += nombre
    when "moins"
      resultat -= nombre
    when "multiplié"
      resultat *= nombre
    when "divisé"
      resultat /= nombre
    end
  end
  #puts expression.inspect
  
  return "Le resultat est : #{resultat}"

end

def is_string(str)
  return !!str.match(/\A[a-zA-Z?.:!; ]+\z/)
end
def is_numeric(chaine)
  return !!(chaine =~ /\A[-+]?\d+(\.\d+)?\z/) 
end

def adn(adn1,adn2)

  if(adn1==nil or adn2==nil)
    return "Désolé, veuillez saisr les 2 ADN ..."
  end

  adn1_upper = adn1.upcase
  adn2_upper = adn2.upcase

  distance = 0

  len = adn1_upper.length

  if adn1_upper.length == adn2_upper.length
    i = 0
    while i < len
      if adn1_upper[i] != adn2_upper[i]
        distance += 1
       end
       i += 1
    end
    return "La distance entre ces deux ADN est : #{distance}"
  else
    return "Les deux ADN ne sont pas de meme longeur !"
  end
end


Students = []

Max_grade = 10

def qurey(q)
  q= q.downcase.split

  verb = q[0]

  case verb
  when "add"
    name = q[1]
  	grade = q[4].to_i
    if name != "" and (grade > 0 and grade <= Max_grade)
      Students.push({:name=>name,:grade=>grade})
      puts "OK student saved"
    end
    
  when "which"
    if q.index("grade")
      grade = q[q.index("grade")+1].to_i

      #cherche des eleve de cette classe
      students = []
      Students.each do |std|
        if std[:grade].to_i == grade
          students.push(std)
        end
      end

      if(students.size==1)
        puts "We've only got #{students[0][:name]} right now."
      else
        names = ""
        students.each do |std|
          names+="#{std[:name]}, "
        end
        puts "We've got #{names}"
      end
    end
  when "who"
    names = ""
    Students.each do |std|
      names += "#{std[:name]} in grade #{std[:grade]}, "
    end
    puts "Let me think : #{names}"
  end
end

def help(text)

  colors = ["black","brown","red","orange", "yellow", "green", "blue", "violet", "grey", "white"]

  if text != nil 
    data = text.downcase.split("-")

    col1 = data[0]

    if data.length > 2
      col2 = data[-1]
    else
      col2 = data[1]
    end
    

    puts col1
    puts col2

    result = ""
    if colors.find_index(col1)
      result += colors.find_index(col1).to_s
    end
    if colors.find_index(col2)
      result += colors.find_index(col2).to_s
    end

    if result != ""
      return "Le resultat est : #{result.to_i}"
    else
      return "Aucun resultat possible"
    end
  else
    return "Vous n'avez encore rien saisi .."
  end
  
end

def record(text)
  colors = ["black","brown","red","orange", "yellow", "green", "blue", "violet", "grey", "white"]
  if text != nil 
    data = text.downcase.split("-")
    
    if data.length == 3
      col1 = data[0]
      col2 = data[1]
      col3 = data[2]
    else
      return "Vous devez saisir 3 couleur"
    end
    
    nbre_zeo = colors.find_index(col3).to_i

    result = ""

    result += colors.find_index(col1).to_s
    result += colors.find_index(col2).to_s

    result += '0' * nbre_zeo
    
    if result != ""
      return "Le resultat est : #{result.to_i}"
    else
      return "Aucun resultat possible"
    end
  else
    return "Vous n'avez encore rien saisi .."
  end
end
