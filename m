From: Yokota Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Subject: [PATCH 4/13] nsp32, nsp_cs driver update
Date: Tue, 22 Feb 2005 16:06:04 +0900 (JST)
Message-ID: <20050222.160604.104096809.yokota@netlab.is.tsukuba.ac.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Received: from pixy-gw.netlab.cs.tsukuba.ac.jp ([130.158.83.98]:45326 "HELO
	pixy.netlab.cs.tsukuba.ac.jp") by vger.kernel.org with SMTP
	id S262228AbVBVHGG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Feb 2005 02:06:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--- linux-2.6.10/drivers/scsi/Kconfig	2005-02-22 08:23:09.000000000 +0900
+++ linux-2.6.10-nsp/drivers/scsi/Kconfig	2005-02-22 08:37:48.000000000 +0900
@@ -1474,6 +1474,22 @@
 	  SCSI host adapter. Please read the SCSI-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
+	  Supported cards
+
+	  NinjaSCSI-32Bi (in CardBus mode):
+	    I-O DATA CBSC-II      (Vender ID: 0x10fc, Device ID: 0x0005)
+	    HP M820e CDRW's card  (Vender ID: 0x1145, Device ID: 0xf007)
+	    KME KXL-820AN's card  (Vender ID: 0x1145, Device ID: 0xf007)
+	    Melco IFC-USCB2
+	    SONY PCGA-DVD51
+	    etc.
+
+	  NinjaSCSI-32UDE:
+	    I-O DATA SC-NBD
+	    Logitec LHA-600S
+	    Melco IFC-USLP
+	    etc.
+
 	  To compile this driver as a module, choose M here: the
 	  module will be called nsp32.
 
