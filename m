From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 10/12] mpt2sas v00.100.11.15 : scsiml Kconfig
Date: Mon, 9 Mar 2009 01:27:06 -0600
Message-ID: <20090309072705.GK18720@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og112.obsmtp.com ([64.18.2.177]:58886 "EHLO
	exprod7og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbZCIVGv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2009 17:06:51 -0400
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
