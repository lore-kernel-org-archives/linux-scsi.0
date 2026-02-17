Received: from alln-iport-5.cisco.com (alln-iport-5.cisco.com [173.37.142.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7262F3C2D;
	Tue, 17 Feb 2026 22:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771368065; cv=none; b=Igz+kjZaSHjl8zlhVw6omf1QOhYfN65yRuS1CK3zzpLW8ZAYA2J6piItZiRhR/xVfzdgwPBB+9RcNH2ZY365JJbHWHVMrsplBhUy+h+qNhcn3FfoqFyEE6nyIhgYuIxb47lEeCgzv2zqiUASrcmZxzhyBGLFzYR3NkW9RO5CuSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771368065; c=relaxed/simple;
	bh=vzQGVgTGYEJEfXUChniuA47iiHmFBYkwyFa2YGgJCTM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XZHgb8juBWY03BUjxjVC17PcifGWCkGjciDhkVVQorDJINqhlWP3BaAdSPLEIDxX2uIfenh63qZsKmXaFodsh4sfS5pmqzLb2uizJf7LIqCBMNFYT8vusYyHxy+X19l3Lb+O+3Hsl+1FvjyOfWyXe4+hAvgtyEyKnRBHlzKAEHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=Oo4A23IH; arc=none smtp.client-ip=173.37.142.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="Oo4A23IH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=10118; q=dns/txt;
  s=iport01; t=1771368063; x=1772577663;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Qfb5KaLZCJ5JFBW64NqpyqWsexriuZMsnr3gYgNM7Yk=;
  b=Oo4A23IHKQxcg8xNLg+XIfa4EvmtiqiRs9j7X5qBXJ/FwMvB3at6Erfy
   RiJ33CgNi9eUjVjUiv6xHfAsI85qTtvN+acLkpnXGledAWNV2ficQ3+ck
   Er/x9N+5yWAzUjRLTlRtWRXkfpHEnH7bkOqjwVZXNquIRu2ga8/2vAiVR
   HbbfWA/lki+k/GFT4dqzjUhvj0dRDmAMKuEeykl+VZyU4X1+loDAMiWTj
   W9p0YY2SkRxbzFxD+p79Ba5oWXJOhicVJL5P6xG1Q2Gvm4hLLn0igjfy4
   1Qph1OGA8vrLWqGusU0Z/OVKIVBZK1XpUadXYpHSFC9F/ODIzbrRRGRUC
   g==;
X-CSE-ConnectionGUID: KdG1WSNcSYKbiFZK6qcdyA==
X-CSE-MsgGUID: zHADECWxTV+T1baelwe6eQ==
X-IPAS-Result: =?us-ascii?q?A0AyBgAO7ZRp/5X/Ja1aglmCSA+BT0MZMJQqoD6Bfw8BA?=
 =?us-ascii?q?QEPUQQBAYUHjSECJjQJDgECBAEBAQEDAgMBAQEBAQEBAQEBAQsBAQUBAQECA?=
 =?us-ascii?q?QcFgQ4ThlyGXSsLAUaBUIMCgnQDrX6BeTOBAd4+gWQBCxQBgTiNVXSEeicVB?=
 =?us-ascii?q?oFJRIEVg2iBUok1BIMcFIo0iS1IgR4DWSwBVRMNCgsHBYFmAzUSKhVuMh2BI?=
 =?us-ascii?q?z4XgQsbBwWHcw+JBXhugR+BDAMLGA1IESw3FBsEPm4HjjpBgjOBD4ITKwFjk?=
 =?us-ascii?q?mMJAQeSNYE1n1mEJqFYGjOqa5kGqUGBaDyBWTMaCBsVO4JnUhkPji0WxFYlM?=
 =?us-ascii?q?jwCBwsBAQMJkwdgAQE?=
IronPort-Data: A9a23:iFwQU6x9yjtaklUx9bh6t+fHxyrEfRIJ4+MujC+fZmUNrF6WrkUOm
 mMcW2CAafzcYGekct8kOdu+o0gBv8KDyoNkHAVp+VhgHilAwSbn6Xt1DatR0we6dJCroJdPt
 p1GAjX4BJlqCCea/VH1buSJQUBUjcmgXqD7BPPPJhd/TAplTDZJoR94kobVuKYw6TSCK13L4
 4qaT/H3Ygf/hWYuaz1MscpvlTs21BjMkGJA1rABTagjUG/2zxE9EJ8ZLKetGHr0KqE8NvK6X
 evK0Iai9Wrf+Ro3Yvv9+losWhRXKlJ6FVHmZkt+A8BOsDAbzsAB+vpT2M4nVKtio27hc+adZ
 zl6ncfYpQ8BZsUgkQmGOvVSO3kW0aZuoNcrLZUj2CCe5xWuTpfi/xlhJGI6EtQnwcB8OlBt/
 /02GhNTdxuPlsvjldpXSsE07igiBNPgMIVavjRryivUSK98B5vCWK7No9Rf2V/chOgXQq2YP
 JVfM2cyKk2cMnWjOX9PYH46tOShnGX+dzRbgFmUvqEwpWPUyWSd1ZCzb4KNJobQG5o9ckCwt
 ELv00nSPQEmCp+jkDCM/3azi7HCpHauMG4VPPjinhJwu3WTz3YeIB4bT122pb++kEHWc95WL
 Qof8zA2oK4u+VaDStj7Vge/5nmesXY0WddSGcU+6QeQ2uzV6QPfDW8BJhZEYcY6tclwXTE22
 0WSktXBAiZmu7mYD3ma89+8rza/PyUaLW4qfyIITQIZpdLkpekblB/RQ8x4OLS4gt38BXf7x
 DXihCg3nbg7ltMQ2uO38DjvhzOqu4iMTQMv4AjTdnyq4xk/Z4O/YYGsr1/B4p5oKIefU0nEp
 3MfmuCA4+0US5KAjiqARKMKBr7B2hqeGCfXjVgqG9wq8C6gvif5O4tR+zp5YkxuN67oZAPUX
 aMagisJjLc7AZdgRfUfj16ZYyjy8ZXdKA==
IronPort-HdrOrdr: A9a23:/yPCBa0Q2L0wda31TuWSuAqjBIEkLtp133Aq2lEZdPWaSKClfq
 eV7ZYmPHDP5gr5NEtLpTniAtjifZq/z/9ICOAqVN/IYOCMggSVxe9ZgLfK8nnJBzD++ulB1a
 1pbqRyTOHrAUMSt7ee3ODBKbYdKB3tytHOuQ8YpE0dKT1XVw==
X-Talos-CUID: 9a23:NaOS2GCivzqtBRb6Ewpr2xcrIeYuSUz+xnb+EWzmEG1lWZTAHA==
X-Talos-MUID: =?us-ascii?q?9a23=3A0jiwOA6IYUx9HnTYm/ufuU52xox6w42CJWsygak?=
 =?us-ascii?q?4+PXdPyV9PyiQ0jmOF9o=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.21,297,1763424000"; 
   d="scan'208";a="670042267"
Received: from rcdn-l-core-12.cisco.com ([173.37.255.149])
  by alln-iport-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 17 Feb 2026 22:39:55 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.109.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-12.cisco.com (Postfix) with ESMTPSA id 5FB90180001CE;
	Tue, 17 Feb 2026 22:39:53 +0000 (GMT)
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com,
	djhawar@cisco.com,
	gcboffa@cisco.com,
	aeasi@cisco.com,
	mkai2@cisco.com,
	satishkh@cisco.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jmeneghi@redhat.com,
	revers@redhat.com,
	dan.carpenter@linaro.org,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Hannes Reinecke <hare@suse.de>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 1/5] scsi: fnic: Use mempool for receive frames
Date: Tue, 17 Feb 2026 14:39:39 -0800
Message-ID: <20260217223943.7938-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.109.174, [10.188.109.174]
X-Outbound-Node: rcdn-l-core-12.cisco.com

The receive frames are constantly replenished so we should rather
use a mempool here.

fip_frame_queue is an rxq. De-alloc it in fnic_free_rxq.
Incorporate review comments from Hannes:
    Modify fnic_free_txq to have same arguments as fnic_free_rxq

Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Co-developed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/fnic/fnic.h      |  4 ++-
 drivers/scsi/fnic/fnic_fcs.c  | 54 ++++++++++++++++++++++++-----------
 drivers/scsi/fnic/fnic_main.c | 28 ++++++++++++++++--
 drivers/scsi/fnic/fnic_scsi.c |  2 +-
 4 files changed, 66 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 42237eb3222f..88b47ea04ab2 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -438,6 +438,7 @@ struct fnic {
 	struct list_head tx_queue;
 	mempool_t *frame_pool;
 	mempool_t *frame_elem_pool;
+	mempool_t *frame_recv_pool;
 	struct work_struct tport_work;
 	struct list_head tport_event_list;
 
@@ -541,7 +542,8 @@ fnic_chk_state_flags_locked(struct fnic *fnic, unsigned long st_flags)
 }
 void __fnic_set_state_flags(struct fnic *, unsigned long, unsigned long);
 void fnic_dump_fchost_stats(struct Scsi_Host *, struct fc_host_statistics *);
-void fnic_free_txq(struct list_head *head);
+void fnic_free_txq(struct fnic *fnic);
+void fnic_free_rxq(struct fnic *fnic);
 int fnic_get_desc_by_devid(struct pci_dev *pdev, char **desc,
 						   char **subsys_desc);
 void fnic_fdls_link_status_change(struct fnic *fnic, int linkup);
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 103ab6f1f7cd..f6d6ad64983f 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -291,7 +291,7 @@ void fnic_handle_frame(struct work_struct *work)
 		if (fnic->stop_rx_link_events) {
 			list_del(&cur_frame->links);
 			spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
-			kfree(cur_frame->fp);
+			mempool_free(cur_frame->fp, fnic->frame_recv_pool);
 			mempool_free(cur_frame, fnic->frame_elem_pool);
 			return;
 		}
@@ -317,7 +317,7 @@ void fnic_handle_frame(struct work_struct *work)
 		fnic_fdls_recv_frame(&fnic->iport, cur_frame->fp,
 							 cur_frame->frame_len, fchdr_offset);
 
-		kfree(cur_frame->fp);
+		mempool_free(cur_frame->fp, fnic->frame_recv_pool);
 		mempool_free(cur_frame, fnic->frame_elem_pool);
 	}
 	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
