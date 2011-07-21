From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 003/103] target: use MAINTENANCE_IN and MAINTENANCE_OUT definitions in scsi.h
Date: Thu, 21 Jul 2011 00:04:39 -0700
Message-ID: <1311231979-6631-4-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm11-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.136]:29094 "HELO
	nm11-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752086Ab1GUHFw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:05:52 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 4b9b716..1882251 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3325,7 +3325,7 @@ static int transport_generic_cmd_sequencer(
 			goto out_unsupported_cdb;
 		}
 		break;
-	case 0xa3:
+	case MAINTENANCE_IN:
 		if (TRANSPORT(dev)->get_device_type(dev) != TYPE_ROM) {
 			/* MAINTENANCE_IN from SCC-2 */
 			/*
@@ -3395,7 +3395,7 @@ static int transport_generic_cmd_sequencer(
 		size = READ_POSITION_LEN;
 		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
 		break;
-	case 0xa4:
+	case MAINTENANCE_OUT:
 		if (TRANSPORT(dev)->get_device_type(dev) != TYPE_ROM) {
 			/* MAINTENANCE_OUT from SCC-2
 			 *
-- 
1.7.6

