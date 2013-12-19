From: Bradley Grove <bgrove@attotech.com>
Subject: [PATCH 0/2] pm80xx: Fix ATTO pm8001 based HBA support
Date: Thu, 19 Dec 2013 10:50:55 -0500
Message-ID: <1387468257-3177-1-git-send-email-bgrove@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:12269 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754740Ab3LSPva (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2013 10:51:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, xjtuwjp@gmail.com, vasanthalakshmi.tharmarajan@pmcs.com, suresh.thiagarajan@pmcs.com, viswas.g@pmcs.com, Bradley Grove <bgrove@attotech.com>

Addresses issues that we uncovered during testing with our HBAs.
For the most part, we just enabled code that was already being used 
for other vendor's HBAs.

Bradley Grove (2):
  pm80xx: Read saved WWN from NVMD for ATTO pm8001 based HBAs.
  pm80xx: Enable BAR shift to avoid BIOS conflict with MPI space for    
    ATTO pm8001 based HBAs.

 drivers/scsi/pm8001/pm8001_hwi.c  |  6 +++---
 drivers/scsi/pm8001/pm8001_init.c | 10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

-- 
1.8.3.1

