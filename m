From: Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 4/4] [SCSI] target: remove duplicated #include
Date: Fri, 28 Jan 2011 22:05:45 +0800
Message-ID: <1296223545-884-1-git-send-email-weiyi.huang@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:61579 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab1A1OGU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2011 09:06:20 -0500
Received: by pxi15 with SMTP id 15so447386pxi.19
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2011 06:06:20 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>

Remove duplicated #include('s) in
  drivers/target/target_core_hba.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/target/target_core_hba.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index 4bbe820..74d84f7 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -38,7 +38,6 @@
 
 #include <target/target_core_base.h>
 #include <target/target_core_device.h>
-#include <target/target_core_device.h>
 #include <target/target_core_tpg.h>
 #include <target/target_core_transport.h>
 
-- 
1.6.1.3

