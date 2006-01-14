From: andrew.vasquez@qlogic.com
Subject: [PATCH 02/15] qla2xxx: Correct FC4 feature assignment during RFF_ID.
Date: Fri, 13 Jan 2006 17:04:54 -0800
Message-ID: <11372006892117-git-send-email-andrew.vasquez@qlogic.com>
References: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:57634 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1945921AbWANBEz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 20:04:55 -0500
In-Reply-To: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_gs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

34cf8c49e659aadcad2387be61afc69909844e1b
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index cd6f7c3..0e8ada0 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -538,6 +538,7 @@ qla2x00_rff_id(scsi_qla_host_t *ha)
 	ct_req->req.rff_id.port_id[1] = ha->d_id.b.area;
 	ct_req->req.rff_id.port_id[2] = ha->d_id.b.al_pa;
 
+	ct_req->req.rff_id.fc4_feature = BIT_1;
 	ct_req->req.rff_id.fc4_type = 0x08;		/* SCSI - FCP */
 
 	/* Execute MS IOCB */
-- 
1.1.1-g4c34


