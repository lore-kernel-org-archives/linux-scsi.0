From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/scsi/megaraid/megaraid_sas.c: make 2 functions static
Date: Mon, 20 Nov 2006 03:23:49 +0100
Message-ID: <20061120022349.GG31879@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933870AbWKTC2d@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Sumant Patro <Sumant.Patro@lsil.com>
Cc: Neela.Kolli@engenio.com, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch makes two needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/scsi/megaraid/megaraid_sas.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.19-rc5-mm2/drivers/scsi/megaraid/megaraid_sas.c.old	2006-11-20 00:55:39.000000000 +0100
+++ linux-2.6.19-rc5-mm2/drivers/scsi/megaraid/megaraid_sas.c	2006-11-20 00:55:57.000000000 +0100
@@ -517,7 +517,7 @@
  * Returns the number of frames required for numnber of sge's (sge_count)
  */
 
-u32 megasas_get_frame_count(u8 sge_count)
+static u32 megasas_get_frame_count(u8 sge_count)
 {
 	int num_cnt;
 	int sge_bytes;
@@ -1733,7 +1733,7 @@
  *
  * Tasklet to complete cmds
  */
-void megasas_complete_cmd_dpc(unsigned long instance_addr)
+static void megasas_complete_cmd_dpc(unsigned long instance_addr)
 {
 	u32 producer;
 	u32 consumer;
