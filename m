Received: from rcdn-iport-8.cisco.com (rcdn-iport-8.cisco.com [173.37.86.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BA63B19AE;
	Wed, 27 May 2026 19:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779911749; cv=none; b=oUQ02VUkznYghBE5m4ETpjd1+N6e8l2c39WyVcqjmYOtGBINSm+H8Rvm47/IMv2NgB08bNetqHwN9ae7nwY5Ve1sW4yd3//WwYiOAQSnDw056VS3iGIeSyJG5ughhsub7vbRWvepvF02NFp9uGXr6Nt1LOZgvQ7M56DjQpkkKzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779911749; c=relaxed/simple;
	bh=QP6qBwD43v++vApS6CgMTnRNSSmobqzsIyDQwOLfGPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=doZfayyBjrRHrj5/adRrruiItMEMlBLW6542YF1jrYu6qnkrdUEtEfflYQems5t8lMHdxNEdsQR5ol/hXgyYhdD/hx5aX5QOh3LyOR5wj78SWu2aUpvraxnK4P7vxglJo8ay1DO2LAyb6CbA0Kq3ZOOu02bp+M/5R8s+voB6xa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=TC3DA19s; arc=none smtp.client-ip=173.37.86.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="TC3DA19s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=6804; q=dns/txt;
  s=iport01; t=1779911747; x=1781121347;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nf4RWmU5M7DknEgc1svJ/SUaZfmsSHIUZL8RrPSHI+0=;
  b=TC3DA19s50V2reTsXucZ0DdkAZ4Ed11e97XHtK4ZJPyjvTJsoRSnug4J
   NEMvWiqsB98tMPzOGnUjgfMCedSq7wo+n3EeU4aEhInE2GDhZvVnsmVEU
   lnNB9XiiW54WnDiGTuptuIoF2VEqp2Fy76WhmUN1WviC/DqEMFyx1cD9u
   crP9wz1SYiwV4oeuyGBWTJEzigtdVaad8KHuT7HlX0Yh3wdbfB7fg+9WL
   oRZi3YtK2YT3fsL4iwdxt44HXAoydOKrWHrIeazZVEel7BOK7YhZOIycZ
   H9kkbZbwk0vfMQ3Pp9fxGl5WiPlD6P1KzYJhqH8zg3X0ATfmOtmk3t/AY
   w==;
X-CSE-ConnectionGUID: VeSPBYANQaWCpsosQBytzQ==
X-CSE-MsgGUID: X0cpVdVdQsWWLyg6M8LUGg==
X-IPAS-Result: =?us-ascii?q?A0AmAABASxdq/5P/Ja1aHQEBAQEJARIBBQUBgXwIAQsBg?=
 =?us-ascii?q?laBUEMZMIxzhzeCIYEWnQiBfg8BAQEPUQQBAYUGAo0yAiY0CQ4BAgQDAgMBA?=
 =?us-ascii?q?QEBAQEBAQEBAQsBAQUBAQECAQcFgQ4ThlyGWwIBAycLAUYQUVYZgwKCdAO0U?=
 =?us-ascii?q?oF5M4EB3kGBZAELFAGBOAGNW3SEeycVBoFJRIEVgnIHb4EFAUyCOIZ9BIMuh?=
 =?us-ascii?q?RGBAGOIHUiBHgNZLAFVEw0KCwcFgWYDNRIqFW4yHYEjPheBCxsHBYFLdnJqg?=
 =?us-ascii?q?QWFGCMmA06BLYF/XQMLGA1IESwUIxQbBD5uB4p1Gg+CMXsJC3uBFDAekygHF?=
 =?us-ascii?q?JItgTWfWYQmoVsaM6prmQakCIU4gWg8gVkzGggbFTuCZ1MZD44tCwvOYCcyP?=
 =?us-ascii?q?QIHAgcOAwuRaIF9AQE?=
IronPort-Data: A9a23:q3lCEqjTp+j5xFfSrCjIFXy/X161kREKZh0ujC45NGQN5FlHY01je
 htvCGCBbvyOZ2GhLdskYITk8koO7J7SndBqTwpr/Cw9E39jpJueD7x1DKtf0wB+jyHnZBg6h
 ynLQoCYdKjYdleF+FH1dOOn9SUgvU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYcAbeKRW2thg
 vus5ZeDULOZ82QsaDxMtvjc8EkHUMna4Vv0gHRvPZing3eG/5UlJMp3Db28KXL+Xr5VEoaSL
 87fzKu093/u5BwkDNWoiN7TKiXmlZaLYGBiIlIPM0STqkAqSh4ai87XB9JAAatjsAhlqvgqo
 Dl7WTNcfi9yVkHEsLx1vxC1iEiSN4UekFPMCSDXXcB+UyQqflO0q8iCAn3aMqUm991PK1Bn0
 8URFxsVdReYvsin3KCCH7wEasQLdKEHPasFsX1miDWcBvE8TNWaG+PB5MRT23E7gcUm8fT2P
 pVCL2EwKk6dPlsWZgh/5JEWxI9EglH8eidEqVacpoI84nPYy0p6172F3N/9JoPaHZoOwhjJz
 o7A11ShCQkkOOKT8CG6zVa9ibHqzQfGd41HQdVU8dYv2jV/3Fc7CBQMWHO4rOO/h0r4XMhQQ
 2QW9ygkhawz8lG7CNj3Wluzp3vslhsVQcZRFasi5R2A0LHZ5S6eHGEPSjMHY9sj3Oc/STUp0
 UeOgvvzCDBvuaHTQnWYnp+WqD60NCcVLEcYaCMERBdD6N7myKkpgwzCVM1LCqO5jtTpXzr3x
 liiqCQjgb4ai+YQyr62u1vAhlqEopnPUx5w5QjNWG+hxh12aZTjZIGy71Xfq/FaI+6xSliHo
 WhBgMOF7cgQApyX0i+AWuMAGPeu/fntDdHHqURkE59k83Gm/GSuONkIpjp/P0xudM0DfFcFf
 XPuhO+Y37cLVFPCUEO9S9vZ5xgCpUQ4KenYaw==
IronPort-HdrOrdr: A9a23:BS2PuKCAL+HaKPzlHelm55DYdb4zR+YMi2TDGXocdfUzSL39qy
 nAppomPHPP4gr5HUtQ+uxoW5PwJE80l6QV3WB5B97LNzUO+lHYTr2KhrGM/9SPIUDD398Y/b
 t8cqR4Fd37BUV3gILH+gWieuxQp+VviJrJuc7ui1FwUAptd6Zsqy19CgqdDwlKYTMuP+teKH
 JZjfA33wZJvh8sH72GOkU=
X-Talos-CUID: =?us-ascii?q?9a23=3AfEDRDmtkeW23v4SeP+BbLxuJ6Isbf0bl5kb5BXa?=
 =?us-ascii?q?xNk1xU7qOcHWB5LFdxp8=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3A1dluTwzb9BZXeym450/6DvLNYReaqJT2A1gznas?=
 =?us-ascii?q?KgtK7CghhNGm43BCKbYByfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,172,1774310400"; 
   d="scan'208";a="478073469"
Received: from rcdn-l-core-10.cisco.com ([173.37.255.147])
  by rcdn-iport-8.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 27 May 2026 19:55:40 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.14.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-10.cisco.com (Postfix) with ESMTPSA id 0D4261800024C;
	Wed, 27 May 2026 19:55:38 +0000 (GMT)
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
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH v2 09/13] scsi: fnic: Send NVMe LS requests through FDLS
Date: Wed, 27 May 2026 12:49:56 -0700
Message-ID: <20260527195000.8444-10-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260527195000.8444-1-kartilak@cisco.com>
References: <20260527195000.8444-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.14.55];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.14.55, [10.188.14.55]
X-Outbound-Node: rcdn-l-core-10.cisco.com

