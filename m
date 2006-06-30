From: akpm@osdl.org
Subject: [patch 22/22] drivers/message/fusion/mptsas.c: make 2 functions static
Date: Fri, 30 Jun 2006 02:33:19 -0700
Message-ID: <200606300933.k5U9XJJX001748@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:51094 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932225AbWF3JsE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jun 2006 05:48:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, bunk@stusta.de, Eric.Moore@lsil.com

From: Adrian Bunk <bunk@stusta.de>

Make two needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/message/fusion/mptsas.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/message/fusion/mptsas.c~drivers-message-fusion-mptsasc-make-2-functions-static drivers/message/fusion/mptsas.c
--- a/drivers/message/fusion/mptsas.c~drivers-message-fusion-mptsasc-make-2-functions-static
+++ a/drivers/message/fusion/mptsas.c
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
_
