From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod 5/12]: Remove iSCSI includes from
	target_core_seobj.c
Date: Fri, 12 Dec 2008 01:32:15 -0800
Message-ID: <1229074335.4153.645.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:38019 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758703AbYLLJcS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2008 04:32:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

>From a4acf83dd5857c69d5b76f9ce703e57ff6cf9ba1 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 12 Dec 2008 00:52:04 -0800
Subject: [PATCH] [Target_Core_Mod]: Remove iSCSI includes from target_core_seobj.c

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_scdb.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/lio-core/target_core_scdb.c b/drivers/lio-core/target_core_scdb.c
index 62c3f1b..1ee4266 100644
--- a/drivers/lio-core/target_core_scdb.c
+++ b/drivers/lio-core/target_core_scdb.c
@@ -42,9 +42,6 @@
 #include <iscsi_linux_os.h>
 #include <iscsi_linux_defs.h>
 
-#include <iscsi_lists.h>
-#include <iscsi_protocol.h>
-#include <iscsi_target_core.h>
 #include <target_core_base.h>
 #include <target_core_hba.h>
 #include <target_core_transport.h>
-- 
1.5.4.1