@@ -337,8 +337,8 @@ void fnic_handle_fip_frame(struct work_struct *work)
 		if (fnic->stop_rx_link_events) {
 			list_del(&cur_frame->links);
 			spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
-			kfree(cur_frame->fp);
-			kfree(cur_frame);
+			mempool_free(cur_frame->fp, fnic->frame_recv_pool);
+			mempool_free(cur_frame, fnic->frame_elem_pool);
 			return;
 		}
 
@@ -355,8 +355,8 @@ void fnic_handle_fip_frame(struct work_struct *work)
 		list_del(&cur_frame->links);
 
 		if (fdls_fip_recv_frame(fnic, cur_frame->fp)) {
-			kfree(cur_frame->fp);
-			kfree(cur_frame);
+			mempool_free(cur_frame->fp, fnic->frame_recv_pool);
+			mempool_free(cur_frame, fnic->frame_elem_pool);
 		}
 	}
 	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
@@ -375,10 +375,10 @@ static inline int fnic_import_rq_eth_pkt(struct fnic *fnic, void *fp)
 
 	eh = (struct ethhdr *) fp;
 	if ((eh->h_proto == cpu_to_be16(ETH_P_FIP)) && (fnic->iport.usefip)) {
-		fip_fr_elem = (struct fnic_frame_list *)
-			kzalloc(sizeof(struct fnic_frame_list), GFP_ATOMIC);
+		fip_fr_elem = mempool_alloc(fnic->frame_elem_pool, GFP_ATOMIC);
 		if (!fip_fr_elem)
 			return 0;
+		memset(fip_fr_elem, 0, sizeof(struct fnic_frame_list));
 		fip_fr_elem->fp = fp;
 		spin_lock_irqsave(&fnic->fnic_lock, flags);
 		list_add_tail(&fip_fr_elem->links, &fnic->fip_frame_queue);
@@ -538,7 +538,7 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 	return;
 
 drop:
-	kfree(fp);
+	mempool_free(fp, fnic->frame_recv_pool);
 }
 
 static int fnic_rq_cmpl_handler_cont(struct vnic_dev *vdev,
@@ -591,7 +591,7 @@ int fnic_alloc_rq_frame(struct vnic_rq *rq)
 	int ret;
 
 	len = FNIC_FRAME_HT_ROOM;
-	buf = kmalloc(len, GFP_ATOMIC);
+	buf = mempool_alloc(fnic->frame_recv_pool, GFP_ATOMIC);
 	if (!buf) {
 		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Unable to allocate RQ buffer of size: %d\n", len);
@@ -609,7 +609,7 @@ int fnic_alloc_rq_frame(struct vnic_rq *rq)
 	fnic_queue_rq_desc(rq, buf, pa, len);
 	return 0;
 free_buf:
-	kfree(buf);
+	mempool_free(buf, fnic->frame_recv_pool);
 	return ret;
 }
 
@@ -621,7 +621,7 @@ void fnic_free_rq_buf(struct vnic_rq *rq, struct vnic_rq_buf *buf)
 	dma_unmap_single(&fnic->pdev->dev, buf->dma_addr, buf->len,
 			 DMA_FROM_DEVICE);
 
-	kfree(rq_buf);
+	mempool_free(rq_buf, fnic->frame_recv_pool);
 	buf->os_buf = NULL;
 }
 
