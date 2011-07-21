From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 066/103] target: Fix transport_generic_new_cmd WRITE comment
Date: Thu, 21 Jul 2011 00:11:49 -0700
Message-ID: <1311232346-6674-67-git-send-email-nab@linux-iscsi.org>
References: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm8-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.95]:34830 "HELO
	nm8-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752200Ab1GUHG7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:06:59 -0400
In-Reply-To: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Remove fabric dependent language in transport_generic_new_cmd()

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9fc017e..6f2855d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4786,7 +4786,7 @@ int transport_generic_new_cmd(struct se_cmd *cmd)
 	}
 
 	/*
-	 * For WRITEs, let the iSCSI Target RX Thread know its buffer is ready..
+	 * For WRITEs, let the fabric know its buffer is ready..
 	 * This WRITE struct se_cmd (and all of its associated struct se_task's)
 	 * will be added to the struct se_device execution queue after its WRITE
 	 * data has arrived. (ie: It gets handled by the transport processing
-- 
1.7.6

