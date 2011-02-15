From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] target: use MAINTENANCE_IN and MAINTENANCE_OUT definitions
 in scsi.h
Date: Tue, 15 Feb 2011 14:53:30 +0900
Message-ID: <20110215145315U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46209 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab1BOFxh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Feb 2011 00:53:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org

What branch am I supposed to send a patch for the next release (that
is, will go to scsi-misc)?

lio-core-2.6.git/master, right?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] target: use MAINTENANCE_IN and MAINTENANCE_OUT definitions in scsi.h

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/target/target_core_transport.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 123bd94..4184b0d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3314,7 +3314,7 @@ static int transport_generic_cmd_sequencer(
 			goto out_unsupported_cdb;
 		}
 		break;
-	case 0xa3:
+	case MAINTENANCE_IN:
 		if (TRANSPORT(dev)->get_device_type(dev) != TYPE_ROM) {
 			/* MAINTENANCE_IN from SCC-2 */
 			/*
@@ -3384,7 +3384,7 @@ static int transport_generic_cmd_sequencer(
 		size = READ_POSITION_LEN;
 		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
 		break;
-	case 0xa4:
+	case MAINTENANCE_OUT:
 		if (TRANSPORT(dev)->get_device_type(dev) != TYPE_ROM) {
 			/* MAINTENANCE_OUT from SCC-2
 			 *
-- 
1.7.2.3

