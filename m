From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/8] scsi/mac: macscsi_detect() should be __init
Date: Mon, 13 Jun 2011 20:39:16 +0200
Message-ID: <1307990362-22768-3-git-send-email-geert@linux-m68k.org>
References: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Finn Thain <fthain@telegraphics.com.au>
List-Id: linux-scsi@vger.kernel.org

WARNING: vmlinux.o(.text+0x1ecd3e): Section mismatch in reference from the function macscsi_detect() to the function .devinit.text:NCR5380_init()
WARNING: vmlinux.o(.text+0x1ecddc): Section mismatch in reference from the function macscsi_detect() to the function .init.text:NCR5380_print_options()
WARNING: vmlinux.o(.text+0x1ece60): Section mismatch in reference from the function macscsi_detect() to the function .init.text:NCR5380_print_options()

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/mac_scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index bf2a1c5..67eb758 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -233,7 +233,7 @@ static struct Scsi_Host *default_instance;
  *
  */
  
-int macscsi_detect(struct scsi_host_template * tpnt)
+int __init macscsi_detect(struct scsi_host_template * tpnt)
 {
     static int called = 0;
     int flags = 0;
-- 
1.7.0.4
