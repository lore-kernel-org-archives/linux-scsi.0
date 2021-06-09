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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 693EAC47095
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 09:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 543F661375
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 09:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235105AbhFIJ5y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 05:57:54 -0400
Received: from m12-14.163.com ([220.181.12.14]:60437 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238367AbhFIJ5x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Jun 2021 05:57:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=RQ9DQ
        KpHgkyziF9WoACmrsjpsx+HFCbf6WDfWPqQp8E=; b=MSKuJN9gKq8gNugdOl3Qt
        Q6zQEzH2nur93N5s5QXZAm2jGF7KJyYT0AmklLUxFqDvAER9gw8v++x7PKaQOvB3
        TNm7Ypbym9fIA9SPsPT/ncCPVr2giHLAvjYMxITt23dnsojBEh/O5Hro0IkyByWX
        wYNq/wqj2zO6ilXquieugg=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp10 (Coremail) with SMTP id DsCowADH0YQPkMBg7UAyNw--.22912S2;
        Wed, 09 Jun 2021 17:55:27 +0800 (CST)
From:   lijian_8010a29@163.com
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: [PATCH] scsi: lpfc: lpfc_hbadisc: Removed unnecessary 'return'
Date:   Wed,  9 Jun 2021 17:54:30 +0800
Message-Id: <20210609095430.611383-1-lijian_8010a29@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsCowADH0YQPkMBg7UAyNw--.22912S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxKw18JF45Ar1fJFWUJr1rXrb_yoW7uw4kpa
        nrCas7Wr4kGF13KrZxJF15A3Wayw40yryqya1DK34fursY9rZ3GFy7JFW0grs8tFW0kryY
        yrnFgw45G3W8XFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jpsj8UUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5olmxttqbyiikqdsmqqrwthudrp/1tbiEQ+sUF7+3pa30AAAst
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: lijian <lijian@yulong.com>

Removed unnecessary 'return'.

Signed-off-by: lijian <lijian@yulong.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 38 --------------------------------
 1 file changed, 38 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 40a5a7f02fa2..8ade5a520897 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -232,8 +232,6 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 		lpfc_worker_wake_up(phba);
 	}
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
-
-	return;
 }
 
 /**
@@ -510,7 +508,6 @@ lpfc_send_fastpath_evt(struct lpfc_hba *phba,
 			LPFC_NL_VENDOR_ID);
 
 	lpfc_free_fast_evt(phba, fast_evt_data);
-	return;
 }
 
 static void
@@ -1141,8 +1138,6 @@ lpfc_mbx_cmpl_clear_la(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	writel(control, phba->HCregaddr);
 	readl(phba->HCregaddr); /* flush */
 	spin_unlock_irq(&phba->hbalock);
-
-	return;
 }
 
 void
@@ -1232,7 +1227,6 @@ lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 			 vport->port_state);
 
 	lpfc_issue_clear_la(phba, vport);
-	return;
 }
 
 /**
@@ -1567,8 +1561,6 @@ lpfc_register_fcf(struct lpfc_hba *phba)
 		spin_unlock_irq(&phba->hbalock);
 		mempool_free(fcf_mbxq, phba->mbox_mem_pool);
 	}
-
-	return;
 }
 
 /**
@@ -2624,8 +2616,6 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 out:
 	lpfc_sli4_mbox_cmd_free(phba, mboxq);
 	lpfc_register_fcf(phba);
-
-	return;
 }
 
 /**
@@ -2826,7 +2816,6 @@ lpfc_init_vfi_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 
 	lpfc_initial_flogi(vport);
 	mempool_free(mboxq, phba->mbox_mem_pool);
-	return;
 }
 
 /**
@@ -2908,7 +2897,6 @@ lpfc_init_vpi_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 				 "2606 No NPIV Fabric support\n");
 	}
 	mempool_free(mboxq, phba->mbox_mem_pool);
-	return;
 }
 
 /**
@@ -3090,7 +3078,6 @@ lpfc_mbx_cmpl_reg_vfi(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 		lpfc_mbuf_free(phba, dmabuf->virt, dmabuf->phys);
 		kfree(dmabuf);
 	}
-	return;
 }
 
 static void
@@ -3154,7 +3141,6 @@ lpfc_mbx_cmpl_read_sparam(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	kfree(mp);
 	lpfc_issue_clear_la(phba, vport);
 	mempool_free(pmb, phba->mbox_mem_pool);
-	return;
 }
 
 static void
@@ -3381,7 +3367,6 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
 			 "0263 Discovery Mailbox error: state: 0x%x : x%px x%px\n",
 			 vport->port_state, sparam_mbox, cfglink_mbox);
 	lpfc_issue_clear_la(phba, vport);
-	return;
 }
 
 static void
@@ -3569,7 +3554,6 @@ lpfc_mbx_cmpl_read_topology(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
 	mempool_free(pmb, phba->mbox_mem_pool);
-	return;
 }
 
 /*
@@ -3629,8 +3613,6 @@ lpfc_mbx_cmpl_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	 * function.
 	 */
 	lpfc_nlp_put(ndlp);
