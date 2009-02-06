From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 05/17] libfc: rename rp to rdata in fc_disc_new_target()
Date: Fri, 06 Feb 2009 10:56:16 -0800
Message-ID: <20090206185616.26188.48990.stgit@fritz>
References: <20090206185548.26188.51580.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:33785 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbZBFS4Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2009 13:56:16 -0500
In-Reply-To: <20090206185548.26188.51580.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

Just rename the variable as per our naming convention.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 9f4e408..cfbce89 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -396,7 +396,7 @@ static int fc_disc_new_target(struct fc_disc *disc,
 			      struct fc_rport_identifiers *ids)
 {
 	struct fc_lport *lport = disc->lport;
-	struct fc_rport_libfc_priv *rp;
+	struct fc_rport_libfc_priv *rdata;
 	int error = 0;
 
 	if (rport && ids->port_name) {
@@ -436,9 +436,9 @@ static int fc_disc_new_target(struct fc_disc *disc,
 				error = -ENOMEM;
 		}
 		if (rport) {
-			rp = rport->dd_data;
-			rp->ops = &fc_disc_rport_ops;
-			rp->rp_state = RPORT_ST_INIT;
+			rdata = rport->dd_data;
+			rdata->ops = &fc_disc_rport_ops;
+			rdata->rp_state = RPORT_ST_INIT;
 			lport->tt.rport_login(rport);
 		}
 	}

