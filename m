From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/message/fusion/mptfc.c: make 2 functions static
Date: Thu, 19 Jan 2006 02:02:33 +0100
Message-ID: <20060119010233.GT19398@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:48649 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1161029AbWASBCe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jan 2006 20:02:34 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: support@lsil.com
Cc: mpt_linux_developer@lsil.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch makes two needlessly global functions static.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/message/fusion/mptfc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.16-rc1-mm1-full/drivers/message/fusion/mptfc.c.old	2006-01-18 23:16:09.000000000 +0100
+++ linux-2.6.16-rc1-mm1-full/drivers/message/fusion/mptfc.c	2006-01-18 23:16:34.000000000 +0100
@@ -93,7 +93,7 @@
 static int	mptfcTaskCtx = -1;
 static int	mptfcInternalCtx = -1; /* Used only for internal commands */
 
-int mptfc_slave_alloc(struct scsi_device *device);
+static int mptfc_slave_alloc(struct scsi_device *device);
 static int mptfc_qcmd(struct scsi_cmnd *SCpnt,
     void (*done)(struct scsi_cmnd *));
 
@@ -153,7 +153,7 @@
 
 static struct scsi_transport_template *mptfc_transport_template = NULL;
 
-struct fc_function_template mptfc_transport_functions = {
+static struct fc_function_template mptfc_transport_functions = {
 	.dd_fcrport_size = 8,
 	.show_host_node_name = 1,
 	.show_host_port_name = 1,
@@ -432,7 +432,7 @@
  *	Return non-zero if allocation fails.
  *	Init memory once per LUN.
  */
-int
+static int
 mptfc_slave_alloc(struct scsi_device *sdev)
 {
 	MPT_SCSI_HOST		*hd;

