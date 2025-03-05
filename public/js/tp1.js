
const defaultTitle = "Bienvenu sur AlphaCode"
const title = document.getElementById('title')
const newTitle = document.getElementById('newTitle')
const btnChangeTitle = document.getElementById("btnChangeTitle")
const btnResetTitle = document.getElementById('btnResetTitle')
const selectCouleur = document.getElementById('couleur')

const containTodo = document.getElementById('containTodo')
const btnAddTodo = document.getElementById('add')
const todos = ["Apprendre ruby","Apprendre tailwind","Apprendre JS"]
const newTodo = document.getElementById('todo')

showTodo()


title.innerHTML = defaultTitle

btnChangeTitle.addEventListener('click',function(){
    title.innerHTML = newTitle.value
})
btnResetTitle.addEventListener('click',function(){
    title.innerHTML = defaultTitle
})
selectCouleur.addEventListener('change',function(){
    title.style.color = selectCouleur.value
})

btnAddTodo.addEventListener('click',function(){
    todos.push(newTodo.value)
    showTodo()
})

function showTodo(){
    containTodo.innerHTML = ""
    todos.forEach((v,i)=>{
        let item = document.createElement('li')
        item.style.color = "black"
        item.innerHTML = `<li class="flex items-center space-x-2">
        <button class="del bg-red-500 hover:bg-red-700 py-0 px-2">x</button>
        <span class="text-gray-700">${v}</span>
    </li>`
        containTodo.append(item)
    })

    let dels = document.getElementsByClassName("del");

    Array.from(dels).forEach((btn) => {
        btn.addEventListener('click', function() {
            btn.parentElement.remove();
        });
    });
}