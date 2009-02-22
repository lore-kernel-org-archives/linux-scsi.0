From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH] MTP FUSION: resending patch to disable MSI interrupt by defualt.
Date: Sun, 22 Feb 2009 16:19:18 +0530
Message-ID: <20090222104911.GA6142@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og111.obsmtp.com ([64.18.2.175]:38769 "EHLO
	exprod7og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbZBVLLK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Feb 2009 06:11:10 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

This Patch is submitted to with reference to MSI issue with some of LSI
controller. Disabling it by default when module is loaded. 
---

Signed-off-by: Kashyap Desai <kadesai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 96ac883..ea3aafb 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -91,9 +91,9 @@ MODULE_PARM_DESC(mpt_msi_enable_fc, " Enable MSI Support for FC \
 		controllers (default=0)");
 
 static int mpt_msi_enable_sas;
-module_param(mpt_msi_enable_sas, int, 1);
+module_param(mpt_msi_enable_sas, int, 0);
 MODULE_PARM_DESC(mpt_msi_enable_sas, " Enable MSI Support for SAS \
-		controllers (default=1)");
+		controllers (default=0)");
 
 
 static int mpt_channel_mapping;
