From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH] hpsa: return 0 from driver probe function on success, not 1
Date: Tue, 29 Oct 2013 13:39:56 -0500
Message-ID: <20131029183956.5471.91383.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:5279 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab3J2Sj6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2013 14:39:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

A return value of 1 is interpreted as an error

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 891c86b..3c97974 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4926,7 +4926,7 @@ reinit_after_soft_reset:
 	hpsa_hba_inquiry(h);
 	hpsa_register_scsi(h);	/* hook ourselves into SCSI subsystem */
 	start_controller_lockup_detector(h);
-	return 1;
+	return 0;
 
 clean4:
 	hpsa_free_sg_chain_blocks(h);

