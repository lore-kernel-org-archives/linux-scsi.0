From: Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 4/6] [SCSI] remove unused #include <linux/version.h>
Date: Sun, 13 Dec 2009 22:05:55 +0800
Message-ID: <1260713155-4156-1-git-send-email-weiyi.huang@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:44074 "HELO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753445AbZLMOGS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Dec 2009 09:06:18 -0500
Received: by mail-pz0-f171.google.com with SMTP id 1so1720163pzk.33
        for <linux-scsi@vger.kernel.org>; Sun, 13 Dec 2009 06:06:18 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>

Remove unused #include <linux/version.h>('s) in
  drivers/scsi/pmcraid.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/scsi/pmcraid.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 34c6b89..164e808 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -38,7 +38,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/hdreg.h>
-#include <linux/version.h>
 #include <linux/io.h>
 #include <asm/irq.h>
 #include <asm/processor.h>
-- 
1.6.1.3