@@ -836,14 +836,34 @@ fnic_fdls_register_portid(struct fnic_iport_s *iport, u32 port_id,
 	return 0;
 }
 
-void fnic_free_txq(struct list_head *head)
+void fnic_free_txq(struct fnic *fnic)
 {
 	struct fnic_frame_list *cur_frame, *next;
 
-	list_for_each_entry_safe(cur_frame, next, head, links) {
+	list_for_each_entry_safe(cur_frame, next, &fnic->tx_queue, links) {
 		list_del(&cur_frame->links);
-		kfree(cur_frame->fp);
-		kfree(cur_frame);
+		mempool_free(cur_frame->fp, fnic->frame_pool);
+		mempool_free(cur_frame, fnic->frame_elem_pool);
+	}
+}
+
+void fnic_free_rxq(struct fnic *fnic)
+{
+	struct fnic_frame_list *cur_frame, *next;
+
+	list_for_each_entry_safe(cur_frame, next, &fnic->frame_queue, links) {
+		list_del(&cur_frame->links);
+		mempool_free(cur_frame->fp, fnic->frame_recv_pool);
+		mempool_free(cur_frame, fnic->frame_elem_pool);
+	}
+
+	if (fnic->config.flags & VFCF_FIP_CAPABLE) {
+		list_for_each_entry_safe(cur_frame, next,
+				&fnic->fip_frame_queue, links) {
+			list_del(&cur_frame->links);
+			mempool_free(cur_frame->fp, fnic->frame_recv_pool);
+			mempool_free(cur_frame, fnic->frame_elem_pool);
+		}
 	}
 }
 
@@ -898,7 +918,7 @@ void fnic_free_wq_buf(struct vnic_wq *wq, struct vnic_wq_buf *buf)
 	dma_unmap_single(&fnic->pdev->dev, buf->dma_addr, buf->len,
 			 DMA_TO_DEVICE);
 
-	kfree(buf->os_buf);
+	mempool_free(buf->os_buf, fnic->frame_pool);
 	buf->os_buf = NULL;
 }
 
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 4cc4077ea53c..1c1fdf2a389e 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -40,6 +40,7 @@ static struct kmem_cache *fnic_sgl_cache[FNIC_SGL_NUM_CACHES];
 static struct kmem_cache *fnic_io_req_cache;
 static struct kmem_cache *fdls_frame_cache;
 static struct kmem_cache *fdls_frame_elem_cache;
