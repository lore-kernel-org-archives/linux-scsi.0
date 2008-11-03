From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 11/12] mpt2sas - scsi-ml Kconfig
Date: Mon, 3 Nov 2008 01:42:23 -0700
Message-ID: <20081103084221.GA3402@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:40712 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbYKCWgH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Nov 2008 17:36:07 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id mA3MUwMn019651
	for <linux-scsi@vger.kernel.org>; Mon, 3 Nov 2008 14:30:58 -0800 (PST)
Received: from localhost (emoore-test1.co.lsil.com [172.21.46.33])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id mA3Ma7FW008554
	for <linux-scsi@vger.kernel.org>; Mon, 3 Nov 2008 14:36:07 -0800
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Adding mptsas.

Signed-off-by: Eric Moore <eric.moore@lsi.com>

--- a/drivers/scsi/Kconfig	2008-11-03 11:37:52.000000000 -0700
+++ b/drivers/scsi/Kconfig	2008-11-03 11:37:18.000000000 -0700
@@ -568,6 +568,7 @@ config SCSI_ARCMSR_AER
 	  To enable this function, choose Y here.
 
 source "drivers/scsi/megaraid/Kconfig.megaraid"
+source "drivers/scsi/mpt2sas/Kconfig"
 
 config SCSI_HPTIOP
 	tristate "HighPoint RocketRAID 3xxx/4xxx Controller support"
