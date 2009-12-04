From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 10/15] be2iscsi: Add TEXT RESP processing
Date: Fri, 4 Dec 2009 08:54:37 +0530
Message-ID: <20091204032428.GA6228@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:6900 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754704AbZLDDYW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2009 22:24:22 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

  This patch adds TEXT RESPONSE processing

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 30ece62..6170548 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -560,6 +560,7 @@ beiscsi_process_async_pdu(struct beiscsi_conn *beiscsi_conn,
 		SE_DEBUG(DBG_LVL_1, "In ISCSI_OP_REJECT\n");
 		break;
 	case ISCSI_OP_LOGIN_RSP:
+	case ISCSI_OP_TEXT_RSP:
 		task = conn->login_task;
 		io_task = task->dd_data;
 		login_hdr = (struct iscsi_hdr *)ppdu;
-- 
1.6.4

