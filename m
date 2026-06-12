Received: from rcdn-iport-1.cisco.com (rcdn-iport-1.cisco.com [173.37.86.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F0D37FF60;
	Fri, 12 Jun 2026 18:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781288072; cv=none; b=jcuRfMu0UOjMZNKulQ5A8qoEPDTg8dn8C4FmiTxGCphSt9kUoaOvk4wiZhkM/NDNhHXNNfZ09wqDR8WwgFtP1tK44lAELxQ0CBj5hcUby8LAJaXxMHVL+E4oXreACYUDw/IoBaT8148fxWgsv5JuTfbzhRfkVBk58T1K0ZUWeTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781288072; c=relaxed/simple;
	bh=K8bs+J/1b0beKnHceklMa5cAQn7e/0sS5nU26ctAxwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnhJmc2OF15ywdRSViV+/wd4lxpgLc7BXqtnj3tYd4X9Dv3jwYOdAqv9yK2T15WGOB544REsbcA273oymCAMftfkGrmPBDBPWrvnc2g8fTNijHo9AjZJmYChXZilFK6ox9eMwT2B4OOg+WZfF066qJHlika5y1JFnjlvPCRKGg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=ROR6g8G+; arc=none smtp.client-ip=173.37.86.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="ROR6g8G+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=7732; q=dns/txt;
  s=iport01; t=1781288071; x=1782497671;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/KDfKDrD0N8yAr13rjZu09SmZTUj7TY7J0FWbbrDXu8=;
  b=ROR6g8G+CfBqGJsFleRj99er4b0hzpGTOtq1kwdXvpmySgLw/iybgkEa
   f5Iv752YAEMHWFABIIoMERJu0QIzrdPTU1GWVD/YmOsvoXbFqMuhUqt+P
   4u5m5ZCWRBo2REfMx2CuyDL8n34QNiL8rw6cUy997Ve4FlbwsShd2QLsQ
   SwQkeeUVsJYKsuJYeUZeI4Zr7NlsetALhqdnP7hjk3+X0AT1LcKBC0RiE
   z+tBZC4Su8lqyc33kDLepG4jBIz4ebfUSUT0uHAfhoF9PVsHXE1b/aO1f
   Ow+220Y1FqG6buUopvX+jT5owJrJ2cdpkGILWtPzwCEuf6h7zNZ2IL6E+
   g==;
X-CSE-ConnectionGUID: CUErVJ1fTqymTsOuBndYkw==
X-CSE-MsgGUID: RmBhAHQKQhOrpbe6Zuobkw==
X-IPAS-Result: =?us-ascii?q?A0BEAgBqSyxq/4v/Ja1aHgEBCxIMggULgld0XkMZMASUJ?=
 =?us-ascii?q?oIhgRadCIF+DwEBAQ9EDQQBAYUGAo1DAiY0CQ4BAgQDAgMBAQEBAQEBAQEBA?=
 =?us-ascii?q?QsBAQUBAQECAQcFgQ4Thk8NhlsCAQMnCwFGEFFWGYMCAYJzAxG1T4F5M4EB3?=
 =?us-ascii?q?kOBZgEFBhQBgTiNXnSEfCcVBoFJRIEVgnMHb4EFAUyCOIZ+BIMuhFCBAGOKR?=
 =?us-ascii?q?EiBHgNZLAFVEw0KCwcFgWYDNRIqFW4yHYEjPheBDBsHBYFKgStqgQOFDSMfA?=
 =?us-ascii?q?zl/gXSBKGdpFTA1gQEBER0DCxgNSBEsFCMUGwQ+bgeMSBcPgj57CQsrIi4Gg?=
 =?us-ascii?q?Q4vAR6TKAcUki2BNZ9ahCeMIZU6GjOqbJkIjgqWAIU4gWg8gVkzGggbFTuCZ?=
 =?us-ascii?q?xNAGQ+OLQsLiHPCbScyAgE6AgcCBw4DC5FogX0BAQ?=
IronPort-Data: A9a23:A+FQ5Kwj3GbqUA0rYrd6t+exxyrEfRIJ4+MujC+fZmUNrF6WrkUHm
 mQaWWzVa6zfMTH0e4x0bY+zpkgCvMTSm95gTldl/lhgHilAwSbn6Xt1DatR0we6dJCroJdPt
 p1GAjX4BJlqCCea/VH1buSJQUBUjcmgXqD7BPPPJhd/TAplTDZJoR94kobVuKYw6TSCK13L4
 4+aT/H3Ygf/hWYqazhMscpvlTs21BjMkGJA1rABTagjUG/2zxE9EJ8ZLKetGHr0KqE8NvK6X
 evK0Iai9Wrf+Ro3Yvv9+losWhRXKlJ6FVHmZkt+A8BOsDAbzsAB+vpT2M4nVKtio27hc+adZ
 zl6ncfYpQ8BZsUgkQmGOvVSO3kW0aZuoNcrLZUj2CCe5xWuTpfi/xlhJGoLEJcm2L95PXhf8
 MADDy0naByyhP3jldpXSsE07igiBNPgMIVavjRryivUSK58B5vCWK7No9Rf2V/chOgXQq2YP
 JVfM2cyKk2bMnWjOX9PYH46tOShnGX+dzRbgFmUvqEwpWPUyWSd1ZCxYYGJJYHaFZo9ckCwn
 Gfs/03ZOzIjNPuF0TCIrECxgeXMgnauMG4VPPjinhJwu3WXxXQ7CRsKWF/9qv684ma+UshSA
 08Z4Cwjqe417kPDZtvwXReQpH+Cow5aWtBVVeY97Wmlz6PO/wefQHAJUjNbc9EgnMgsTDcu2
 xmCmNaBLTVjub6SUXWA3q2ZoTO7JW4eKmpqTS0BQA0I7NniiJs+ghLGUpBoF6vdpsf4Bzzq2
 BiQoSQ+jqlVhskOv42/8U3BiDuqjoPUVQNz7QLSNkqh7wVkdMumapau5Fzz8/lNNsCaQ0OHs
 XxCnNKRhMgKDJeQhGmWS/4MNK+m6uzDMzDGh1NrWZ47+FyQF2WLZ4tc5nR6YUxuKMtBIWWva
 07IsgQX75hWVJe3UZJKj0uKI5xC5cDd+R7NDJg4svImjkBNSTK6
IronPort-HdrOrdr: A9a23:yMCnKqtYAgVhk15BVuZvzqX47skDvNV00zEX/kB9WHVpmwKj+/
 xG+85rsSMc5wx+ZJhNo7q90ey7MBDhHP1OkOws1NWZPTUO0VHAROpfBMnZsl/d8kbFmdK1u5
 0MT4FOTPXtEFl3itv76gGkH9tl/MOK68mT9IDjJg9WLT1CWuVH8xpzDBqdHwldQQlLAod8Kb
 +nj/A3wQZJvR8sH7yG7r5vZZm7m+H2
X-Talos-CUID: 9a23:Ou1p42E+hyLOXL73qmJMyWMOJOJ8fEHE3XLsOGilI2Bleb6KHAo=
X-Talos-MUID: 9a23:NlcpoQa/N4xNguBTjTrGhBhCDeRR44O0EEoAz6cbvMOHKnkl
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,201,1774310400"; 
   d="scan'208";a="493475887"
Received: from rcdn-l-core-02.cisco.com ([173.37.255.139])
  by rcdn-iport-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2026 18:14:30 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.127.244])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-02.cisco.com (Postfix) with ESMTPSA id 9DD6118000350;
	Fri, 12 Jun 2026 18:14:28 +0000 (GMT)
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com,
	djhawar@cisco.com,
	gcboffa@cisco.com,
	mkai2@cisco.com,
	satishkh@cisco.com,
	aeasi@cisco.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jmeneghi@redhat.com,
	revers@redhat.com,
	adakopou@redhat.com,
	lduncan@suse.com,
	Karan Tilak Kumar <kartilak@cisco.com>,
	kernel test robot <lkp@intel.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH v4 09/13] scsi: fnic: Send NVMe LS requests through FDLS
