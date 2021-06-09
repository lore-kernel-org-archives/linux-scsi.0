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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C11C47095
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 09:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80EBE6124C
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 09:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbhFIJZI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 05:25:08 -0400
Received: from m12-18.163.com ([220.181.12.18]:45423 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231300AbhFIJZH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Jun 2021 05:25:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=dJfON
        +wMxyXuV02ySXfdF5/CsQ8W/WArJHCeAn+R+Zk=; b=Pj+l8EnTJQ4HUeZVLQpM8
        m74O9EUzHhBF0IeMDc/60yotZyK9Cm7wAwcHBQz9/pT3TnQkRv9405ZC44niMwWW
        4jepxDcmtltoicILPYoFyOuyd/zAXdhlv7KmQgpTtGT2lApXtje/m1wNGj1asBUq
        +wSmleeHXj65sIU9Dw84Fk=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp14 (Coremail) with SMTP id EsCowAA3Oe9eiMBgxGqxoQ--.4788S2;
        Wed, 09 Jun 2021 17:22:39 +0800 (CST)
From:   lijian_8010a29@163.com
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: [PATCH] scsi: lpfc: lpfc_els: Removed unnecessary 'return'
Date:   Wed,  9 Jun 2021 17:21:41 +0800
Message-Id: <20210609092141.550597-1-lijian_8010a29@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowAA3Oe9eiMBgxGqxoQ--.4788S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxKFWkKFWDCF1DJr4fKF4xtFb_yoW7Cr1rpa
        nrGFy7Cw1ktF47Kry5JFs8ua1ayw10v3yDta10g340krsYyr9xKFyfury8Xr4YqFWj9rWa
        yrsrKrW5G3WkJrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jpsj8UUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5olmxttqbyiikqdsmqqrwthudrp/xtbBERqsUFaEEqmhxAAAs7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: lijian <lijian@yulong.com>

Removed unnecessary 'return'.

Signed-off-by: lijian <lijian@yulong.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 32 --------------------------------
 1 file changed, 32 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f743bb338665..e11da144ac45 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1564,8 +1564,6 @@ lpfc_more_plogi(struct lpfc_vport *vport)
 	if (vport->fc_flag & FC_NLP_MORE)
 		/* go thru NPR nodes and issue any remaining ELS PLOGIs */
 		lpfc_els_disc_plogi(vport);
-
-	return;
 }
 
 /**
@@ -1893,7 +1891,6 @@ lpfc_cmpl_els_rrq(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	lpfc_clr_rrq_active(phba, rrq->xritag, rrq);
 	lpfc_els_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(ndlp);
-	return;
 }
 /**
  * lpfc_cmpl_els_plogi - Completion callback function for plogi
@@ -2045,7 +2042,6 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	lpfc_els_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(free_ndlp);
-	return;
 }
 
 /**
@@ -2281,7 +2277,6 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 out:
 	lpfc_els_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(ndlp);
-	return;
 }
 
 /**
@@ -2603,7 +2598,6 @@ lpfc_more_adisc(struct lpfc_vport *vport)
 	}
 	if (!vport->num_disc_nodes)
 		lpfc_adisc_done(vport);
-	return;
 }
 
 /**
@@ -2710,7 +2704,6 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 out:
 	lpfc_els_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(ndlp);
-	return;
 }
 
 /**
@@ -3161,7 +3154,6 @@ lpfc_cmpl_els_disc_cmd(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	lpfc_els_chk_latt(vport);
 	lpfc_els_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(ndlp);
-	return;
 }
 
 /**
@@ -3589,7 +3581,6 @@ lpfc_cancel_retry_delay_tmo(struct lpfc_vport *vport, struct lpfc_nodelist *nlp)
 			}
 		}
 	}
-	return;
 }
 
 /**
@@ -3631,7 +3622,6 @@ lpfc_els_retry_delay(struct timer_list *t)
 		lpfc_worker_wake_up(phba);
 	}
 	spin_unlock_irqrestore(&phba->hbalock, flags);
-	return;
 }
 
 /**
@@ -3703,7 +3693,6 @@ lpfc_els_retry_delay_handler(struct lpfc_nodelist *ndlp)
 			lpfc_issue_els_fdisc(vport, ndlp, retry);
 		break;
 	}
-	return;
 }
 
 /**
@@ -4445,8 +4434,6 @@ lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		lpfc_nlp_put(ndlp);
 		lpfc_nlp_not_used(ndlp);
 	}
-
-	return;
 }
 
 /**
@@ -4590,7 +4577,6 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* Release the originating I/O reference. */
 	lpfc_els_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(ndlp);
