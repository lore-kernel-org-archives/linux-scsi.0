From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] [Trivial Patch] scsi_register-003-002
Date: Fri, 08 Nov 2002 19:25:22 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021108083828.3F0A12C0B6@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, yokota@netlab.is.tsukuba.ac.jp

From:  Michael Still <mikal@stillhq.com>

  
  Updated patches to scsi_register patches against the 2.5.45 tree
  
  
  
  

--- trivial-2.5-bk/drivers/scsi/pcmcia/nsp_cs.c.orig	2002-11-08 18:47:02.000000000 +1100
+++ trivial-2.5-bk/drivers/scsi/pcmcia/nsp_cs.c	2002-11-08 18:47:02.000000000 +1100
@@ -1224,6 +1224,9 @@
 
 	request_region(data->BaseAddress, data->NumAddress, "nsp_cs");
 	host		  = scsi_register(sht, 0);
+	if(host == NULL)
+		return 0;
+
 	host->unique_id	  = data->BaseAddress;
 	host->io_port	  = data->BaseAddress;
 	host->n_io_port	  = data->NumAddress;
-- 
  Don't blame me: the Monkey is driving
  File: Michael Still <mikal@stillhq.com>: [Trivial Patch] scsi_register-003-002