Date: Fri, 12 Jun 2026 11:09:14 -0700
Message-ID: <20260612180918.8554-10-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260612180918.8554-1-kartilak@cisco.com>
References: <20260612180918.8554-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.127.244];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.127.244, [10.188.127.244]
X-Outbound-Node: rcdn-l-core-02.cisco.com

Add the FC frame wrapper for NVMe LS requests and build LS request
frames from the NVMe-FC transport callback.

Allocate OXIDs, track outstanding LS requests on the target port, arm
request timers, and register the LS request callback in the NVMe FC
port template.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202605280619.pmobiDWp-lkp@intel.com/
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Co-developed-by: Hannes Reinecke <hare@kernel.org>

---
Changes between v2 and v3:
Fix issues reported by kernel bot.
Guard tport logging when NVMe LS send has no tport.

Changes between v3 and v4:
Incorporate review comments from Sashiko:
	Arm NVMe LS request timer before exposing the request
---
 drivers/scsi/fnic/fdls_fc.h   |   8 +++
 drivers/scsi/fnic/fnic_nvme.c | 128 +++++++++++++++++++++++++++++++++-
 drivers/scsi/fnic/fnic_nvme.h |   3 +
 3 files changed, 138 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fdls_fc.h b/drivers/scsi/fnic/fdls_fc.h