Add the FC frame wrapper for NVMe LS requests and build LS request frames
from the NVMe-FC transport callback.

Allocate OXIDs, track outstanding LS requests on the target port, arm
request timers, and register the LS request callback in the NVMe FC port
template.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Co-developed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/fnic/fdls_fc.h   |   8 +++
 drivers/scsi/fnic/fnic_nvme.c | 110 +++++++++++++++++++++++++++++++++-
 drivers/scsi/fnic/fnic_nvme.h |   3 +
 3 files changed, 120 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fdls_fc.h b/drivers/scsi/fnic/fdls_fc.h
index a7b8b969f019..381b87d549dd 100644
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
+} __packed;
+
 #define	FNIC_ETH_FCOE_HDRS_OFFSET	\
 	(sizeof(struct ethhdr) + sizeof(struct fcoe_hdr))
 
diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
index 26d4cbb06f50..83a43df28956 100644
--- a/drivers/scsi/fnic/fnic_nvme.c
+++ b/drivers/scsi/fnic/fnic_nvme.c
@@ -1244,6 +1244,114 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
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
+
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+
+	tport = (struct fnic_tport_s *)rport->private;
+	INIT_LIST_HEAD(&nvfnic_ls_req->list);
+
+	if (!nvfnic_transport_ready(iport, tport)) {
+		FNIC_NVME_DBG(KERN_INFO, fnic,
+			      "iport: 0x%x tport: 0x%x transport not ready\n",
+			      iport->fcid, tport->fcid);
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
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+
+	fnic_send_fcoe_frame(iport, frame, frame_size);
+	timeout = FNIC_LS_REQ_TMO_MSECS(ls_req->timeout);
+	mod_timer(&nvfnic_ls_req->ls_req_timer,
+			  round_jiffies(jiffies + msecs_to_jiffies(timeout)));
+
+	return 0;
+}
+
 void nvfnic_local_port_delete(struct nvme_fc_local_port *lport)
 {
 	struct fnic_iport_s *iport = (struct fnic_iport_s *) lport->private;
@@ -1544,7 +1652,7 @@ nvme_fc_port_template nvfnic_port = {
 	.remoteport_delete = nvfnic_remote_port_delete,
 	.create_queue = nvfnic_create_queue,
 	.delete_queue = NULL,
-	.ls_req = NULL,
+	.ls_req = nvfnic_ls_req_send,
 	.ls_abort = nvfnic_ls_req_abort,
 	.fcp_io = nvfnic_fcpio_send,
 	.fcp_abort = nvfnic_fcpio_abort,
diff --git a/drivers/scsi/fnic/fnic_nvme.h b/drivers/scsi/fnic/fnic_nvme.h
index 22d69f40cd65..8cf9beb8c997 100644
--- a/drivers/scsi/fnic/fnic_nvme.h
+++ b/drivers/scsi/fnic/fnic_nvme.h
@@ -109,6 +109,9 @@ void nvfnic_ls_req_abort(struct nvme_fc_local_port *lport,
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

