Received: from alln-iport-8.cisco.com (alln-iport-8.cisco.com [173.37.142.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3F13590AE;
	Fri, 24 Jul 2026 17:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784915629; cv=none; b=k8bVLM3oCK8Pbfk5EwfhdEyZ6uY9aT9oglShVupMdJ1Kx3Dw2FHdoH5kn9Ej1rBs3lyMwAGgJ7sngVC6JvvGSZeEispHMqREIi+2pp9hiTwFvjOsrVO3mojzEBNI96g5hYLMUzROE5TECFcFp7VJE7IGrvofjidCEUTHpcs1q60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784915629; c=relaxed/simple;
	bh=m+s21O745ydLXEn32thJW2sSEWYl9ktSF2nciS4zVmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7GZLbC7SYusu7mClmfbws03yGcEqbUQWvKX/9uxtvbKq4ofUt39nyuL5InrdhlZXFpjAcarV6emmBSrxz9rv/AWkdFAAXpTJu+stp8adfw0cmfITUB1J5AtoW5V8Cr9mxAzZn/hdSU+MlvMjPg44gOyzxFuHTREHnJ0urnmUwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=PhiC0Vsw; arc=none smtp.client-ip=173.37.142.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="PhiC0Vsw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=7348; q=dns/txt;
  s=iport01; t=1784915624; x=1786125224;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A6U2899yBCArlVIN6HBj4GL8qOXlQvBgBWgutgy4Hq8=;
  b=PhiC0Vsw9rlPI6UtvhXYUmZfCtoPxMKAOyBN1Ge60dw8QloomYtrNWW7
   Sp0GuRUbbJQK+oBuabD8ZqXxplQ7YOhHJ/1kl1TeAzN7/EgrEYjtnb2oM
   fqig4yKQQHQ0p4IGQ1Vr29CgXYRgYYmL9MmOuxF/QunbcJ2WEvnoz5z+z
   VKPnIjiW9cJrA0lIXKL/UEftd3m1vR3QYCr9Ltt0ieUD8QFuyKe4sPZUd
   lxeJVZ8oRMI473oQpWRvltxPBI/R9OlgGNlt91UKAGbP0vafz4Dz/cWxT
   RQk8kOuMWU2wh1k1ICERuJHAvO+svVyxgg5yQ3TSMqG7wB4aHx8h+vWwY
   Q==;
X-CSE-ConnectionGUID: eO1hGwFEQD+YG4ZYiddljA==
X-CSE-MsgGUID: I5FsPeztQFK5WniPkAsanQ==
X-IPAS-Result: =?us-ascii?q?A0BFAgBZpmNq/5AQJK1aglmCV3ReQxkwBJQlgiGBFp0Ig?=
 =?us-ascii?q?X4PAQEBD0QNBAEBhQUCjWACJjQJDgECBAMCAwEBAQEBAQEBAQEBCwEBBQEBA?=
 =?us-ascii?q?QIBBwWBDhOGTw2GWwIBAycLAUYQUVYZgwIBgnQDEcIfgXkzgQHeRYFmAQUGF?=
 =?us-ascii?q?AGBOI1fdYR8JxUGgUlEgRWCcwdvgQUBTII4hn4Egy6CSIEcf2KMe0iBHgNZL?=
 =?us-ascii?q?AFVEw0KCwcFgWYDNRIqFW4yHYEjPheBDBsHBYEdgSx5hFgjHwM5f4EvdUp3L?=
 =?us-ascii?q?WkBEheBJoNLAoFPAwsYDUgRLBQjFBkEPm4HjXcjgkB7CQsrIi4GgQ4vAR6TC?=
 =?us-ascii?q?x0HFJItgTWfWoQnjCGVOhozqmyZCI4KlgCFOYFoPIFZMxoIGxU7gmcTQBkPj?=
 =?us-ascii?q?i0LC4hzyUcnMgIBOgEBBwIHDgMLgWiQAIF+AQE?=
IronPort-Data: A9a23:xFFgdaKw9wxAJr3cFE+RVpQlxSXFcZb7ZxGr2PjKsXjdYENS1DJTz
 2MaWW7QMv2IYGHwfNElYNng8x9T6pXVz9RrSlYd+CA2RRqmiyZq6fd1j6vUF3nPRiEWZBs/t
 63yUvGZcoZsCCSa/kvxWlTYhSEU/bmSQbbhA/LzNCl0RAt1IA8skhsLd9QR2uaEuvDnRVnQ0
 T/Oi5eHYgH9hGQoazt8B5+r8XuDgtyj4Fv0gXRmDRx7lAe2v2UYCpsZOZawIxPQKqFIHvS3T
 vr017qw+GXU5X8FUrtJRZ6iLyXm6paLVeS/oiI+t5qK23CulQRuukoPD8fwXG8M49m/c3+d/
 /0W3XC4YV9B0qQhA43xWTEAe811FfUuFLMqvRFTvOTLp3AqfUcAzN1jKxg2EpI2199bQlBhq
 c4pKTwBahKq0rfeLLKTEoGAh+wqKM3teYdasXZ6wHSBUrAtQIvIROPB4towMDUY358VW62AI
 ZNHL2MzMHwsYDUXUrsTIJE3hvupgnD8WzZZs1mS46Ew5gA/ySQugOi0bIOPK4biqcN9vxu2v
 VrL7XjALDJHC9qe8Tms6Xuqv7qa9c/8cMdIfFGizdZug0W7x2oPBRlQXly+ydG5g1Szc9FSM
 UoZ/mwpt6da3E6mTNPVWxy+vW7CvxQZHdFXFoUS7QiX1qvSpR6UGmUeVTNHQNs8vcQySHoh0
 Vrht9rlDD9oqLqIYWiQ+redsXW5Pi19BW0HaCkJQgsEy8PurIE6klTESdMLOLS4kNDvAhnqz
 jyKpTR4jLIW5eYP27i99lnBqymxvZWPRQkwji3TX2S4/kZ6aZSjaoiA91fW97BDIZyfQ13Hu
 2IL8+Ca7eYTHdSWnzeMaPsCEavv5PufNjDYx1l1EPEcGy+F8nqne8VUpTp5PkosaplCcj7ya
 0iVsgRUjHNOAEaXgWZMS9rZI6wXIWLITLwJiti8ggJyX6VM
IronPort-HdrOrdr: A9a23:5/t7uqrPJBjARWRBz7bElloaV5rheYIsimQD101hICG9vPb1qy
 nIpoV+6faaslgssR0b8+xofZPwIk80lqQFhLX5X43CYOCOggLBR72Kr7GSoQEIcBeQygcy78
 pdWpk7IMHsDFR8kMbx6BS1HpId2tWdmZrY4ts2t00McShaL4d98gx+FgGXVmdyRAVAGN4FMa
 D03Lsgm9JlEk5nFvhSwRI+LpH+m+E=
X-Talos-CUID: 9a23:FJXXHm1gswr7mS5OJfWvSrxfF+d8clLC4lrpDwyJJjpbebyZRVuS0fYx
X-Talos-MUID: =?us-ascii?q?9a23=3AXfrQWQ8RH5Lh0EPQK948eA2Qf+Y1zb+WBVIRqLs?=
 =?us-ascii?q?l5vaCNBRzEiyUig3iFw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.25,183,1779148800"; 
   d="scan'208";a="788141292"
Received: from alln-l-core-07.cisco.com ([173.36.16.144])
  by alln-iport-8.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Jul 2026 17:53:37 +0000
Received: from fedora.cisco.com (unknown [10.189.189.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-07.cisco.com (Postfix) with ESMTPSA id E2834180001C6;
	Fri, 24 Jul 2026 17:53:29 +0000 (GMT)
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
Subject: [PATCH v6 09/13] scsi: fnic: Send NVMe LS requests through FDLS
Date: Fri, 24 Jul 2026 10:48:07 -0700
Message-ID: <20260724174811.5118-10-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260724174811.5118-1-kartilak@cisco.com>
References: <20260724174811.5118-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.189.189.81];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.189.189.81, [10.189.189.81]
X-Outbound-Node: alln-l-core-07.cisco.com

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

Changes between v4 and v5:
Incorporate review comments from Sashiko:
	Avoid NVMe LS request send races
---
 drivers/scsi/fnic/fdls_fc.h   |   3 +
 drivers/scsi/fnic/fnic_nvme.c | 125 +++++++++++++++++++++++++++++++++-
 drivers/scsi/fnic/fnic_nvme.h |   3 +
 3 files changed, 130 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fdls_fc.h b/drivers/scsi/fnic/fdls_fc.h
index a7b8b969f019..cdf84462dd37 100644
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
diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
index 697a4fdfd576..0b05dc9698be 100644
--- a/drivers/scsi/fnic/fnic_nvme.c
+++ b/drivers/scsi/fnic/fnic_nvme.c
@@ -1337,6 +1337,129 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
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
+	uint8_t *ls_req_payload;
+	struct fnic *fnic = iport->fnic;
+	struct fc_frame_header *fchdr;
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
+	fchdr = (struct fc_frame_header *)(frame + FNIC_ETH_FCOE_HDRS_OFFSET);
+	*fchdr = (struct fc_frame_header) {
+		.fh_r_ctl = FC_RCTL_ELS4_REQ,
+		.fh_type = FC_TYPE_NVME,
+		.fh_f_ctl = {FNIC_ELS_REQ_FCTL, 0, 0},
+		.fh_rx_id = cpu_to_be16(FNIC_UNASSIGNED_RXID)
+	};
+
+	hton24(fcid, iport->fcid);
+	FNIC_STD_SET_S_ID(*fchdr, fcid);
+
+	hton24(fcid, tport->fcid);
+	FNIC_STD_SET_D_ID(*fchdr, fcid);
+
+	FNIC_STD_SET_OX_ID(*fchdr, nvfnic_ls_req->oxid);
+
+	ls_req_payload = frame + FNIC_ETH_FCOE_HDRS_OFFSET + sizeof(*fchdr);
+	memcpy(ls_req_payload, ls_req->rqstaddr, ls_req->rqstlen);
+
+	FNIC_NVME_DBG(KERN_INFO, fnic,
+		 "0x%x: NVME send ls req with oxid: 0x%x type: 0x%02x len: %d",
+		 iport->fcid, nvfnic_ls_req->oxid, *((uint8_t *) ls_req->rqstaddr),
+		 ls_req->rqstlen);
+
+	list_add_tail(&nvfnic_ls_req->list, &tport->ls_req_list);
+	nvfnic_ls_req->state = FNIC_LS_REQ_CMD_PENDING;
+
+	ret = fnic_send_fcoe_frame(iport, frame, frame_size);
+	if (ret) {
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
+	timeout = FNIC_LS_REQ_TMO_MSECS(ls_req->timeout);
+	mod_timer(&nvfnic_ls_req->ls_req_timer,
+		  round_jiffies(jiffies + msecs_to_jiffies(timeout)));
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+
+	return 0;
+}
+
 void nvfnic_local_port_delete(struct nvme_fc_local_port *lport)
 {
 	struct fnic_iport_s *iport = (struct fnic_iport_s *) lport->private;
@@ -1662,7 +1785,7 @@ nvme_fc_port_template nvfnic_port = {
 	.remoteport_delete = nvfnic_remote_port_delete,
 	.create_queue = nvfnic_create_queue,
 	.delete_queue = NULL,
-	.ls_req = NULL,
+	.ls_req = nvfnic_ls_req_send,
 	.ls_abort = nvfnic_ls_req_abort,
 	.fcp_io = nvfnic_fcpio_send,
 	.fcp_abort = nvfnic_fcpio_abort,
diff --git a/drivers/scsi/fnic/fnic_nvme.h b/drivers/scsi/fnic/fnic_nvme.h
index 7cdb58985669..7d95d0e5aa28 100644
--- a/drivers/scsi/fnic/fnic_nvme.h
+++ b/drivers/scsi/fnic/fnic_nvme.h
@@ -112,6 +112,9 @@ void nvfnic_ls_req_abort(struct nvme_fc_local_port *lport,
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

