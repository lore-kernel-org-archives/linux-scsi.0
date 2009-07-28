From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] fc_transport:  Correct max fc_host attribute count
Date: Tue, 28 Jul 2009 12:30:01 -0400
Message-ID: <1248798601.22058.2.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:58068 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbZG1QaC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jul 2009 12:30:02 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n6SGU20T009185
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2009 09:30:02 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Correct max possible fc_host attribute count

 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 scsi_transport_fc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2009-06-29 10:31:11.000000000 -0400
+++ b/drivers/scsi/scsi_transport_fc.c	2009-07-28 12:26:19.000000000 -0400
@@ -291,7 +291,7 @@ static void fc_scsi_scan_rport(struct wo
 #define FC_STARGET_NUM_ATTRS 	3
 #define FC_RPORT_NUM_ATTRS	10
 #define FC_VPORT_NUM_ATTRS	9
-#define FC_HOST_NUM_ATTRS	21
+#define FC_HOST_NUM_ATTRS	22
 
 struct fc_internal {
 	struct scsi_transport_template t;


