From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] Comment out an unused function in drivers/scsi/wd7000.c
Date: Tue, 15 Jun 2004 09:30:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040615093024.7b30125a.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:55513 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S265756AbUFOQcd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 12:32:33 -0400
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>


Eliminate unused function wd7000_abort() in wd7000 driver.

  CC [M]  drivers/scsi/wd7000.o
drivers/scsi/wd7000.c:1612: warning: `wd7000_abort' defined but not used

As the author states in his comment, this is "unfinished business" ;-)


From: Mika Kukkonen <mika@osdl.org>
Signed-off-by: Randy Dunlap <rddunlap@osdl.org>


diffstat:=
 drivers/scsi/wd7000.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -Naurp ./drivers/scsi/wd7000.c~wd7k_abort ./drivers/scsi/wd7000.c
--- ./drivers/scsi/wd7000.c~wd7k_abort	2004-06-14 13:35:54.000000000 -0700
+++ ./drivers/scsi/wd7000.c	2004-06-15 08:49:13.000000000 -0700
@@ -1605,6 +1605,7 @@ static int wd7000_release(struct Scsi_Ho
 	return 0;
 }
 
+#if 0
 /*
  *  I have absolutely NO idea how to do an abort with the WD7000...
  */
@@ -1619,7 +1620,7 @@ static int wd7000_abort(Scsi_Cmnd * SCpn
 	}
 	return FAILED;
 }
-
+#endif
 
 /*
  *  I also have no idea how to do a reset...

