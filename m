From: Michael Reed <mdr@sgi.com>
Subject: [PATCH] mpt fusion - add support for fibre channel FC949ES
Date: Thu, 12 Jan 2006 16:55:01 -0600
Message-ID: <43C6DE45.7040609@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030003030304090400060807"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:36032 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1161390AbWALWzJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2006 17:55:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, "Moore, Eric Dean" <Eric.Moore@lsil.com>

This is a multi-part message in MIME format.
--------------030003030304090400060807
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Add software recognition for the new LSI Logic Fibre Channel controller.
(Patch originally sent to me by Eric Moore.)


Signed-off-by: Michael Reed <mdr@sgi.com>



--------------030003030304090400060807
Content-Type: text/x-patch;
 name="lsi_949ES.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lsi_949ES.patch"

diff -ru a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c	2006-01-12 16:44:30.000000000 -0600
+++ b/drivers/message/fusion/mptbase.c	2006-01-12 16:08:15.000000000 -0600
@@ -1374,6 +1374,10 @@
 		ioc->bus_type = FC;
 		ioc->errata_flag_1064 = 1;
 	}
+	else if (pdev->device == MPI_MANUFACTPAGE_DEVICEID_FC949E) {
+		ioc->prod_name = "LSIFC949ES";
+		ioc->bus_type = FC;
+	}
 	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_53C1030) {
 		ioc->prod_name = "LSI53C1030";
 		ioc->bus_type = SPI;

--------------030003030304090400060807--
