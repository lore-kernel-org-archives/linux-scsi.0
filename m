From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 10/11] mpt2sas v00.100.11.11 : scsiml Kconfig
Date: Tue, 3 Mar 2009 22:14:14 -0700
Message-ID: <20090304051412.GL4194@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og111.obsmtp.com ([64.18.2.175]:60884 "EHLO
	exprod7og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbZCDSyg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2009 13:54:36 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id n24IsXfd006120
	for <linux-scsi@vger.kernel.org>; Wed, 4 Mar 2009 10:54:33 -0800 (PST)
Received: from localhost (emoore-test1.co.lsil.com [172.21.46.33])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id n24IsbeU015717
	for <linux-scsi@vger.kernel.org>; Wed, 4 Mar 2009 10:54:37 -0800
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

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
