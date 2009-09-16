From: Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 4/9] [SCSI] pmcraid: remove unused #include <linux/version.h>
Date: Wed, 16 Sep 2009 21:08:06 +0800
Message-ID: <1253106486-4008-1-git-send-email-weiyi.huang@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f190.google.com ([209.85.222.190]:59276 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbZIPNIU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Sep 2009 09:08:20 -0400
Received: by pzk28 with SMTP id 28so345988pzk.5
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2009 06:08:16 -0700 (PDT)
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
index 4302f06..8e161d4 100644
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

