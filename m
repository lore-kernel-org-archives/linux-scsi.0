From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/8] qla2xxx: Remove semaphore.h
Date: Wed, 13 Aug 2008 21:36:55 -0700
Message-ID: <1218688622-71361-1-git-send-email-andrew.vasquez@qlogic.com>
References: <20080814043632.GL61889@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:57982 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbYHNEhE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Aug 2008 00:37:04 -0400
In-Reply-To: <20080814043632.GL61889@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Matthew Wilcox <matthew@wil.cx>

From: Matthew Wilcox <matthew@wil.cx>

Now that qla2xxx has been converted to mutexes, it no longer needs the
semaphore include.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 6da31ba..8c5b25c 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -25,7 +25,6 @@
 #include <linux/firmware.h>
 #include <linux/aer.h>
 #include <linux/mutex.h>
-#include <linux/semaphore.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
-- 
1.6.0.rc2.22.g71b9

