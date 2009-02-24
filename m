From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 10/11] mpt2sas: scsiml Kconfig
Date: Tue, 24 Feb 2009 02:42:07 -0700
Message-ID: <20090224094205.GA11845@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og110.obsmtp.com ([64.18.2.173]:39177 "EHLO
	exprod7og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572AbZBXXXt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Feb 2009 18:23:49 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com

scsiml Kconfig

Adding mptsas to the common scsi ml Kconfig.

Signed-off-by: Eric Moore <eric.moore@lsi.com>
---

--- a/drivers/scsi/Kconfig	2008-11-03 11:37:52.000000000 -0700
+++ b/drivers/scsi/Kconfig	2008-11-03 11:37:18.000000000 -0700
@@ -568,6 +568,7 @@ config SCSI_ARCMSR_AER
 	  To enable this function, choose Y here.
 
 source "drivers/scsi/megaraid/Kconfig.megaraid"
+source "drivers/scsi/mpt2sas/Kconfig"
 
 config SCSI_HPTIOP
 	tristate "HighPoint RocketRAID 3xxx/4xxx Controller support"