+static struct kmem_cache *fdls_frame_recv_cache;
 static LIST_HEAD(fnic_list);
 static DEFINE_SPINLOCK(fnic_list_lock);
 static DEFINE_IDA(fnic_ida);
@@ -554,6 +555,7 @@ static int fnic_cleanup(struct fnic *fnic)
 	mempool_destroy(fnic->io_req_pool);
 	mempool_destroy(fnic->frame_pool);
 	mempool_destroy(fnic->frame_elem_pool);
+	mempool_destroy(fnic->frame_recv_pool);
 	for (i = 0; i < FNIC_SGL_NUM_CACHES; i++)
 		mempool_destroy(fnic->io_sgl_pool[i]);
 
@@ -928,6 +930,14 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 	fnic->frame_elem_pool = pool;
 
+	pool = mempool_create_slab_pool(FDLS_MIN_FRAMES,
+						fdls_frame_recv_cache);
+	if (!pool) {
+		err = -ENOMEM;
+		goto err_out_fdls_frame_recv_pool;
+	}
+	fnic->frame_recv_pool = pool;
+
 	/* setup vlan config, hw inserts vlan header */
 	fnic->vlan_hw_insert = 1;
 	fnic->vlan_id = 0;
@@ -1085,6 +1095,8 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 	vnic_dev_notify_unset(fnic->vdev);
 err_out_fnic_notify_set:
+	mempool_destroy(fnic->frame_recv_pool);
+err_out_fdls_frame_recv_pool:
 	mempool_destroy(fnic->frame_elem_pool);
 err_out_fdls_frame_elem_pool:
 	mempool_destroy(fnic->frame_pool);
@@ -1157,7 +1169,6 @@ static void fnic_remove(struct pci_dev *pdev)
 		timer_delete_sync(&fnic->enode_ka_timer);
 		timer_delete_sync(&fnic->vn_ka_timer);
 
-		fnic_free_txq(&fnic->fip_frame_queue);
 		fnic_fcoe_reset_vlans(fnic);
 	}
 
@@ -1177,8 +1188,8 @@ static void fnic_remove(struct pci_dev *pdev)
 	list_del(&fnic->list);
 	spin_unlock_irqrestore(&fnic_list_lock, flags);
 
-	fnic_free_txq(&fnic->frame_queue);
-	fnic_free_txq(&fnic->tx_queue);
+	fnic_free_rxq(fnic);
+	fnic_free_txq(fnic);
 
 	vnic_dev_notify_unset(fnic->vdev);
 	fnic_free_intr(fnic);
@@ -1287,6 +1298,15 @@ static int __init fnic_init_module(void)
 		goto err_create_fdls_frame_cache_elem;
 	}
 
+	fdls_frame_recv_cache = kmem_cache_create("fdls_frame_recv",
+						  FNIC_FRAME_HT_ROOM,
+						  0, SLAB_HWCACHE_ALIGN, NULL);
+	if (!fdls_frame_recv_cache) {
+		pr_err("fnic fdls frame recv cach create failed\n");
+		err = -ENOMEM;
+		goto err_create_fdls_frame_recv_cache;
+	}
+
 	fnic_event_queue =
 		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, "fnic_event_wq");
 	if (!fnic_event_queue) {
@@ -1339,6 +1359,8 @@ static int __init fnic_init_module(void)
 	if (pc_rscn_handling_feature_flag == PC_RSCN_HANDLING_FEATURE_ON)
 		destroy_workqueue(reset_fnic_work_queue);
 err_create_reset_fnic_workq:
+	kmem_cache_destroy(fdls_frame_recv_cache);
+err_create_fdls_frame_recv_cache:
 	destroy_workqueue(fnic_event_queue);
 err_create_fnic_workq:
 	kmem_cache_destroy(fdls_frame_elem_cache);
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 29d7aca06958..1494aeb908ba 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -777,7 +777,7 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fnic *fnic,
 	 */
 	if (ret) {
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		fnic_free_txq(&fnic->tx_queue);
+		fnic_free_txq(fnic);
 		goto reset_cmpl_handler_end;
 	}
 
-- 
2.47.1

