From: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] scsi:gdth.c: fix compilation warning
Date: Mon,  3 Dec 2012 10:19:09 +0000
Message-ID: <1354529949-8483-1-git-send-email-dinggnu@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, Achim Leubner <achim_leubner@adaptec.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Cong Ding <dinggnu@gmail.com>
List-Id: linux-scsi@vger.kernel.org

We do not allow old-style function definition.  Always spell foo(void) if
a function does not take any parameters.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/scsi/gdth.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 5d72274..950c095 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -204,7 +204,7 @@ static char strbuf[MAX_SERBUF+1];
 #else
 #define COM_BASE 0x3f8
 #endif
-static void ser_init()
+static void ser_init(void)
 {
     unsigned port=COM_BASE;
 
-- 
1.7.4.5
