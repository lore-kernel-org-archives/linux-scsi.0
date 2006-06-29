From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH] mptsas: make two functions static
Date: Thu, 29 Jun 2006 17:36:26 -0600
Message-ID: <20060629233625.GA22380@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:56203 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S933116AbWF2XtE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jun 2006 19:49:04 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: akpm@osdl.com

Make two needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.com>
Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

diff -uarpN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2006-06-29 15:59:46.000000000 -0600
+++ a/drivers/message/fusion/mptsas.c	2006-06-29 17:38:43.000000000 -0600
@@ -337,7 +337,7 @@ mptsas_is_end_device(struct mptsas_devin
 }
 
 /* no mutex */
-void
+static void
 mptsas_port_delete(struct mptsas_portinfo_details * port_details)
 {
 	struct mptsas_portinfo *port_info;
@@ -438,7 +438,7 @@ starget)
  * Updates for new and existing narrow/wide port configuration
  * in the sas_topology
  */
-void
+static void
 mptsas_setup_wide_ports(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 {
 	struct mptsas_portinfo_details * port_details;
