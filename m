From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 12/12] mpt2sas v00.100.11.15 : scsiml Makefile
Date: Mon, 9 Mar 2009 01:28:18 -0600
Message-ID: <20090309072817.GM18720@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og115.obsmtp.com ([64.18.2.217]:46150 "EHLO
	exprod7og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbZCIVHz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2009 17:07:55 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com

scsiml Makefile

Adding mptsas to the common scsi ml Makefile.

Signed-off-by: Eric Moore <eric.moore@lsi.com>
---

diff -uaprN a/drivers/scsi/Makefile b/drivers/scsi/Makefile
--- a/drivers/scsi/Makefile	2009-03-07 22:19:57.000000000 -0700
+++ b/drivers/scsi/Makefile	2009-03-07 22:33:48.000000000 -0700
@@ -99,6 +99,7 @@ obj-$(CONFIG_SCSI_DC390T)	+= tmscsim.o
 obj-$(CONFIG_MEGARAID_LEGACY)	+= megaraid.o
 obj-$(CONFIG_MEGARAID_NEWGEN)	+= megaraid/
 obj-$(CONFIG_MEGARAID_SAS)	+= megaraid/
+obj-$(CONFIG_SCSI_MPT2SAS)	+= mpt2sas/
 obj-$(CONFIG_SCSI_ACARD)	+= atp870u.o
 obj-$(CONFIG_SCSI_SUNESP)	+= esp_scsi.o	sun_esp.o
 obj-$(CONFIG_SCSI_GDTH)		+= gdth.o