index a7b8b969f019..257975c8473c 100644
--- a/drivers/scsi/fnic/fdls_fc.h
+++ b/drivers/scsi/fnic/fdls_fc.h
@@ -30,6 +30,9 @@
 #include <linux/if_ether.h>
 #include <scsi/fc/fc_encaps.h>
 #include <scsi/fc/fc_fcoe.h>
+#include <linux/nvme.h>
+#include <linux/nvme-fc.h>
+#include <linux/nvme-fc-driver.h>
 
 #define FDLS_MIN_FRAMES	(32)
 #define FDLS_MIN_FRAME_ELEM	(4)
@@ -251,6 +254,11 @@ struct fc_std_logo {
 	struct fc_els_logo els;
 } __packed;
 
+struct fc_std_ls_req {
+	struct fc_frame_header fchdr;
+	struct nvmefc_ls_req ls_req;
+};
+
 #define	FNIC_ETH_FCOE_HDRS_OFFSET	\
 	(sizeof(struct ethhdr) + sizeof(struct fcoe_hdr))
 
diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
index f81827f7811b..014660725373 100644
--- a/drivers/scsi/fnic/fnic_nvme.c
+++ b/drivers/scsi/fnic/fnic_nvme.c
@@ -1290,6 +1290,132 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
 	ls_req->done(ls_req, -ETIMEDOUT);
 }
 
