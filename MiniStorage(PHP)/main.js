$(document).ready(function(){
    $('.file_delete').click(function(){
        console.log($(this).attr("value"));
        del_path = $(this).attr("value");
        // $.ajax({
        //     url: './storage_scripts/delete.php',
        //     data: {'file': del_path},
        //     success: function(response){
        //         console.log("success" + response);
        //         location.reload();
        //     }
        // });
    })
})