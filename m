From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: [PATCH] clean up drivers/scsi/scsi.h
Date: Mon, 14 Feb 2005 11:57:29 +0100
Message-ID: <200502141157.30447@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Received: from mail.sf-mail.de ([62.27.20.61]:36992 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S261392AbVBNKwa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Feb 2005 05:52:30 -0500
Received: from bilbo.math.uni-mannheim.de ([::ffff:134.155.88.153]) (auth=eike-kernel@sf-tec.de)
	by mail.sf-mail.de (Qsmtpd 0.3pre) with (RC4-MD5 encrypted) ESMTPSA
	for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2005 11:52:28 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi,

this patch removes some useless struct declarations from drivers/scsi/scsi.h.
All this structs are already defined in the header files included above
except Scsi_Host, for which we now directly include <scsi/scsi_host.h>

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

--- linux-2.6.10/drivers/scsi/scsi.h	2004-12-24 22:34:27.000000000 +0100
+++ linux-2.6.10/drivers/scsi/scsi.h-new	2005-02-14 11:45:54.000000000 +0100
@@ -28,6 +28,7 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_request.h>
 #include <scsi/scsi_tcq.h>
+#include <scsi/scsi_host.h>
 #include <scsi/scsi.h>
 
 /*
@@ -40,12 +41,6 @@
 #define FALSE 0
 #endif
 
-struct Scsi_Host;
-struct scsi_cmnd;
-struct scsi_device;
-struct scsi_target;
-struct scatterlist;
-
 /*
  * Legacy dma direction interfaces.
  *
