From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 35/64] libfc: remove unused disc->delay element
Date: Tue, 25 Aug 2009 14:01:34 -0700
Message-ID: <20090825210134.1553.55068.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:44726 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932194AbZHYVBc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:01:32 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

Delete unused disc->delay element.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c |    3 ---
 include/scsi/libfc.h         |    1 -
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 736f917..8427396 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -43,8 +43,6 @@
 #define FC_DISC_RETRY_LIMIT	3	/* max retries */
 #define FC_DISC_RETRY_DELAY	500UL	/* (msecs) delay */
 
-#define	FC_DISC_DELAY		3
-
 static void fc_disc_gpn_ft_req(struct fc_disc *);
 static void fc_disc_gpn_ft_resp(struct fc_seq *, struct fc_frame *, void *);
 static int fc_disc_new_target(struct fc_disc *, struct fc_rport_priv *,
@@ -775,7 +773,6 @@ int fc_disc_init(struct fc_lport *lport)
 	INIT_LIST_HEAD(&disc->rports);
 
 	disc->lport = lport;
-	disc->delay = FC_DISC_DELAY;
 
 	return 0;
 }
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index f3f320f..093b043 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -674,7 +674,6 @@ struct libfc_function_template {
 /* information used by the discovery layer */
 struct fc_disc {
 	unsigned char		retry_count;
-	unsigned char		delay;
 	unsigned char		pending;
 	unsigned char		requested;
 	unsigned short		seq_count;

