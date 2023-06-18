$('#dataTable').DataTable( {
	"pageLength": 50,
	"responsive": true,
	"serverSide": true,
	"columnDefs": [ {
		"targets": 0,
		"render": function ( data ) {
		  var html = '<a href="../page.asp?islem=musteri&musteriadi='+data+'">'+data+'</a>';
		  return html
		}
	  },
	  
	  {
		"targets": 1,
		"render": function ( data ) {
		  var html =  '<a href="../page.asp?islem=urun&urunadi='+data+'">'+data+'</a>';
		  return html
		}
	  },

      {
        "targets": 3, // "musteri_teslim_tarihi" sütununun hedef indeksi (0'dan başlayarak)
        "render": function(data, type, row, meta) {
          if (type === 'display') {
            var tarihParcalari = data.split(" ");
            var sadeceTarih = tarihParcalari[0];
            return sadeceTarih;
          }
          return data;
        }
      }	  

	],
	"ajax": {
		url: '../Defaultapi.asp', 
		type: "POST",
		dataType: "json",
	},
	"processing": true,
	
		  "createdRow": function(row, data, dataIndex) {
			var teslimatDurumu = data['teslimatdurumu'];
			if (teslimatDurumu == 1) {
			  $(row).addClass('teslimatolumlu');
			}
		  },
		  
	"columns": [
	  { "data": "musteri_adi" },
	  { "data": "urun_adi" },
	  { "data": "urun_adet" },
	  { "data": "musteri_teslim_tarihi" },
	  { 
		"data": function(row) {
		  var cikis_depo = "";
		  if (row.cikis_deposu === "") {
			cikis_depo = row.teslim_deposu;
		  } else {
			cikis_depo = row.cikis_deposu;
		  }
		  return cikis_depo;
		}
	  },
	  { "data": "teslim_eden" }
]
} );