-	return;
 }
 
 /**
@@ -5267,7 +5253,6 @@ lpfc_els_clear_rrq(struct lpfc_vport *vport,
 	prrq = lpfc_get_active_rrq(vport, xri, ndlp->nlp_DID);
 	if (prrq)
 		lpfc_clr_rrq_active(phba, xri, prrq);
-	return;
 }
 
 /**
@@ -7345,7 +7330,6 @@ lpfc_els_rsp_rls_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 	}
-	return;
 }
 
 /**
@@ -7945,7 +7929,6 @@ lpfc_els_timeout(struct timer_list *t)
 
 	if ((!tmo_posted) && (!(vport->load_flag & FC_UNLOADING)))
 		lpfc_worker_wake_up(phba);
-	return;
 }
 
 
@@ -8195,8 +8178,6 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 	/* Cancel all the IOCBs from the completions list */
 	lpfc_sli_cancel_iocbs(phba, &abort_list,
 			      IOSTAT_LOCAL_REJECT, IOERR_SLI_ABORTED);
-
-	return;
 }
 
 /**
@@ -8225,8 +8206,6 @@ lpfc_els_flush_all_cmd(struct lpfc_hba  *phba)
 	list_for_each_entry(vport, &phba->port_list, listentry)
 		lpfc_els_flush_cmd(vport);
 	spin_unlock_irq(&phba->port_list_lock);
-
-	return;
 }
 
 /**
@@ -8371,8 +8350,6 @@ lpfc_send_els_event(struct lpfc_vport *vport,
 			LPFC_NL_VENDOR_ID);
 		kfree(els_data);
 	}
-
-	return;
 }
 
 
@@ -9206,7 +9183,6 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	lpfc_nlp_put(ndlp);
 
 	mempool_free(pmb, phba->mbox_mem_pool);
-	return;
 }
 
 /**
@@ -9260,7 +9236,6 @@ lpfc_register_new_vport(struct lpfc_hba *phba, struct lpfc_vport *vport,
 	spin_lock_irq(shost->host_lock);
 	vport->fc_flag &= ~FC_VPORT_NEEDS_REG_VPI;
 	spin_unlock_irq(shost->host_lock);
-	return;
 }
 
 /**
@@ -9322,7 +9297,6 @@ lpfc_retry_pport_discovery(struct lpfc_hba *phba)
 	spin_unlock_irq(&ndlp->lock);
 	ndlp->nlp_last_elscmd = ELS_CMD_FLOGI;
 	phba->pport->port_state = LPFC_FLOGI;
-	return;
 }
 
 /**
@@ -9755,7 +9729,6 @@ lpfc_fabric_block_timeout(struct timer_list *t)
 
 	if (!tmo_posted)
 		lpfc_worker_wake_up(phba);
-	return;
 }
 
 /**
@@ -9829,7 +9802,6 @@ lpfc_unblock_fabric_iocbs(struct lpfc_hba *phba)
 	clear_bit(FABRIC_COMANDS_BLOCKED, &phba->bit_flags);
 
 	lpfc_resume_fabric_iocbs(phba);
-	return;
 }
 
 /**
@@ -9851,8 +9823,6 @@ lpfc_block_fabric_iocbs(struct lpfc_hba *phba)
 	if (!blocked)
 		mod_timer(&phba->fabric_block_timer,
 			  jiffies + msecs_to_jiffies(100));
-
-	return;
 }
 
 /**
@@ -10097,7 +10067,6 @@ lpfc_sli4_vport_delete_els_xri_aborted(struct lpfc_vport *vport)
 		}
 	}
 	spin_unlock_irqrestore(&phba->sli4_hba.sgl_list_lock, iflag);
-	return;
 }
 
 /**
@@ -10162,7 +10131,6 @@ lpfc_sli4_els_xri_aborted(struct lpfc_hba *phba,
 	}
 	sglq_entry->state = SGL_XRI_ABORTED;
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
-	return;
 }
 
 /* lpfc_sli_abts_recover_port - Recover a port that failed a BLS_ABORT req.
-- 
2.25.1