-
-	return;
 }
 
 static void
@@ -3745,7 +3727,6 @@ lpfc_mbx_cmpl_reg_vpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 
 out:
 	mempool_free(pmb, phba->mbox_mem_pool);
-	return;
 }
 
 /**
@@ -3890,8 +3871,6 @@ lpfc_create_static_vport(struct lpfc_hba *phba)
 		}
 		mempool_free(pmb, phba->mbox_mem_pool);
 	}
-
-	return;
 }
 
 /*
@@ -3970,7 +3949,6 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	 * all the current reference to the ndlp have been done.
 	 */
 	lpfc_nlp_put(ndlp);
-	return;
 }
 
  /*
@@ -4156,8 +4134,6 @@ lpfc_mbx_cmpl_ns_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
 	mempool_free(pmb, phba->mbox_mem_pool);
-
-	return;
 }
 
 static void
@@ -4242,8 +4218,6 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	    (rport->scsi_target_id < LPFC_MAX_TARGET)) {
 		ndlp->nlp_sid = rport->scsi_target_id;
 	}
-
-	return;
 }
 
 static void
@@ -4557,7 +4531,6 @@ lpfc_drop_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	}
 
 	lpfc_nlp_put(ndlp);
-	return;
 }
 
 /*
@@ -4599,8 +4572,6 @@ lpfc_set_disctmo(struct lpfc_vport *vport)
 			 vport->port_state, tmo,
 			 (unsigned long)&vport->fc_disctmo, vport->fc_plogi_cnt,
 			 vport->fc_adisc_cnt);
-
-	return;
 }
 
 /*
@@ -5414,7 +5385,6 @@ lpfc_disc_list_loopmap(struct lpfc_vport *vport)
 			lpfc_setup_disc_node(vport, alpa);
 		}
 	}
-	return;
 }
 
 /* SLI3 only */
@@ -5566,7 +5536,6 @@ lpfc_disc_start(struct lpfc_vport *vport)
 				lpfc_els_handle_rscn(vport);
 		}
 	}
-	return;
 }
 
 /*
@@ -5681,7 +5650,6 @@ lpfc_disc_timeout(struct timer_list *t)
 
 	if (!tmo_posted)
 		lpfc_worker_wake_up(phba);
-	return;
 }
 
 static void
@@ -5916,7 +5884,6 @@ lpfc_disc_timeout_handler(struct lpfc_vport *vport)
 		}
 		vport->port_state = LPFC_VPORT_READY;
 	}
-	return;
 }
 
 /*
@@ -5967,8 +5934,6 @@ lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
 	mempool_free(pmb, phba->mbox_mem_pool);
-
-	return;
 }
 
 static int
@@ -6347,7 +6312,6 @@ lpfc_unregister_vfi_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	phba->pport->fc_flag &= ~FC_VFI_REGISTERED;
 	spin_unlock_irq(shost->host_lock);
 	mempool_free(mboxq, phba->mbox_mem_pool);
-	return;
 }
 
 /**
@@ -6369,7 +6333,6 @@ lpfc_unregister_fcfi_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 				mboxq->u.mb.mbxStatus, vport->port_state);
 	}
 	mempool_free(mboxq, phba->mbox_mem_pool);
-	return;
 }
 
 /**
@@ -6713,7 +6676,6 @@ lpfc_read_fcoe_param(struct lpfc_hba *phba,
 	phba->fc_map[0] = fcoe_param->fc_map[0];
 	phba->fc_map[1] = fcoe_param->fc_map[1];
 	phba->fc_map[2] = fcoe_param->fc_map[2];
-	return;
 }
 
 /**
-- 
2.25.1

