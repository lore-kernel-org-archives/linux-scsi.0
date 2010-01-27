From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH 2/6] libfc: Remove extra pointer check
Date: Wed, 27 Jan 2010 15:24:27 -0800
Message-ID: <20100127232427.10343.87033.stgit@localhost.localdomain>
References: <20100127232415.10343.86703.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13902 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932198Ab0A0XY2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jan 2010 18:24:28 -0500
In-Reply-To: <20100127232415.10343.86703.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, james.smart@emulex.com
Cc: giridhar.malavali@qlogic.com

The fcf pointer is checked immediately after this call making this
call redundant. Remote the first check.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 511cb6b..5dae90e 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -941,8 +941,7 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 	u32	desc_mask;
 
 	LIBFCOE_FIP_DBG(fip, "Clear Virtual Link received\n");
-	if (!fcf)
-		return;
+
 	if (!fcf || !fc_host_port_id(lport->host))
 		return;
 

