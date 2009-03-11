From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/3] sg: kill unused SZ_SG_IOVEC define
Date: Wed, 11 Mar 2009 10:02:45 +0900
Message-ID: <1236733367-30967-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:40759 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbZCKBEN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Mar 2009 21:04:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 17d1bd5..e84536b 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -204,7 +204,6 @@ static void sg_put_dev(Sg_device *sdp);
 
 #define SZ_SG_HEADER sizeof(struct sg_header)
 #define SZ_SG_IO_HDR sizeof(sg_io_hdr_t)
-#define SZ_SG_IOVEC sizeof(sg_iovec_t)
 #define SZ_SG_REQ_INFO sizeof(sg_req_info_t)
 
 static int sg_allow_access(struct file *filp, unsigned char *cmd)
-- 
1.6.0.6

