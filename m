From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] [Trivial Patch] scsi_register-001-002
Date: Fri, 08 Nov 2002 19:24:24 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021108083828.61D882C454@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: davidm@hpl.hp.com, linux-scsi@vger.kernel.org

From:  Michael Still <mikal@stillhq.com>

  
  Updated patches to scsi_register patches against the 2.5.45 tree
  
  
  
  

--- trivial-2.5-bk/arch/ia64/hp/sim/simscsi.c.orig	2002-11-08 18:47:01.000000000 +1100
+++ trivial-2.5-bk/arch/ia64/hp/sim/simscsi.c	2002-11-08 18:47:01.000000000 +1100
@@ -115,6 +115,9 @@
 {
 	templ->proc_name = "simscsi";
 	host = scsi_register(templ, 0);
+	if(host == NULL)
+		return 0;
+
 	return 1;	/* fake one SCSI host adapter */
 }
 
-- 
  Don't blame me: the Monkey is driving
  File: Michael Still <mikal@stillhq.com>: [Trivial Patch] scsi_register-001-002
