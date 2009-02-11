From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/2] sg: remove unnecessary function declarations
Date: Thu, 12 Feb 2009 02:42:56 +0900
Message-ID: <1234374177-6192-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:51139 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbZBKRnl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2009 12:43:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dgilbert@interlog.com, fujita.tomonori@lab.ntt.co.jp

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 912a9eb..d17d89b 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -101,7 +101,6 @@ static int scatter_elem_sz_prev = SG_SCATTER_SZ;
 #define SG_SECTOR_MSK (SG_SECTOR_SZ - 1)
 
 static int sg_add(struct device *, struct class_interface *);
-static void sg_device_destroy(struct kref *kref);
 static void sg_remove(struct device *, struct class_interface *);
 
 static DEFINE_IDR(sg_index_idr);
@@ -178,14 +177,11 @@ typedef struct sg_device { /* holds the state of each scsi generic device */
 	struct kref d_ref;
 } Sg_device;
 
-static int sg_fasync(int fd, struct file *filp, int mode);
 /* tasklet or soft irq callback */
 static void sg_rq_end_io(struct request *rq, int uptodate);
 static int sg_start_req(Sg_request *srp, unsigned char *cmd);
 static void sg_finish_rem_req(Sg_request * srp);
 static int sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size);
-static int sg_build_sgat(Sg_scatter_hold * schp, const Sg_fd * sfp,
-			 int tablesize);
 static ssize_t sg_new_read(Sg_fd * sfp, char __user *buf, size_t count,
 			   Sg_request * srp);
 static ssize_t sg_new_write(Sg_fd *sfp, struct file *file,
@@ -204,12 +200,8 @@ static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
 static Sg_request *sg_add_request(Sg_fd * sfp);
 static int sg_remove_request(Sg_fd * sfp, Sg_request * srp);
 static int sg_res_in_use(Sg_fd * sfp);
-static Sg_device *sg_lookup_dev(int dev);
 static Sg_device *sg_get_dev(int dev);
 static void sg_put_dev(Sg_device *sdp);
-#ifdef CONFIG_SCSI_PROC_FS
-static int sg_last_dev(void);
-#endif
 
 #define SZ_SG_HEADER sizeof(struct sg_header)
 #define SZ_SG_IO_HDR sizeof(sg_io_hdr_t)
-- 
1.6.0.6

