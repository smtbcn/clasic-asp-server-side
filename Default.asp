<%
	'Veritabanı bağlantı bilgileri.
	host		= ""
	dbuser 		= ""
	dbsifre 	= ""
	db 			= ""

	Set conn = Server.CreateObject("ADODB.Connection") 
	conn.Open "DRIVER={MySQL ODBC 3.51 Driver}; SERVER="&host&"; UID="&dbuser&"; pwd="&dbsifre&"; db="&db&"; option=16387;" 
%>

<!DOCTYPE html>
<html lang="en">

<head>

</head>

<body id="page-top">


	
	
    <!-- Page Wrapper -->
    <div id="wrapper">
	
        <!-- Content Wrapper -->
        <div id="content-wrapper" class="d-flex flex-column">
            <!-- Main Content -->
			
            <div id="content">
			
                <!-- Begin Page Content -->
                <div class="container-fluid">
                    <!-- Page Heading -->
                    <!-- DataTales Example -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered" id="dataTable" width="100%" cellspacing="0">
                                    <thead>
                                        <tr>
                                            <th class="min-width">Müşteri Adı</th>
                                            <th class="min-width">Ürün Adı</th>
                                            <th>Ürün Adedi</th>
                                            <th>Teslim Tarihi</th> 
                                            <th>Çıkış Deposu</th>
                                            <th class="min-width">Teslim Eden</th>
                                        </tr>
                                    </thead>

                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- /.container-fluid -->
            </div>
            <!-- End of Main Content -->
        </div>
        <!-- End of Content Wrapper -->
    </div>
    <!-- End of Page Wrapper -->

</body>
</html>
