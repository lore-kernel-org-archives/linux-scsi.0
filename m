From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH v2 3/5] aic7xxx: remove rules for shipped files
Date: Fri, 04 Aug 2017 01:28:09 +0200
Message-ID: <759ba18717a785f8875b74efe01ba26920d55006.1501802727.git.mirq-linux@rere.qmqm.pl>
References: <cover.1501802726.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([91.227.64.183]:35142 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751940AbdHCX2L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Aug 2017 19:28:11 -0400
In-Reply-To: <cover.1501802726.git.mirq-linux@rere.qmqm.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

There are Kbuild rules for that already.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 drivers/scsi/aic7xxx/Makefile | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/aic7xxx/Makefile b/drivers/scsi/aic7xxx/Makefile
index b03ba0df7a83..1a5509d40f8a 100644
--- a/drivers/scsi/aic7xxx/Makefile
+++ b/drivers/scsi/aic7xxx/Makefile
@@ -61,8 +61,6 @@ $(obj)/aic7xxx_seq.h: $(src)/aic7xxx.seq $(src)/aic7xxx.reg $(obj)/aicasm/aicasm
 
 $(aic7xxx-gen-y): $(objtree)/$(obj)/aic7xxx_seq.h
 	@true
-else
-$(obj)/aic7xxx_reg_print.c: $(src)/aic7xxx_reg_print.c_shipped
 endif
 
 aic79xx-gen-$(CONFIG_AIC79XX_BUILD_FIRMWARE)	:= $(obj)/aic79xx_reg.h
@@ -79,8 +77,6 @@ $(obj)/aic79xx_seq.h: $(src)/aic79xx.seq $(src)/aic79xx.reg $(obj)/aicasm/aicasm
 
 $(aic79xx-gen-y): $(objtree)/$(obj)/aic79xx_seq.h
 	@true
-else
-$(obj)/aic79xx_reg_print.c: $(src)/aic79xx_reg_print.c_shipped
 endif
 
 $(obj)/aicasm/aicasm: $(srctree)/$(src)/aicasm/*.[chyl]
-- 
2.11.0
