Received: from rcdn-iport-1.cisco.com (rcdn-iport-1.cisco.com [173.37.86.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AFF31717C;
	Wed, 24 Jun 2026 04:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782276533; cv=none; b=UtuAQj15SQ9+ELxUb66Q6zg7jTdQfsrrvWB+4CqhnJ/89iIv12Vn2cO8tOiQeQuYYK5lFXU/rs0TWvnGt6oNfHu0xmnSVbCD5awSC98djj9C8sokjc7QpYV+Oj58YONQF0iCeMVpEqDBSbHd0CE5pBYz0Qse+H6ZElHdtYuOFFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782276533; c=relaxed/simple;
	bh=3NsBMHav8rNSoa9a5wB8Ca2LKLZrA1zW37put32JWRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnUn9H3B7SB3d5KWxPnn8b7MkxBfvxOm6ojpnJ9YKluskN7Gm9zJHn3oFbUHnZpoZe6KViRX9A8P8xgOyZtYXwRJtKH+y0jNG/wbkBofZb1l1LnFYewe7tbvBZ6HwfKMf4XvI23YYOySppWWScXzI92malORKH/UldRhwqYApFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=ARmAdD/L; arc=none smtp.client-ip=173.37.86.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="ARmAdD/L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=7348; q=dns/txt;
  s=iport01; t=1782276531; x=1783486131;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MnFEjhS5SlhLPNH1urV31UaZPaQ/2qYaniLvcefiL3k=;
  b=ARmAdD/LxnaDZ4+cYzN2e8ejrsgO6rDJwOZp7JM02SEvLCtbO+wYixMu
   uE+SdgW7sVcGNm4HCFvcw0VXfM3V14U5sIwC/mw28Jrh8EqP0zHLCQZZ4
   jHlUx9tK8KmD56AvevJ1WKQ7GtFH+yPhxHHCXROaKjNetjZMgayuvwh3P
   LkYp8iz89e9DDN5o0U4OBq7ZkkaIo4LQshUQtlIDNrij4HmqNC8KZ5v1j
   OhfimQGZqcrs2xdDKXKJMmzEw0iMMkKLzRKS/n0LC903hcG/tNt+NAvhP
   kqzT6C/WQbBJlsD4gRPyW+d2GFO++AUKSjUDQrIF48j+/OC2w54aHmQZc
   w==;
X-CSE-ConnectionGUID: swy8AmsxTZy0yDnqnr6aXQ==
X-CSE-MsgGUID: 3hVcNh/dS2aY0Ve1JStHfg==
X-IPAS-Result: =?us-ascii?q?A0BEAgB4YDtq/4//Ja1aHgEBCxIMggULgld0XkMZMASUJ?=
 =?us-ascii?q?oIhgRadCIF+DwEBAQ9EDQQBAYUGAo1KAiY0CQ4BAgQDAgMBAQEBAQEBAQEBA?=
 =?us-ascii?q?QsBAQUBAQECAQcFgQ4Thk8NhlsCAQMnCwFGEFFWGYMCAYJzAxGyJIF5M4EB3?=
 =?us-ascii?q?kOBZgEFBhQBgTiNXnSEfCcVBoFJRIEVgnMHb4EFAUyCOIZ+BIMugkiBVH9ji?=
 =?us-ascii?q?wRIgR4DWSwBVRMNCgsHBYFmAzUSKhVuMh2BIz4XgQwbBwWBHYFugQSFAiMfA?=
 =?us-ascii?q?zl/gT+BJGRmFTA1gQEBER8KgTUDCxgNSBEsFCMUGwQ+bgeMXRcPgj17CQsrI?=
 =?us-ascii?q?i4GgQ4vAR6TCx0HFJItgTWfWoQnjCGVOhozqmyZCI4KlgCFOIFoPIFZMxoIG?=
 =?us-ascii?q?xU7gmcTQBkPji0LC4hzyUcnMgIBOgIHAgcOAwuRaIF9AQE?=
IronPort-Data: A9a23:H2CqrKIZRiFXXbcLFE+RV5QlxSXFcZb7ZxGr2PjKsXjdYENShGQFx
 2tKDD/TO/uMZzb3LYhza4zn9UNQvZLRn4A1Hgsd+CA2RRqmiyZq6fd1j6vUF3nPRiEWZBs/t
 63yUvGZcoZsCCSa/kvxWlTYhSEU/bmSQbbhA/LzNCl0RAt1IA8skhsLd9QR2uaEuvDnRVnR0
 T/Oi5eHYgH9hWQvajh8B5+r8XuDgtyj4Fv0gXRmDRx7lAe2v2UYCpsZOZawIxPQKqFIHvS3T
 vr017qw+GXU5X8FUrtJRZ6iLyXm6paLVeS/oiI+t5qK23CulQRuukoPD8fwXG8M49m/c3+d/
 /0W3XC4YV9B0qQhA43xWTEAe811FfUuFLMqvRFTvOTLp3AqfUcAzN11E1BmFIgD6tpFEDlf2
 foBLipTZyC60rfeLLKTEoGAh+w5J8XteYdasXZ6wHSBU7AtQIvIROPB4towMDUY358VW62BI
 ZBENHw2ME+ojx5nYj/7DLo9lf20h332cBVTqUmeouw85G27IAlZjOm9YYKPK4zULSlTth2Ym
 Gng/yP1OUsTBYShxGOnyW6MiOCayEsXX6pXTtVU7MVChF6L7m0VFBASE1C8pJGRikekVvpcJ
 lYS9y5oqrI9nGSpQ9v3dxm5pmOU+B8WXpxbFOhSwASE0LbV5UCBC3QJVCVMbvQhrsY9QTFs3
 ViM9/vgCTVst6WSVFqH+7uUpC/0Mi8QRUcAYCICQAQF4vH5rY0zhw6JRdFmeIavg8P4AyrY2
 T2GrCEiwb4UiKYj06mm+1vOhRq3u4PECAUy423/WmOj8xM8Z4O/YYGswUbU4OwGL4uDSFSF+
 n8elKC26OEIEIHIjyeWQc0TE7yzofWIKjvRhRhoBZZJyti202SocYYV5HR1I11kd55aPzToe
 0TU/whW4fe/IUeXUEO+WKrpY+xC8EQqPY6Nuiz8BjaWXqVMSQ==
IronPort-HdrOrdr: A9a23:rs9ROqkBpeDgxx0bbZMyHlwy7FnpDfLm3DAbv31ZSRFFG/FwWf
 rDoB19726RtN9/Yh8dcLy7UpVoBEmslqKdgrNhWItKPjOGhILAFugLhrcKgQeQeREWndQz6U
 4PScVDIey1JURmjMr8/QmzG8stzZ266qyy7N2uqEuFNTsLV4hQqyFkFw2cDkp6ACNCBZY/Cd
 6gw/AvnUvHRZzSBf7LfkXsmIP41qT2qK4=
X-Talos-CUID: =?us-ascii?q?9a23=3ANPCrA2njdPm2ylNOd2Bk02+xgIvXOWbC3Sf5JlS?=
 =?us-ascii?q?oNVR4EKy5T0aW4v1to/M7zg=3D=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3A8VQIXg8ScydvyJMf5yB4abKQf5xo3a+ICAcBqs8?=
 =?us-ascii?q?PipG6OHVSACu9gjviFw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,221,1774310400"; 
   d="scan'208";a="498902986"
Received: from rcdn-l-core-06.cisco.com ([173.37.255.143])
  by rcdn-iport-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Jun 2026 04:48:50 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.122.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-06.cisco.com (Postfix) with ESMTPSA id 0F28D180003A2;
	Wed, 24 Jun 2026 04:48:48 +0000 (GMT)
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
Subject: [PATCH v5 09/13] scsi: fnic: Send NVMe LS requests through FDLS
Date: Tue, 23 Jun 2026 21:43:30 -0700
Message-ID: <20260624044334.3079-10-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260624044334.3079-1-kartilak@cisco.com>
References: <20260624044334.3079-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.122.232];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.122.232, [10.188.122.232]
X-Outbound-Node: rcdn-l-core-06.cisco.com

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
index 8374464e4fcc..16e2f0add5ce 100644
--- a/drivers/scsi/fnic/fnic_nvme.c
+++ b/drivers/scsi/fnic/fnic_nvme.c
@@ -1306,6 +1306,129 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
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
@@ -1606,7 +1729,7 @@ nvme_fc_port_template nvfnic_port = {
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

