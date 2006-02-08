From: Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH 21/29] sg gfp_t annotations
Date: Wed, 08 Feb 2006 03:19:37 +0000
Message-ID: <E1F6frl-0006De-4p@ZenIV.linux.org.uk>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030480AbWBHDWs@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Date: 1138793500 -0500

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

---

 drivers/scsi/sg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

2d20eaf9426598ef156b941bcfa44e867452b770
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 7d07000..2a54753 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1679,7 +1679,7 @@ static int
 sg_build_sgat(Sg_scatter_hold * schp, const Sg_fd * sfp, int tablesize)
 {
 	int sg_bufflen = tablesize * sizeof(struct scatterlist);
-	unsigned int gfp_flags = GFP_ATOMIC | __GFP_NOWARN;
+	gfp_t gfp_flags = GFP_ATOMIC | __GFP_NOWARN;
 
 	/*
 	 * TODO: test without low_dma, we should not need it since
-- 
0.99.9.GIT
