From: Davidlohr Bueso <dave@gnu.org>
Subject: [PATCH 16/20] scsi/nsp32_debug: No longer use Scsi_Cmd typedef
Date: Sun, 08 Nov 2009 17:17:26 -0300
Message-ID: <1257711446.4759.122.camel@dbueso-pc>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [190.108.161.231] ([190.108.161.231]:40534 "EHLO
	localhost.localdomain" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755327AbZKHUZ7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 8 Nov 2009 15:25:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, gotom@debian.or.jp

Change Scsi_Cmnd for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>

---
 drivers/scsi/nsp32_debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/nsp32_debug.c b/drivers/scsi/nsp32_debug.c
index 2fb3fb5..c03872a 100644
--- a/drivers/scsi/nsp32_debug.c
+++ b/drivers/scsi/nsp32_debug.c
@@ -137,7 +137,7 @@ static void print_commandk (unsigned char *command)
 	printk("\n");
 }
 
-static void show_command(Scsi_Cmnd *SCpnt)
+static void show_command(struct scsi_cmnd *SCpnt)
 {
 	print_commandk(SCpnt->cmnd);
 }




