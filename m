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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44F87C47095
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 07:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B5A861185
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 07:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236418AbhFIHxp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 03:53:45 -0400
Received: from m12-16.163.com ([220.181.12.16]:33933 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234011AbhFIHxo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Jun 2021 03:53:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=yzplG
        75asoYc09xdxtMfLkUQduHZ1cBtf4qeYQErv/o=; b=BuYGyqpxTgBWPw1EmFiXy
        pPQPu9NFaa8NhIhZhEsIDwxr0bGSzu8hqT6fWWMpIBO5MExQCWmX6FkdXETXwS0k
        MPgGGPEZq5IpBfuPYYWlIHhCI/XYv9/epr7WRr6VMUXymhpvIAe6KQd0k1aOGnHy
        zbMJhnFuOkrGdpnSM+h0O0=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp12 (Coremail) with SMTP id EMCowAB3hFD0csBgRMiYwA--.19314S2;
        Wed, 09 Jun 2021 15:51:17 +0800 (CST)
From:   lijian_8010a29@163.com
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: [PATCH] scsi: lpfc: lpfc_init: Removed unnecessary 'return'
Date:   Wed,  9 Jun 2021 15:50:18 +0800
Message-Id: <20210609075018.474463-1-lijian_8010a29@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EMCowAB3hFD0csBgRMiYwA--.19314S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAFWrArykAr13Gr43Zr4DXFb_yoWrtFWrpa
        13Ga47Gr4kKF17KFnxJr15C3Way3y8X34jya1kt348ursYyrW3KFy5JFy0qrW5tFWvkrnI
        yrnFgFW5C3W7JFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jK0PhUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5olmxttqbyiikqdsmqqrwthudrp/1tbi3xWsUGB0Ge18ogAAsI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: lijian <lijian@yulong.com>

Removed unnecessary 'return'.

Signed-off-by: lijian <lijian@yulong.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 35 -----------------------------------
 1 file changed, 35 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index f6c26342ad69..932c6bdb8c40 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -288,7 +288,6 @@ lpfc_config_async_cmpl(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmboxq)
 	else
 		phba->temp_sensor_support = 0;
 	mempool_free(pmboxq, phba->mbox_mem_pool);
-	return;
 }
 
 /**
@@ -332,7 +331,6 @@ lpfc_dump_wakeup_param_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 			prg->ver, prg->rev, prg->lev,
 			dist, prg->num);
 	mempool_free(pmboxq, phba->mbox_mem_pool);
-	return;
 }
 
 /**
@@ -1149,7 +1147,6 @@ lpfc_hb_timeout(struct timer_list *t)
 	/* Tell the worker thread there is work to do */
 	if (!tmo_posted)
 		lpfc_worker_wake_up(phba);
-	return;
 }
 
 /**
@@ -1215,7 +1212,6 @@ lpfc_hb_mbox_cmpl(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmboxq)
 		mod_timer(&phba->hb_tmofunc,
 			  jiffies +
 			  msecs_to_jiffies(1000 * LPFC_HB_MBOX_INTERVAL));
-	return;
 }
 
 /*
@@ -1589,7 +1585,6 @@ lpfc_offline_eratt(struct lpfc_hba *phba)
 	lpfc_sli_brdready(phba, HS_MBRDY);
 	lpfc_unblock_mgmt_io(phba);
 	phba->link_state = LPFC_HBA_ERROR;
-	return;
 }
 
 /**
@@ -1831,7 +1826,6 @@ lpfc_handle_eratt_s3(struct lpfc_hba *phba)
 
 		lpfc_offline_eratt(phba);
 	}
-	return;
 }
 
 /**
@@ -2192,8 +2186,6 @@ lpfc_handle_latt(struct lpfc_hba *phba)
 
 	lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 			"0300 LATT: Cannot issue READ_LA: Data:%d\n", rc);
-
-	return;
 }
 
 /**
@@ -2958,7 +2950,6 @@ lpfc_stop_vport_timers(struct lpfc_vport *vport)
 	del_timer_sync(&vport->els_tmofunc);
 	del_timer_sync(&vport->delayed_disc_tmo);
 	lpfc_can_disctmo(vport);
-	return;
 }
 
 /**
@@ -3041,7 +3032,6 @@ lpfc_stop_hba_timers(struct lpfc_hba *phba)
 				phba->pci_dev_grp);
 		break;
 	}
-	return;
 }
 
 /**
@@ -4517,7 +4507,6 @@ destroy_port(struct lpfc_vport *vport)
 	spin_unlock_irq(&phba->port_list_lock);
 
 	lpfc_cleanup(vport);
-	return;
 }
 
 /**
@@ -6132,7 +6121,6 @@ static void lpfc_log_intr_mode(struct lpfc_hba *phba, uint32_t intr_mode)
 				"0482 Illegal interrupt mode.\n");
 		break;
 	}
-	return;
 }
 
 /**
@@ -6201,8 +6189,6 @@ lpfc_disable_pci_dev(struct lpfc_hba *phba)
 	/* Release PCI resource and disable PCI device */
 	pci_release_mem_regions(pdev);
 	pci_disable_device(pdev);
