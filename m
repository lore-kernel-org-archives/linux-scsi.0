Received: from rcdn-iport-2.cisco.com (rcdn-iport-2.cisco.com [173.37.86.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E235D1CEADB;
	Thu, 21 May 2026 18:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779387042; cv=none; b=f5i9EFAm2MnkDTPio8j6PGn9/64CIexz+W0Ojt2iCLB2xDZ8IkcubRgbTHac0HR7N/vMN8w4YhH1qtCy9QKcSzu7oNT9Bim/yx5hVO0M1EiqV4Z1xvxhbU5S+VNtz+71QHMgyWqfmAZOVGnREAAEV+WDJw0ixZhtK+e8r2fWop0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779387042; c=relaxed/simple;
	bh=QP6qBwD43v++vApS6CgMTnRNSSmobqzsIyDQwOLfGPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHVO2LnDsO4g9FBIjB/08mNwN6M5/aeE9VGtZvb+XGPkjigcd0rUe5KbzOUCOm6kktiyWR0cA2dfIO/PG0zZEqSnUQBY3i2sIAxn8LCLJilo8aCj4Feo18H00xlsCFLSVmO3nTtCc+l+EkmkaYs4GEV6jgiV0XNEuVdCsUqXJdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=hZFRhixo; arc=none smtp.client-ip=173.37.86.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="hZFRhixo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=6804; q=dns/txt;
  s=iport01; t=1779387041; x=1780596641;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nf4RWmU5M7DknEgc1svJ/SUaZfmsSHIUZL8RrPSHI+0=;
  b=hZFRhixoN4cH7i10p6XjAMwetB6lvY8ZbLyg5ghR9C03hIeAPV+M4Wpy
   +LVKK19JKsppZJVsot4TidAFZkq/+7zJ5bA/plgV336IQ2tMtqekxij5E
   50L9XKWUaFpKbncN2LRSkKnUu35/2nQSjbxy5uvzyX7f0m7YvhswLKV6V
   bZO0RXtpNWoyxDgJordrTyZ/u+eQkK75BGdk7jU8Yxodtk3XYXbVZfUFs
   K/jB6lU2uSnyfRtRHdf33BYIQkHRJYsaOhVPGVND/uA39JmcYGHeGzduD
   vkin6L+I1gL9k4QMxceHSuXGVdqseRETKmunnlD/NURGETrziZPssVQGS
   g==;
X-CSE-ConnectionGUID: peDARdPDTj6xUaQKvn58sA==
X-CSE-MsgGUID: 0R9LN/jLQ1KiGuNTTyemeA==
X-IPAS-Result: =?us-ascii?q?A0AmAABKSQ9q/5L/Ja1aHQEBAQEJARIBBQUBgXwIAQsBg?=
 =?us-ascii?q?laBUEMZMIxzhzeCIYEWnQiBfw8BAQEPUQQBAYUGAo0yAiY0CQ4BAgQDAgMBA?=
 =?us-ascii?q?QEBAQEBAQEBAQsBAQUBAQECAQcFgQ4ThlyGWwIBAycLAUYQUVYZgwKCdAO0G?=
 =?us-ascii?q?oF5M4EB3kGBZAELFAGBOAGNW3SEeycVBoFJRIEVgnIHb4EFAUyCOIZ9BIMuh?=
 =?us-ascii?q?TaBAGSIAkiBHgNZLAFVEw0KCwcFgWYDNRIqFW4yHYEjPheBCxsHBYFLgTdya?=
 =?us-ascii?q?oEEhFd4IywDToEtgWsDCxgNSBEsFCMUGwQ+bgeKeRwPgjF7CQt7gRQwHpMoB?=
 =?us-ascii?q?xSSLYE1n1mEJqFYGjOqapkFpAiFOIFoPIFZMxoIGxU7gmdTGQ+OLQsLyx4nM?=
 =?us-ascii?q?j0CBwIHDgMLkWiBfQEB?=
IronPort-Data: A9a23:lRXr96gH/5avNMSzrxZcr35YX1616xEKZh0ujC45NGQN5FlHY01je
 htvWjrUPazZMWKhLY1xYI6/pB4FsZLcmtI2HgJvqik2FChjpJueD7x1DKtf0wB+jyHnZBg6h
 ynLQoCYdKjYdleF+FH1dOOn9SUgvU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYcAbeKRW2thg
 vus5ZeDULOZ82QsaDxMtvja8E8HUMna4Vv0gHRvPZing3eG/5UlJMp3Db28KXL+Xr5VEoaSL
 87fzKu093/u5BwkDNWoiN7TKiXmlZaLYGBiIlIPM0STqkAqSh4ai87XB9JAAatjsAhlqvgqo
 Dl7WTNcfi9yVkHEsLx1vxC1iEiSN4UekFPMCSDXXcB+UyQqflO0q8iCAn3aMqUA98peO2122
 cAadiAwZymgmeTrkKmSH7wEasQLdKEHPasFsX1miDWcBvE8TNWbEuPB5MRT23E7gcUm8fT2P
 pVCL2EwKk6dPlsWZgl/5JEWxI9EglH8eidEqVacpoI84nPYy0p6172F3N/9JoPSH58MwBjEz
 o7A1zzDUzU8c9678GOm812xoNPzjC7+VatHQdVU8dYv2jV/3Fc7CBQMWHO4rOO/h0r4XMhQQ
 2QY8yxopqEo7EGtUtTndxm5pneeuVgbQdU4O+836gulzqvS/hbfB2IBCDVGbbQOscYsWT0sk
 EeEg97zHjFpmLqPQHmZ+/GfqjbaESEZJGwFfSgZZREI79nqvMc4iRenZtRmHai4gd30MSv9z
 zCDsG41gLB7pdQGyaih5njdjj6sr4SPRQkwji3TUn+j5Qp/TJW4fIHu4l/ehd5ELYCEXhyCs
 WIClsy28u8DF9eOmTaLTeFLG6umj96BMTvBkRt0FIIg3yqi9mTlfo1K5jx6YkBzPa45lSTBe
 kTfv0ZVoZRUJnbvNf4xaIOqAMNsxq/lfTj4as3pghN1SsAZXGe6EOtGPCZ8A0iFfJAQrJwC
IronPort-HdrOrdr: A9a23:hhRcVKATnmEyZoXlHelm55DYdb4zR+YMi2TDGXocdfUzSL39qy
 nAppomPHPP4gr5HUtQ+uxoW5PwJE80l6QV3WB5B97LNzUO+lHYTr2KhrGM/9SPIUDD398Y/b
 t8cqR4Fd37BUV3gILH+gWieuxQp+VviJrJuc7ui1FwUAptd6Zsqy19CgqdDwlKYTMuP+teKH
 JZjfA33wZJvh8sH72GOkU=
X-Talos-CUID: 9a23:IXLL4GOiz9uoyu5DQCRL3XQYIuwZcCPN8X7pAFG+VDZyYejA
X-Talos-MUID: =?us-ascii?q?9a23=3Ayga4rA4685E5/DXGC5d4DIk9xoww2fWKLgcPtax?=
 =?us-ascii?q?fmMirKApMByaQiTmeF9o=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,160,1774310400"; 
   d="scan'208";a="470221664"
Received: from rcdn-l-core-09.cisco.com ([173.37.255.146])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 21 May 2026 18:10:40 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.18.181])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-09.cisco.com (Postfix) with ESMTPSA id 6EF2818000236;
	Thu, 21 May 2026 18:10:38 +0000 (GMT)
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
	dan.carpenter@linaro.org,
	adakopou@redhat.com,
	lduncan@suse.com,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 09/13] scsi: fnic: Send NVMe LS requests through FDLS
Date: Thu, 21 May 2026 11:04:54 -0700
Message-ID: <20260521180458.5448-10-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260521180458.5448-1-kartilak@cisco.com>
References: <20260521180458.5448-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.18.181];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.18.181, [10.188.18.181]
X-Outbound-Node: rcdn-l-core-09.cisco.com

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

