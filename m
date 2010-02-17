From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 04/11] zfcp: Remove unused payload field from zfcp_dbf_san_record
Date: Wed, 17 Feb 2010 11:18:52 +0100
Message-ID: <20100217102018.411631000@de.ibm.com>
References: <20100217101848.662299000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:60045 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab0BQKUW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2010 05:20:22 -0500
Content-Disposition: inline; filename=703-zfcp-unused-field.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Remove the unused payload field from the struct zfcp_dbf_san_record,
saving some space in the SAN trace.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_dbf.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_dbf.h linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.h
--- linux-2.6/drivers/s390/scsi/zfcp_dbf.h	2010-02-16 09:43:05.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.h	2010-02-16 09:43:29.000000000 +0100
@@ -192,10 +192,10 @@ struct zfcp_dbf_san_record {
 		struct zfcp_dbf_san_record_ct_response ct_resp;
 		struct zfcp_dbf_san_record_els els;
 	} u;
-#define ZFCP_DBF_SAN_MAX_PAYLOAD 1024
-	u8 payload[32];
 } __attribute__ ((packed));
 
+#define ZFCP_DBF_SAN_MAX_PAYLOAD 1024
+
 struct zfcp_dbf_scsi_record {
 	u8 tag[ZFCP_DBF_TAG_SIZE];
 	u8 tag2[ZFCP_DBF_TAG_SIZE];