-
-	return;
 }
 
 /**
@@ -6548,8 +6534,6 @@ lpfc_sli_driver_resource_unset(struct lpfc_hba *phba)
 {
 	/* Free device driver memory allocated */
 	lpfc_mem_free_all(phba);
-
-	return;
 }
 
 /**
@@ -7159,8 +7143,6 @@ lpfc_sli4_driver_resource_unset(struct lpfc_hba *phba)
 		list_del_init(&conn_entry->list);
 		kfree(conn_entry);
 	}
-
-	return;
 }
 
 /**
@@ -7267,8 +7249,6 @@ lpfc_free_iocb_list(struct lpfc_hba *phba)
 		phba->total_iocbq_bufs--;
 	}
 	spin_unlock_irq(&phba->hbalock);
-
-	return;
 }
 
 /**
@@ -7678,7 +7658,6 @@ lpfc_hba_free(struct lpfc_hba *phba)
 	phba->sli.sli3_ring = NULL;
 
 	kfree(phba);
-	return;
 }
 
 /**
@@ -7756,8 +7735,6 @@ lpfc_destroy_shost(struct lpfc_hba *phba)
 
 	/* Destroy physical port that associated with the SCSI host */
 	destroy_port(vport);
-
-	return;
 }
 
 /**
@@ -7852,7 +7829,6 @@ lpfc_post_init_setup(struct lpfc_hba *phba)
 				  sizeof(adapter_event),
 				  (char *) &adapter_event,
 				  LPFC_NL_VENDOR_ID);
-	return;
 }
 
 /**
@@ -7990,8 +7966,6 @@ lpfc_sli_pci_mem_unset(struct lpfc_hba *phba)
 	/* I/O memory unmap */
 	iounmap(phba->ctrl_regs_memmap_p);
 	iounmap(phba->slim_memmap_p);
-
-	return;
 }
 
 /**
@@ -11236,7 +11210,6 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 	/* The cpu_map array will be used later during initialization
 	 * when EQ / CQ / WQs are allocated and configured.
 	 */
-	return;
 }
 
 /**
@@ -11853,8 +11826,6 @@ lpfc_unset_hba(struct lpfc_hba *phba)
 	lpfc_sli_brdrestart(phba);
 
 	lpfc_sli_disable_intr(phba);
-
-	return;
 }
 
 /**
@@ -13340,8 +13311,6 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 
 	/* Finally, free the driver's device data structure */
 	lpfc_hba_free(phba);
-
-	return;
 }
 
 /**
@@ -13725,7 +13694,6 @@ lpfc_pci_remove_one(struct pci_dev *pdev)
 				phba->pci_dev_grp);
 		break;
 	}
-	return;
 }
 
 /**
@@ -13904,7 +13872,6 @@ lpfc_io_resume(struct pci_dev *pdev)
 				phba->pci_dev_grp);
 		break;
 	}
-	return;
 }
 
 /**
@@ -13931,8 +13898,6 @@ lpfc_sli4_oas_verify(struct lpfc_hba *phba)
 		mempool_destroy(phba->device_data_mem_pool);
 		phba->device_data_mem_pool = NULL;
 	}
-
-	return;
 }
 
 /**
-- 
2.25.1


