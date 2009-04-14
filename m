From: Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 1/2] [SCSI] mpt2sas: remove unused #include <linux/version.h>
Date: Wed, 15 Apr 2009 06:30:45 +0800
Message-ID: <1239748245-3144-1-git-send-email-weiyi.huang@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.191]:48228 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbZDNWax (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2009 18:30:53 -0400
Received: by ti-out-0910.google.com with SMTP id 11so356837tim.23
        for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2009 15:30:52 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com, support@lsi.com
Cc: DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>

Remove unused #include <linux/version.h> in drivers/scsi/mpt2sas/mpt2sas_base.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index a91f514..ce0e085 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -42,7 +42,6 @@
  * USA.
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
-- 
1.6.1.2

