From: James Smart <james.smart@emulex.com>
Subject: [PATCH] lpfc: remove self-assignments
Date: Thu, 20 Feb 2014 14:22:16 -0500
Message-ID: <1392924136.7370.23.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:29791 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbaBTTWS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 14:22:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

As spotted by coverty/Dave Jones, removing unnecessary self assignments.

-- james s




Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hbadisc.c |    4 ----
 1 file changed, 4 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2014-02-19 15:16:18.664005738 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2014-02-20 14:17:21.208419233 -0500
@@ -6189,10 +6189,6 @@ lpfc_read_fcf_conn_tbl(struct lpfc_hba *
 
 		memcpy(&conn_entry->conn_rec, &conn_rec[i],
 			sizeof(struct lpfc_fcf_conn_rec));
-		conn_entry->conn_rec.vlan_tag =
-			conn_entry->conn_rec.vlan_tag;
-		conn_entry->conn_rec.flags =
-			conn_entry->conn_rec.flags;
 		list_add_tail(&conn_entry->list,
 			&phba->fcf_conn_rec_list);
 	}


