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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C43A5C47095
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 09:04:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A53CB61285
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 09:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237818AbhFIJF6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 05:05:58 -0400
Received: from m12-16.163.com ([220.181.12.16]:57177 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234403AbhFIJF6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Jun 2021 05:05:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=AY98O
        Z6x2nUpuigB8VZeCNN9sVDE93mhA08248Jnwhc=; b=mL9nnl//2hrbaa7r6Ge6P
        yRv/coc6JGt5kwlvB0WdyXFRU3yxOz5ZfZevpQMVU6lVXEEESKhw068YjbvZKJtJ
        W2h4CTILC3Vz9pgxvHbFpCtto7Gu7AKFfZo4n1TNsf0lLVaFmsgz7hbJmlDB1EdD
        07TEsIKU+QQeuFaTSLfQRg=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp12 (Coremail) with SMTP id EMCowAB3zGHJg8Bg_fChwA--.14250S2;
        Wed, 09 Jun 2021 17:03:06 +0800 (CST)
From:   lijian_8010a29@163.com
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: [PATCH] scsi: lpfc: lpfc_mbox: Removed unnecessary 'return'
Date:   Wed,  9 Jun 2021 17:02:07 +0800
Message-Id: <20210609090207.520218-1-lijian_8010a29@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EMCowAB3zGHJg8Bg_fChwA--.14250S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAFW7GFyfJr1DKr1UGF1fXrb_yoWrZr47pa
        nxAasrur4qkFy7KrW3Jrn8AF4ay3y8tr10yanFg34fuF4vyrWakFyxJFyI9ayFqF10krya
        yr4Igw15W3W7XF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jpNtsUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5olmxttqbyiikqdsmqqrwthudrp/xtbBLBisUF++MI0whgAAsi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: lijian <lijian@yulong.com>

Removed unnecessary 'return'.

Signed-off-by: lijian <lijian@yulong.com>
---
 drivers/scsi/lpfc/lpfc_mbox.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index a232e8dfbda8..b6174a02fff3 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -153,7 +153,6 @@ lpfc_dump_mem(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb, uint16_t offset,
 	mb->un.varDmp.resp_offset = 0;
 	pmb->ctx_buf = ctx;
 	mb->mbxOwner = OWN_HOST;
-	return;
 }
 
 /**
@@ -187,7 +186,6 @@ lpfc_dump_wakeup_param(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	mb->un.varDmp.co = 0;
 	mb->un.varDmp.resp_offset = 0;
 	pmb->ctx_buf = ctx;
-	return;
 }
 
 /**
@@ -210,7 +208,6 @@ lpfc_read_nv(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 	mb->mbxCommand = MBX_READ_NV;
 	mb->mbxOwner = OWN_HOST;
-	return;
 }
 
 /**
@@ -237,7 +234,6 @@ lpfc_config_async(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb,
 	mb->mbxCommand = MBX_ASYNCEVT_ENABLE;
 	mb->un.varCfgAsyncEvent.ring = ring;
 	mb->mbxOwner = OWN_HOST;
-	return;
 }
 
 /**
@@ -262,7 +258,6 @@ lpfc_heart_beat(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
 	mb->mbxCommand = MBX_HEARTBEAT;
 	mb->mbxOwner = OWN_HOST;
-	return;
 }
 
 /**
@@ -335,7 +330,6 @@ lpfc_clear_la(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 	mb->un.varClearLA.eventTag = phba->fc_eventTag;
 	mb->mbxCommand = MBX_CLEAR_LA;
 	mb->mbxOwner = OWN_HOST;
-	return;
 }
 
 /**
@@ -388,7 +382,6 @@ lpfc_config_link(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 
 	mb->mbxCommand = MBX_CONFIG_LINK;
 	mb->mbxOwner = OWN_HOST;
-	return;
 }
 
 /**
@@ -575,7 +568,6 @@ lpfc_init_link(struct lpfc_hba * phba,
 	mb->mbxCommand = (volatile uint8_t)MBX_INIT_LINK;
 	mb->mbxOwner = OWN_HOST;
 	mb->un.varInitLnk.fabric_AL_PA = phba->fc_pref_ALPA;
-	return;
 }
 
 /**
@@ -669,7 +661,6 @@ lpfc_unreg_did(struct lpfc_hba * phba, uint16_t vpi, uint32_t did,
 
 	mb->mbxCommand = MBX_UNREG_D_ID;
 	mb->mbxOwner = OWN_HOST;
-	return;
 }
 
 /**
@@ -695,7 +686,6 @@ lpfc_read_config(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 
 	mb->mbxCommand = MBX_READ_CONFIG;
 	mb->mbxOwner = OWN_HOST;
-	return;
 }
 
 /**
@@ -720,7 +710,6 @@ lpfc_read_lnk_stat(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 
 	mb->mbxCommand = MBX_READ_LNK_STAT;
 	mb->mbxOwner = OWN_HOST;
-	return;
 }
 
 /**
@@ -827,8 +816,6 @@ lpfc_unreg_login(struct lpfc_hba *phba, uint16_t vpi, uint32_t rpi,
 
 	mb->mbxCommand = MBX_UNREG_LOGIN;
 	mb->mbxOwner = OWN_HOST;
-
-	return;
 }
 
 /**
@@ -1033,7 +1020,6 @@ lpfc_read_rev(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 	mb->un.varRdRev.v3req = 1; /* Request SLI3 info */
 	mb->mbxCommand = MBX_READ_REV;
 	mb->mbxOwner = OWN_HOST;
-	return;
 }
 
 void
