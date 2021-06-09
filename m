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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15BF7C47095
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 08:04:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB7AF6128A
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 08:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236578AbhFIIGS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 04:06:18 -0400
Received: from m12-13.163.com ([220.181.12.13]:48790 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237557AbhFIIFi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Jun 2021 04:05:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=2QFsg
        HWbDLHSyne75bV8q+tTk9wN+wBNwY/fBdd4/6Y=; b=P8zxRm5V9I/YwaIsg1BsR
        sHVn3IJbzR/V+fPuMhAiIEAsJPT4PgXiHLwAL1xEU6n0OkiemC8tvmzz8zirKJtO
        YgiBqUTayo0pdn1jUZ0jrAtI+Ws164BVpT1zi9kSy10nGuWQMoWDq1or3TVw32z6
        z08XAnAJxn4NvPE1DJzYW4=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp9 (Coremail) with SMTP id DcCowABXjwOodcBgsgaOFQ--.3052S2;
        Wed, 09 Jun 2021 16:02:49 +0800 (CST)
From:   lijian_8010a29@163.com
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: [PATCH] scsi: lpfc: lpfc_sli: Removed unnecessary 'return'
Date:   Wed,  9 Jun 2021 16:01:51 +0800
Message-Id: <20210609080151.489666-1-lijian_8010a29@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcCowABXjwOodcBgsgaOFQ--.3052S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAFW5CF1kJF4UtFW5Aw48Crg_yoW5WFWfpa
        nrGay7ur4ktF17trW5AFs8uFsIy3y0v34jyan2g34Y9F4vyrWfKFW3JFy0qr45tFWq9rnY
        yw42gFW5Ca1xJrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jZMa5UUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5olmxttqbyiikqdsmqqrwthudrp/1tbiLwmsUFUMY3+iFgAAsr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: lijian <lijian@yulong.com>

Removed unnecessary 'return'.

Signed-off-by: lijian <lijian@yulong.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 368cbc10e0cf..14e1ddc5ac17 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1544,7 +1544,6 @@ lpfc_sli_cancel_iocbs(struct lpfc_hba *phba, struct list_head *iocblist,
 			lpfc_sli_release_iocbq(phba, piocb);
 		}
 	}
-	return;
 }
 
 /**
@@ -2054,8 +2053,6 @@ lpfc_sli_resume_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 		else
 			lpfc_sli_update_full_ring(phba, pring);
 	}
-
-	return;
 }
 
 /**
@@ -2566,7 +2563,6 @@ lpfc_sli_wake_mbox_wait(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 	if (pmbox_done)
 		complete(pmbox_done);
 	spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
-	return;
 }
 
 static void
@@ -3560,8 +3556,6 @@ lpfc_sli_rsp_pointers_error(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 	phba->work_hs = HS_FFER3;
 
 	lpfc_worker_wake_up(phba);
-
-	return;
 }
 
 /**
@@ -3608,7 +3602,6 @@ void lpfc_poll_eratt(struct timer_list *t)
 		mod_timer(&phba->eratt_poll,
 			  jiffies +
 			  msecs_to_jiffies(1000 * phba->eratt_poll_interval));
-	return;
 }
 
 
@@ -4135,7 +4128,6 @@ lpfc_sli_handle_slow_ring_event_s3(struct lpfc_hba *phba,
 	}
 
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
-	return;
 }
 
 /**
@@ -6439,8 +6431,6 @@ lpfc_set_features(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox,
 		mbox->u.mqe.un.set_feature.param_len = 4;
 		break;
 	}
-
-	return;
 }
 
 /**
@@ -8162,7 +8152,6 @@ lpfc_mbox_timeout(struct timer_list *t)
 
 	if (!tmo_posted)
 		lpfc_worker_wake_up(phba);
-	return;
 }
 
 /**
@@ -11572,7 +11561,6 @@ lpfc_sli_abort_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	}
 release_iocb:
 	lpfc_sli_release_iocbq(phba, cmdiocb);
-	return;
 }
 
 /**
@@ -11939,7 +11927,6 @@ lpfc_sli_abort_fcp_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			cmdiocb->iotag, rspiocb->iocb.ulpStatus,
 			rspiocb->iocb.un.ulpWord[4]);
 	lpfc_sli_release_iocbq(phba, cmdiocb);
-	return;
 }
 
 /**
@@ -12219,7 +12206,6 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba *phba,
 	if (pdone_q)
 		wake_up(pdone_q);
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
-	return;
 }
 
 /**
@@ -15078,7 +15064,6 @@ lpfc_sli4_queue_free(struct lpfc_queue *queue)
 		list_del(&queue->cpu_list);
 
 	kfree(queue);
-	return;
 }
 
 /**
@@ -15306,7 +15291,6 @@ lpfc_modify_hba_eq_delay(struct lpfc_hba *phba, uint32_t startq,
 				shdr_status, shdr_add_status, rc);
 	}
 	mempool_free(mbox, phba->mbox_mem_pool);
-	return;
 }
 
 /**
@@ -19967,7 +19951,6 @@ lpfc_sli_read_link_ste(struct lpfc_hba *phba)
 
 out:
 	kfree(rgn23_data);
-	return;
 }
 
 /**
-- 
2.25.1


