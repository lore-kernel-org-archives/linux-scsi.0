From: Adrian Bunk <bunk@stusta.de>
Subject: [-mm patch] drivers/scsi/constants.c: make 2 functions static
Date: Sat, 24 Mar 2007 14:06:47 +0100
Message-ID: <20070324130647.GI752@stusta.de>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751602AbXCXNG4@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070319205623.299d0378.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@SteelEye.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 19, 2007 at 08:56:23PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.21-rc3-mm1:
>...
>  git-scsi-misc.patch
>...
>  git trees
>...


This patch makes two needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/scsi/constants.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.21-rc4-mm1/drivers/scsi/constants.c.old	2007-03-23 23:26:39.000000000 +0100
+++ linux-2.6.21-rc4-mm1/drivers/scsi/constants.c	2007-03-23 23:26:55.000000000 +0100
@@ -1235,7 +1235,7 @@
 }
 EXPORT_SYMBOL(scsi_print_sense_hdr);
 
-void
+static void
 scsi_decode_sense_buffer(const unsigned char *sense_buffer, int sense_len,
 		       struct scsi_sense_hdr *sshdr)
 {
@@ -1258,7 +1258,7 @@
 	}
 }
 
-void
+static void
 scsi_decode_sense_extras(const unsigned char *sense_buffer, int sense_len,
 			 struct scsi_sense_hdr *sshdr)
 {
