Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB4A9C48BCD
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 09:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3C7B60FEB
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 09:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238136AbhFIJnS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 05:43:18 -0400
Received: from m12-17.163.com ([220.181.12.17]:46814 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234720AbhFIJnS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Jun 2021 05:43:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=emhq7
        YqbrdFKqsiv9tuI2zOhFtJH8ztv1Gb7P5G7pvc=; b=LMr6SxP3+hj+OMAX4lO9X
        O9VStuD663p+6kIMZ1LFUOuKiCGtn++J3SJgpGGPUDnLveoAJ21V8fZTzEhL0uJe
        FWoFo3PAlNeJMX+ZQDPkivDwMoYuvUszESur7DCWqTos3dF2I5kH5W/4s/CS2ivB
        n0fEsexUPN9REYOerJ15vE=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp13 (Coremail) with SMTP id EcCowABHa3+SjMBgX3tz6Q--.24882S2;
        Wed, 09 Jun 2021 17:40:35 +0800 (CST)
From:   lijian_8010a29@163.com
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: [PATCH] scsi: lpfc: lpfc_bsg: Removed unnecessary 'return'
Date:   Wed,  9 Jun 2021 17:39:32 +0800
Message-Id: <20210609093932.580991-1-lijian_8010a29@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EcCowABHa3+SjMBgX3tz6Q--.24882S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAFW5Cw4rWw48Gr43tFykGrg_yoW5Cw4DpF
        4rCFy8urn7JF17Kry5ta9IywnIyw4fJFyjyan8Kas3uFsavFW7GFWxJr18JFWrJFyvyF98
        KrZrWay5G3W7XFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jpsj8UUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5olmxttqbyiikqdsmqqrwthudrp/1tbiShOsUFPAOodiEgAAs7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: lijian <lijian@yulong.com>

Removed unnecessary 'return'.

Signed-off-by: lijian <lijian@yulong.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 08be16e7a60a..df6ab90523e6 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -150,7 +150,6 @@ lpfc_free_bsg_buffers(struct lpfc_hba *phba, struct lpfc_dmabuf *mlist)
 		lpfc_mbuf_free(phba, mlist->virt, mlist->phys);
 		kfree(mlist);
 	}
-	return;
 }
 
 static struct lpfc_dmabuf *
@@ -377,7 +376,6 @@ lpfc_bsg_send_mgmt_cmd_cmp(struct lpfc_hba *phba,
 		bsg_job_done(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	}
-	return;
 }
 
 /**
@@ -647,7 +645,6 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 		bsg_job_done(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	}
-	return;
 }
 
 /**
@@ -1442,7 +1439,6 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *phba,
 		bsg_job_done(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	}
-	return;
 }
 
 /**
@@ -1755,7 +1751,6 @@ lpfc_bsg_diag_mode_exit(struct lpfc_hba *phba)
 		shost = lpfc_shost_from_vport(phba->pport);
 		scsi_unblock_requests(shost);
 	}
-	return;
 }
 
 /**
@@ -2816,7 +2811,6 @@ lpfc_bsg_dma_page_free(struct lpfc_hba *phba, struct lpfc_dmabuf *dmabuf)
 		dma_free_coherent(&pcidev->dev, BSG_MBOX_SIZE,
 				  dmabuf->virt, dmabuf->phys);
 	kfree(dmabuf);
-	return;
 }
 
 /**
@@ -2840,7 +2834,6 @@ lpfc_bsg_dma_page_list_free(struct lpfc_hba *phba,
 		list_del_init(&dmabuf->list);
 		lpfc_bsg_dma_page_free(phba, dmabuf);
 	}
-	return;
 }
 
 /**
@@ -3485,7 +3478,6 @@ lpfc_bsg_issue_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 		bsg_job_done(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	}
-	return;
 }
 
 /**
@@ -3602,8 +3594,6 @@ lpfc_bsg_mbox_ext_session_reset(struct lpfc_hba *phba)
 	memset((char *)&phba->mbox_ext_buf_ctx, 0,
 	       sizeof(struct lpfc_mbox_ext_buf_ctx));
 	INIT_LIST_HEAD(&phba->mbox_ext_buf_ctx.ext_dmabuf_list);
-
-	return;
 }
 
 /**
@@ -3735,7 +3725,6 @@ lpfc_bsg_issue_read_mbox_ext_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 		bsg_job_done(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	}
-	return;
 }
 
 /**
@@ -3773,8 +3762,6 @@ lpfc_bsg_issue_write_mbox_ext_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 		bsg_job_done(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	}
-
-	return;
 }
 
 static void
@@ -3867,7 +3854,6 @@ lpfc_bsg_sli_cfg_dma_desc_setup(struct lpfc_hba *phba, enum nemb_type nemb_tp,
 				hbd[index].pa_lo);
 		}
 	}
-	return;
 }
 
 /**
@@ -4375,7 +4361,6 @@ lpfc_bsg_mbox_ext_abort(struct lpfc_hba *phba)
 		phba->mbox_ext_buf_ctx.state = LPFC_BSG_MBOX_ABTS;
 	else
 		lpfc_bsg_mbox_ext_session_reset(phba);
-	return;
 }
 
 /**
@@ -5146,8 +5131,6 @@ lpfc_bsg_menlo_cmd_cmp(struct lpfc_hba *phba,
 		bsg_job_done(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 	}
-
-	return;
 }
 
 /**
-- 
2.25.1


