Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C26C433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E3B1216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404959AbfHIDCn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:02:43 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39964 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404954AbfHIDCm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:02:42 -0400
Received: by mail-pl1-f194.google.com with SMTP id a93so44308300pla.7
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:02:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zfHDxCsZI2XplpzG+fsGnsjIT3gTvuQxMvhhOcZ0dTc=;
        b=CNqTKY/SkOs0xwFW2j/2Z0VVt7IUnMHCIZRw2CKOQaBciluc9kgtVajlabXpKmK/yd
         8YK8h5KJ/NrW/M9W0BrDoxGWi5KmemI+g/2yyzH7xTBylIvaRt7SG06FxMFI812zYPYB
         59W+xsHPzK6/jw/IbPDuKCf+6PdII7+A0QyhAhycPrFpM/Al6zt/5IlKLpsMZpqKI4Xz
         LcUgwPLNrHeLexSeimZEUNvFeDffvCy+W7htxEfnkIvOYXIr5kGY+TxDjDjkpq2sq3ry
         9RkOut37206ejsMUwVfOFgfrqnD6qeZ5S7HrYpBjtP8EQDWx97uQ3U4mqWuD9cct/5e7
         1/Sg==
X-Gm-Message-State: APjAAAU0PSUHGVaH95Ixk8BKX6+kJXPXhL8oDjGDBBUBoFO99r3yC2pa
        iPyAtAJ61MkLOMHjJAMW3uk=
X-Google-Smtp-Source: APXvYqznqTkTaOgWEkGEjTfMhkFePnH6ASe3+HpgFYfKzNEgCzyjP/CzEwxPlti2sTTDE7h8uhrsDw==
X-Received: by 2002:a17:902:a60d:: with SMTP id u13mr17107387plq.144.1565319761897;
        Thu, 08 Aug 2019 20:02:41 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.02.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:02:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 04/58] qla2xxx: Use tabs instead of spaces for indentation
Date:   Thu,  8 Aug 2019 20:01:25 -0700
Message-Id: <20190809030219.11296-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch only modifies whitespace.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_gs.c | 78 +++++++++++++++++------------------
 1 file changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 749109c8f20b..7dc9eeb0c401 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3467,54 +3467,54 @@ int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_id_t *id)
 
 void qla24xx_handle_gffid_event(scsi_qla_host_t *vha, struct event_arg *ea)
 {
-       fc_port_t *fcport = ea->fcport;
+	fc_port_t *fcport = ea->fcport;
 
-       qla24xx_post_gnl_work(vha, fcport);
+	qla24xx_post_gnl_work(vha, fcport);
 }
 
 void qla24xx_async_gffid_sp_done(void *s, int res)
 {
-       struct srb *sp = s;
-       struct scsi_qla_host *vha = sp->vha;
-       fc_port_t *fcport = sp->fcport;
-       struct ct_sns_rsp *ct_rsp;
-       struct event_arg ea;
-
-       ql_dbg(ql_dbg_disc, vha, 0x2133,
-	   "Async done-%s res %x ID %x. %8phC\n",
-	   sp->name, res, fcport->d_id.b24, fcport->port_name);
-
-       fcport->flags &= ~FCF_ASYNC_SENT;
-       ct_rsp = &fcport->ct_desc.ct_sns->p.rsp;
-       /*
-	* FC-GS-7, 5.2.3.12 FC-4 Features - format
-	* The format of the FC-4 Features object, as defined by the FC-4,
-	* Shall be an array of 4-bit values, one for each type code value
-	*/
-       if (!res) {
-	       if (ct_rsp->rsp.gff_id.fc4_features[GFF_FCP_SCSI_OFFSET] & 0xf) {
-		       /* w1 b00:03 */
-		       fcport->fc4_type =
-			   ct_rsp->rsp.gff_id.fc4_features[GFF_FCP_SCSI_OFFSET];
-		       fcport->fc4_type &= 0xf;
-	       }
+	struct srb *sp = s;
+	struct scsi_qla_host *vha = sp->vha;
+	fc_port_t *fcport = sp->fcport;
+	struct ct_sns_rsp *ct_rsp;
+	struct event_arg ea;
+
+	ql_dbg(ql_dbg_disc, vha, 0x2133,
+	       "Async done-%s res %x ID %x. %8phC\n",
+	       sp->name, res, fcport->d_id.b24, fcport->port_name);
 
-	       if (ct_rsp->rsp.gff_id.fc4_features[GFF_NVME_OFFSET] & 0xf) {
-		       /* w5 [00:03]/28h */
-		       fcport->fc4f_nvme =
-			   ct_rsp->rsp.gff_id.fc4_features[GFF_NVME_OFFSET];
-		       fcport->fc4f_nvme &= 0xf;
+	fcport->flags &= ~FCF_ASYNC_SENT;
+	ct_rsp = &fcport->ct_desc.ct_sns->p.rsp;
+	/*
+	 * FC-GS-7, 5.2.3.12 FC-4 Features - format
+	 * The format of the FC-4 Features object, as defined by the FC-4,
+	 * Shall be an array of 4-bit values, one for each type code value
+	 */
+	if (!res) {
+		if (ct_rsp->rsp.gff_id.fc4_features[GFF_FCP_SCSI_OFFSET] & 0xf) {
+			/* w1 b00:03 */
+			fcport->fc4_type =
+			    ct_rsp->rsp.gff_id.fc4_features[GFF_FCP_SCSI_OFFSET];
+			fcport->fc4_type &= 0xf;
 	       }
-       }
 
-       memset(&ea, 0, sizeof(ea));
-       ea.sp = sp;
-       ea.fcport = sp->fcport;
-       ea.rc = res;
-       ea.event = FCME_GFFID_DONE;
+		if (ct_rsp->rsp.gff_id.fc4_features[GFF_NVME_OFFSET] & 0xf) {
+			/* w5 [00:03]/28h */
+			fcport->fc4f_nvme =
+			    ct_rsp->rsp.gff_id.fc4_features[GFF_NVME_OFFSET];
+			fcport->fc4f_nvme &= 0xf;
+		}
+	}
 
-       qla2x00_fcport_event_handler(vha, &ea);
-       sp->free(sp);
+	memset(&ea, 0, sizeof(ea));
+	ea.sp = sp;
+	ea.fcport = sp->fcport;
+	ea.rc = res;
+	ea.event = FCME_GFFID_DONE;
+
+	qla2x00_fcport_event_handler(vha, &ea);
+	sp->free(sp);
 }
 
 /* Get FC4 Feature with Nport ID. */
-- 
2.22.0