@@ -1053,7 +1039,6 @@ lpfc_sli4_swap_str(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	default:
 		break;
 	}
-	return;
 }
 
 /**
@@ -1190,8 +1175,6 @@ lpfc_config_hbq(struct lpfc_hba *phba, uint32_t id,
 		hbqmb->hbqMasks[i].rctlmatch = hbq_desc->hbqMasks[i].rctlmatch;
 		hbqmb->hbqMasks[i].rctlmask  = hbq_desc->hbqMasks[i].rctlmask;
 	}
-
-	return;
 }
 
 /**
@@ -1248,8 +1231,6 @@ lpfc_config_ring(struct lpfc_hba * phba, int ring, LPFC_MBOXQ_t * pmb)
 		mb->un.varCfgRing.rrRegs[i].tval = pring->prt[i].type;
 		mb->un.varCfgRing.rrRegs[i].tmask = 0xff;
 	}
-
-	return;
 }
 
 /**
@@ -1462,7 +1443,6 @@ lpfc_kill_board(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 	memset(pmb, 0, sizeof(LPFC_MBOXQ_t));
 	mb->mbxCommand = MBX_KILL_BOARD;
 	mb->mbxOwner = OWN_HOST;
-	return;
 }
 
 /**
@@ -1485,8 +1465,6 @@ lpfc_mbox_put(struct lpfc_hba * phba, LPFC_MBOXQ_t * mbq)
 	list_add_tail(&mbq->list, &psli->mboxq);
 
 	psli->mboxq_cnt++;
-
-	return;
 }
 
 /**
@@ -1551,7 +1529,6 @@ lpfc_mbox_cmpl_put(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbq)
 	spin_lock_irqsave(&phba->hbalock, iflag);
 	__lpfc_mbox_cmpl_put(phba, mbq);
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
-	return;
 }
 
 /**
@@ -2100,7 +2077,6 @@ lpfc_request_features(struct lpfc_hba *phba, struct lpfcMboxq *mboxq)
 		bf_set(lpfc_mbx_rq_ftr_rq_iaab, &mboxq->u.mqe.un.req_ftrs, 0);
 		bf_set(lpfc_mbx_rq_ftr_rq_iaar, &mboxq->u.mqe.un.req_ftrs, 0);
 	}
-	return;
 }
 
 /**
-- 
2.25.1


