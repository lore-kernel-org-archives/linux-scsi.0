Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E36C47095
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 08:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C200661364
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 08:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237229AbhFIIP4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 04:15:56 -0400
Received: from m12-14.163.com ([220.181.12.14]:37198 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236067AbhFIIP4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Jun 2021 04:15:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=6O6gx
        oSiOfpBiZK7OrcRi7iWNwmlbtgWWUXFVrmBj0o=; b=hRZpIUAyURnrhMNE27Y6O
        +g8IAaL7gjgUtIGT+1V0ocAnBypocOS/00v5ech8Mj9DslsssLgcR0D8uey7Bl35
        oOpYiNhuyTfAZnSA5YV7Djf24ckApumMy16gZ/O1PSofeZX8RI48GkTIESunM17i
        ZJh1Yjkk5aXYJiODXQaKv0=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp10 (Coremail) with SMTP id DsCowACXn0v+d8Bgu0sgNw--.20422S2;
        Wed, 09 Jun 2021 16:12:47 +0800 (CST)
From:   lijian_8010a29@163.com
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: [PATCH] scsi: lpfc: lpfc_ct: Removed unnecessary 'return'
Date:   Wed,  9 Jun 2021 16:11:49 +0800
Message-Id: <20210609081149.504882-1-lijian_8010a29@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsCowACXn0v+d8Bgu0sgNw--.20422S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAFW5AFyDtw43XF45tFW7XFb_yoW5AF15p3
        Z7WFW8CrZ2kFsrKFyrJF4UCFnIyw48JrWqkayvg3yYkFsayFW7tFy5JF18ZrW5WFy0vr1S
        yrs7KrWUCw4kXrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jZMa5UUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5olmxttqbyiikqdsmqqrwthudrp/1tbiSh+sUFPAOoZGtwAAs3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: lijian <lijian@yulong.com>

Removed unnecessary 'return'.

Signed-off-by: lijian <lijian@yulong.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 450f3a3fa911..d6332f6dcc98 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -483,7 +483,6 @@ lpfc_free_ct_rsp(struct lpfc_hba *phba, struct lpfc_dmabuf *mlist)
 	}
 	lpfc_mbuf_free(phba, mlist->virt, mlist->phys);
 	kfree(mlist);
-	return;
 }
 
 static struct lpfc_dmabuf *
@@ -1136,7 +1135,6 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 out:
 	lpfc_ct_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(ndlp);
-	return;
 }
 
 static void
@@ -1482,7 +1480,6 @@ lpfc_cmpl_ct_cmd_gff_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	free_ndlp = cmdiocb->context_un.ndlp;
 	lpfc_ct_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(free_ndlp);
-	return;
 }
 
 static void
@@ -1645,7 +1642,6 @@ lpfc_cmpl_ct(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 out:
 	lpfc_ct_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(ndlp);
-	return;
 }
 
 static void
@@ -1666,7 +1662,6 @@ lpfc_cmpl_ct_cmd_rft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			vport->ct_flags |= FC_CT_RFT_ID;
 	}
 	lpfc_cmpl_ct(phba, cmdiocb, rspiocb);
-	return;
 }
 
 static void
@@ -1687,7 +1682,6 @@ lpfc_cmpl_ct_cmd_rnn_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			vport->ct_flags |= FC_CT_RNN_ID;
 	}
 	lpfc_cmpl_ct(phba, cmdiocb, rspiocb);
-	return;
 }
 
 static void
@@ -1708,7 +1702,6 @@ lpfc_cmpl_ct_cmd_rspn_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			vport->ct_flags |= FC_CT_RSPN_ID;
 	}
 	lpfc_cmpl_ct(phba, cmdiocb, rspiocb);
-	return;
 }
 
 static void
@@ -1729,7 +1722,6 @@ lpfc_cmpl_ct_cmd_rsnn_nn(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			vport->ct_flags |= FC_CT_RSNN_NN;
 	}
 	lpfc_cmpl_ct(phba, cmdiocb, rspiocb);
-	return;
 }
 
 static void
@@ -1741,7 +1733,6 @@ lpfc_cmpl_ct_cmd_da_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* even if it fails we will act as though it succeeded. */
 	vport->ct_flags = 0;
 	lpfc_cmpl_ct(phba, cmdiocb, rspiocb);
-	return;
 }
 
 static void
@@ -1762,7 +1753,6 @@ lpfc_cmpl_ct_cmd_rff_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			vport->ct_flags |= FC_CT_RFF_ID;
 	}
 	lpfc_cmpl_ct(phba, cmdiocb, rspiocb);
-	return;
 }
 
 /*
@@ -2327,7 +2317,6 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		}
 		break;
 	}
-	return;
 }
 
 
@@ -3637,7 +3626,6 @@ lpfc_delayed_disc_tmo(struct timer_list *t)
 
 	if (!tmo_posted)
 		lpfc_worker_wake_up(phba);
-	return;
 }
 
 /**
@@ -3746,5 +3734,4 @@ lpfc_decode_firmware_rev(struct lpfc_hba *phba, char *fwrevision, int flag)
 
 		sprintf(fwrevision, "%d.%d%d%c%d", b1, b2, b3, c, b4);
 	}
-	return;
 }
-- 
2.25.1