+/**
+ * nvfnic_ls_req_send - Send NVMe FC link service (LS) request
+ * @lport:   Pointer to local NVMe FC port structure
+ * @rport:   Pointer to remote NVMe FC port structure
+ * @ls_req:  Pointer to the link service request structure
+ *
+ * This function is used to send link service (LS) commands to an NVMe
+ * Discovery Controller for discovery operations, as well as to regular
+ * NVMe subsystems during association. It encapsulates the logic for
+ * transmitting LS requests over the NVMe over Fabrics (NVMe-oF) FC
+ * transport.
+ *
+ * Returns: 0 on success, or a negative error code on failure.
+ */
+int nvfnic_ls_req_send(struct nvme_fc_local_port *lport,
+		  struct nvme_fc_remote_port *rport,
+		  struct nvmefc_ls_req *ls_req)
+{
+	int timeout;
+	uint8_t *frame;
+	uint8_t fcid[3];
+	unsigned long flags = 0;
+	struct fnic_iport_s *iport = lport->private;
+	struct nvmefc_ls_req *pls_req;
+	struct fnic *fnic = iport->fnic;
+	struct fc_std_ls_req *pfc_std_ls_req;
+	struct nvfnic_ls_req *nvfnic_ls_req = ls_req->private;
+	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET +
+			sizeof(struct fc_frame_header) + ls_req->rqstlen;
+	struct fnic_tport_s *tport;
+	int ret;
+
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+
+	tport = (struct fnic_tport_s *)rport->private;
+	INIT_LIST_HEAD(&nvfnic_ls_req->list);
+
+	if (!nvfnic_transport_ready(iport, tport)) {
+		if (tport != NULL)
+			FNIC_NVME_DBG(KERN_INFO, fnic,
+				      "iport: 0x%x tport: 0x%x transport not ready\n",
+				      iport->fcid, tport->fcid);
+		else
+			FNIC_NVME_DBG(KERN_INFO, fnic,
+				      "iport: 0x%x transport not ready\n",
+				      iport->fcid);
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		return -ENOLINK;
+	}
+
+	frame = fdls_alloc_frame(iport);
+	if (frame == NULL) {
+		FNIC_NVME_DBG(KERN_ERR, fnic,
+		     "Failed to allocate frame to send NVME LS REQ");
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		return -ENOMEM;
+	}
+
+	if (fdls_alloc_oxid(iport, FNIC_FRAME_TYPE_NVME_LS,
+			&nvfnic_ls_req->oxid) == FNIC_UNASSIGNED_OXID) {
+		FNIC_FCS_DBG(KERN_INFO, fnic,
+		     "0x%x: Failed to allocate OXID to send NVME LS REQ",
+			 iport->fcid);
+		mempool_free(frame, fnic->frame_pool);
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		return -EAGAIN;
+	}
+
+	timer_setup(&nvfnic_ls_req->ls_req_timer, nvfnic_ls_req_timeout,
+		     0UL);
+
+	nvfnic_ls_req->fnic = fnic;
+	nvfnic_ls_req->tport = tport;
+	nvfnic_ls_req->state = FNIC_LS_REQ_CMD_INIT;
+	nvfnic_ls_req->ls_req = ls_req;
+
+	pfc_std_ls_req = (struct fc_std_ls_req *) (frame +
+			FNIC_ETH_FCOE_HDRS_OFFSET);
+	*pfc_std_ls_req = (struct fc_std_ls_req) {
+		.fchdr = {.fh_r_ctl = FC_RCTL_ELS4_REQ,
+		      .fh_type = FC_TYPE_NVME,
+		      .fh_f_ctl = {FNIC_ELS_REQ_FCTL, 0, 0},
+		      .fh_rx_id = cpu_to_be16(FNIC_UNASSIGNED_RXID)}
+	};
+
+	hton24(fcid, iport->fcid);
+	FNIC_STD_SET_S_ID(pfc_std_ls_req->fchdr, fcid);
+
+	hton24(fcid, tport->fcid);
+	FNIC_STD_SET_D_ID(pfc_std_ls_req->fchdr, fcid);
+
+	FNIC_STD_SET_OX_ID(pfc_std_ls_req->fchdr, nvfnic_ls_req->oxid);
+
+	pls_req = (struct nvmefc_ls_req *) (frame + FNIC_ETH_FCOE_HDRS_OFFSET +
+					sizeof(struct fc_frame_header));
+	memcpy(pls_req, ls_req->rqstaddr, ls_req->rqstlen);
+
+	FNIC_NVME_DBG(KERN_INFO, fnic,
+		 "0x%x: NVME send ls req with oxid: 0x%x type: 0x%02x len: %d",
+		 iport->fcid, nvfnic_ls_req->oxid, *((uint8_t *) ls_req->rqstaddr),
+		 ls_req->rqstlen);
+
+	list_add_tail(&nvfnic_ls_req->list, &tport->ls_req_list);
+	nvfnic_ls_req->state = FNIC_LS_REQ_CMD_PENDING;
+	timeout = FNIC_LS_REQ_TMO_MSECS(ls_req->timeout);
+	mod_timer(&nvfnic_ls_req->ls_req_timer,
+		  round_jiffies(jiffies + msecs_to_jiffies(timeout)));
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+
+	ret = fnic_send_fcoe_frame(iport, frame, frame_size);
+	if (ret) {
+		timer_delete_sync(&nvfnic_ls_req->ls_req_timer);
+		spin_lock_irqsave(&fnic->fnic_lock, flags);
+		list_del(&nvfnic_ls_req->list);
+		fdls_free_oxid(iport, nvfnic_ls_req->oxid,
+			       &nvfnic_ls_req->oxid);
+		nvfnic_ls_req->state = FNIC_LS_REQ_CMD_COMPLETE;
+		ls_req->private = NULL;
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		mempool_free(frame, fnic->frame_pool);
+		return ret;
+	}
+
+	return 0;
+}
+
 void nvfnic_local_port_delete(struct nvme_fc_local_port *lport)
 {
 	struct fnic_iport_s *iport = (struct fnic_iport_s *) lport->private;
@@ -1590,7 +1716,7 @@ nvme_fc_port_template nvfnic_port = {
 	.remoteport_delete = nvfnic_remote_port_delete,
 	.create_queue = nvfnic_create_queue,
 	.delete_queue = NULL,
-	.ls_req = NULL,
+	.ls_req = nvfnic_ls_req_send,
 	.ls_abort = nvfnic_ls_req_abort,
 	.fcp_io = nvfnic_fcpio_send,
 	.fcp_abort = nvfnic_fcpio_abort,
diff --git a/drivers/scsi/fnic/fnic_nvme.h b/drivers/scsi/fnic/fnic_nvme.h
index ab96b8d13931..ebdaf6930f8e 100644
--- a/drivers/scsi/fnic/fnic_nvme.h
+++ b/drivers/scsi/fnic/fnic_nvme.h
@@ -111,6 +111,9 @@ void nvfnic_ls_req_abort(struct nvme_fc_local_port *lport,
 			 struct nvmefc_ls_req *lsreq);
 int nvfnic_create_queue(struct nvme_fc_local_port *lport, unsigned int idx,
 			u16 size, void **handle);
+int nvfnic_ls_req_send(struct nvme_fc_local_port *lport,
+		       struct nvme_fc_remote_port *rport,
+		       struct nvmefc_ls_req *ls_req);
 void nvfnic_ls_req_timeout(struct timer_list *t);
 uint16_t nvfnic_alloc_ls_req_oxid(struct fnic_iport_s *iport);
 struct nvfnic_ls_req *nvfnic_find_ls_req(struct fnic_tport_s *tport,
-- 
2.47.1

