From: Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH] [SCSI] fcoe, libfcoe: remove duplicated #include
Date: Tue,  7 Apr 2009 06:59:02 +0800
Message-ID: <1239058742-2916-1-git-send-email-weiyi.huang@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.187]:51167 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691AbZDFW7N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2009 18:59:13 -0400
Received: by ti-out-0910.google.com with SMTP id i7so2147177tid.23
        for <linux-scsi@vger.kernel.org>; Mon, 06 Apr 2009 15:59:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>

Remove duplicated #include in drivers/scsi/fcoe/libfcoe.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/scsi/fcoe/libfcoe.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index f410f4a..6f63a89 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -29,7 +29,6 @@
 #include <linux/ethtool.h>
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
-#include <linux/netdevice.h>
 #include <linux/errno.h>
 #include <linux/bitops.h>
 #include <net/rtnetlink.h>
-- 
1.6.0.4

