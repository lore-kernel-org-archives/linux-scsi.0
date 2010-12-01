From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 14/27] drivers/scsi/fcoe: Update WARN uses
Date: Tue, 30 Nov 2010 16:19:09 -0800
Message-ID: <20101201001909.18369.17318.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:5041 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab0LAATK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:19:10 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Perches <joe@perches.com>

From: Joe Perches <joe@perches.com>

Add missing newlines.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/libfcoe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index bc17c71..58ad3c7 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -2475,7 +2475,7 @@ static void fcoe_ctlr_vn_timeout(struct fcoe_ctlr *fip)
 	case FIP_ST_LINK_WAIT:
 		goto unlock;
 	default:
-		WARN(1, "unexpected state %d", fip->state);
+		WARN(1, "unexpected state %d\n", fip->state);
 		goto unlock;
 	}
 	mod_timer(&fip->timer, next_time);

