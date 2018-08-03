From: Colin King <colin.king@canonical.com>
Subject: [PATCH] st: remove redundant pointer STbuffer
Date: Fri,  3 Aug 2018 11:47:52 +0100
Message-ID: <20180803104752.17081-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Pointer STbuffer is being assigned but is never used hence it is
redundant and can be removed.

Cleans up clang warning:
warning: variable 'STbuffer' set but not used [-Wunused-but-set-variable]

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/st.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 50c66ccc4b41..307df2fa39a3 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -828,11 +828,8 @@ static int st_flush_write_buffer(struct scsi_tape * STp)
 static int flush_buffer(struct scsi_tape *STp, int seek_next)
 {
 	int backspace, result;
-	struct st_buffer *STbuffer;
 	struct st_partstat *STps;
 
-	STbuffer = STp->buffer;
-
 	/*
 	 * If there was a bus reset, block further access
 	 * to this device.
-- 
2.17.1
