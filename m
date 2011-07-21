From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 078/103] loopback: Remove duplicate scsi/scsi_tcq.h include
Date: Thu, 21 Jul 2011 00:12:01 -0700
Message-ID: <1311232346-6674-79-git-send-email-nab@linux-iscsi.org>
References: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm30-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.126]:28381 "HELO
	nm30-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751926Ab1GUHIX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:08:23 -0400
In-Reply-To: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jesper Juhl <jj@chaosbits.net>

From: Jesper Juhl <jj@chaosbits.net>

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/loopback/tcm_loop.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 083d6c5..e53cec6 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -31,7 +31,6 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_tcq.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_transport.h>
-- 
1.7.6

