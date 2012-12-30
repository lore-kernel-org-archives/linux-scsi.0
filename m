From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] [SCSI] mpt3sas: remove pointless version.h include from
 mpt3sas_trigger_diag.c
Date: Sun, 30 Dec 2012 01:14:29 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1212300112160.3366@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:35874 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab2L3AOc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Dec 2012 19:14:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, "James E.J. Bottomley" <JBottomley@parallels.com>, support@lsi.com, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, trivial@kernel.org

The file uses nothing from the header, so remove it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
index da6c5f2..6f8d621 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
@@ -42,7 +42,6 @@
  * USA.
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
-- 
1.7.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

