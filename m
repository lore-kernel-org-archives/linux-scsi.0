From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 10/11] fc: Add GSPN_ID request to header file
Date: Tue, 22 Feb 2011 19:54:47 +0100
Message-ID: <20110222185537.343173184@linux.vnet.ibm.com>
References: <20110222185437.385767855@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:58487 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab1BVSzm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2011 13:55:42 -0500
Content-Disposition: inline; filename=710-fc-gspn-id.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Add request code and corresponding structs for "Get Symbolic Port
Name" (GSPN_ID) request.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---


 include/scsi/fc/fc_ns.h |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)
--- a/include/scsi/fc/fc_ns.h
+++ b/include/scsi/fc/fc_ns.h
@@ -41,6 +41,7 @@ enum fc_ns_req {
 	FC_NS_GI_A =	0x0101,		/* get identifiers - scope */
 	FC_NS_GPN_ID =	0x0112,		/* get port name by ID */
 	FC_NS_GNN_ID =	0x0113,		/* get node name by ID */
+	FC_NS_GSPN_ID = 0x0118,		/* get symbolic port name */
 	FC_NS_GID_PN =	0x0121,		/* get ID for port name */
 	FC_NS_GID_NN =	0x0131,		/* get IDs for node name */
 	FC_NS_GID_FT =	0x0171,		/* get IDs by FC4 type */
@@ -144,7 +145,7 @@ struct fc_ns_gid_pn {
 };
 
 /*
- * GID_PN response
+ * GID_PN response or GSPN_ID request
  */
 struct fc_gid_pn_resp {
 	__u8      fp_resvd;
@@ -152,6 +153,14 @@ struct fc_gid_pn_resp {
 };
 
 /*
+ * GSPN_ID response
+ */
+struct fc_gspn_resp {
+	__u8	fp_name_len;
+	char	fp_name[];
+};
+
+/*
  * RFT_ID request - register FC-4 types for ID.
  */
 struct fc_ns_rft_id {

