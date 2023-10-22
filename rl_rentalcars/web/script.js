


$("img").attr("draggable","false")


$(document).on("click", ".box", function() {
    let $el = $(this);
    let isActive = $el.hasClass("active");
    $(".box").removeClass("active");
    if (!isActive) $el.addClass("active");
});


function alugar(dom) {
    if (Navigator.onLine) return
    const name = $(".active").find(".nome h1").text()
    console.log(name)
    $.post(`https://${GetParentResourceName()}/RentCars`,JSON.stringify({
        name:name
    }))
}

window.addEventListener('message', ({ data }) => {
    if (data.open != undefined) {
        if (data.open) {
            console.log(data.image)
            $('main').show()
            $('.elements').append(`
            <div class = "box">
                <div class="infos">
                    <div class="nome">
                        <div class="preco">
                            <h1>${data.name}</h1>
                        </div>
                        <div class="preco">
                            <p>R$</p>
                            <p>${Number(data.price).toLocaleString("pt-br")}</p>
                        </div>
                    </div>
                    <div class="carro">
                        <img src="http://${data.SvImage}/${data.image}.png">
                    </div>
                </div>
            </div>
            `)
        } else {
            $('main').hide()
            $('.elements').html("")
        }
    }
}) 

function fechar() {
    $('.elements').html("")
    $("main").hide()
	$.post(`https://${GetParentResourceName()}/Close`)
}

$(document).on('keyup', function (e) {
	if (e.which == 27) {
        $.post(`https://${GetParentResourceName()}/Close`)
	}
});