From: Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 4/6] [SCSI] cxgb3i: remove unused #include <linux/version.h>
Date: Fri, 12 Mar 2010 22:13:26 +0800
Message-ID: <1268403206-5072-1-git-send-email-weiyi.huang@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:63596 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab0CLONm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2010 09:13:42 -0500
Received: by fxm19 with SMTP id 19so1194903fxm.21
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2010 06:13:41 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>

Remove unused #include <linux/version.h>('s) in
  drivers/scsi/cxgb3i/cxgb3i_offload.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/scsi/cxgb3i/cxgb3i_offload.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
index 3e08c43..dd4fba5 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
@@ -13,7 +13,6 @@
  */
 
 #include <linux/if_vlan.h>
-#include <linux/version.h>
 
 #include "cxgb3_defs.h"
 #include "cxgb3_ctl_defs.h"
-- 
1.6.1.3

