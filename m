Received: from rcdn-iport-1.cisco.com (rcdn-iport-1.cisco.com [173.37.86.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66508320CD9;
	Fri,  5 Jun 2026 23:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780703425; cv=none; b=HOIKCkV1vXza6fR7NTtzabLk/qys+DahEKRq6xCV5Oz/77QNLI3QwdVcptSg74HES/HjvUzTw35jHOjEhZlFrm/QOuSDij676XS7vruUrQDuLcKHRyO7Y5mA8akZ5w5Zugc8DWGIB0Ja6+CKZOKNvT8VpYnNN7oFzAAgipenQeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780703425; c=relaxed/simple;
	bh=tApo/OEDjO5Y/7biuj6PXlNmujfkVa3lLIKVfjAw80M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9Qwb2166sObmxbpZ9qB3f6THagdZ1Zz9F6i/y+ccWbD99S7dsNiGiee/m+I6BVI+xRmwbXotjh0uucgHtw0L+j4VXhuudNNdkVdzxj2qgK3BwHvAlMi18lh9QXnlo/PyNQi1GZAFYxZMjJ4wjt8uxJRxuMx3hQjdbWIJbMPTjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=DIGeF/8M; arc=none smtp.client-ip=173.37.86.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="DIGeF/8M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=7172; q=dns/txt;
  s=iport01; t=1780703424; x=1781913024;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SCq/tA7G+zj231+SLDHsXKDDZL5z7SMOv/x5If3ZvWg=;
  b=DIGeF/8MT3Adg7zlTBRE2BZXtWDPYwj/1OZrKDEPOm+tkRtNL9FCqkNv
   0SJG0PgdGupPqHWgxJdF8dBdV528vEnYLNKf+LclQRAmK7zW/Jbj2CuSl
   RI7svg5+9lf84jk+qFNWwto/5dLefzer5AJrC5hBjO9OXslcpIE8f696d
   p9N5V+9OmLCdX2kh3acEyL43jjkAsBuwevCNZ+u8J1FJ9t9Io125VPV8+
   tBeta7g5UQfOxz/laws5dhyx8AO2xtE7lb5sk5xYCoLh2i3C/dWNoJCYK
   EdCJyH0+fxN7xdP1Sj5OsCPw/UN49dFrOri6YIkH7m/a2z8NQV4hiYglQ
   w==;
X-CSE-ConnectionGUID: KZfGj/UfTSSqsGkBjFInWw==
X-CSE-MsgGUID: ydmlr842RAC2x822gAZUUg==
X-IPAS-Result: =?us-ascii?q?A0AaAACrXyNq/5P/Ja1aHAEBAQEBAQcBARIBAQQEAQGBf?=
 =?us-ascii?q?AcBAQsBglZ0XkMZMASMb4c3giGBFp0IgX4PAQEBD0QNBAEBhQYCjTMCJjQJD?=
 =?us-ascii?q?gECBAMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBDhOGTw2GWwIBAycLAUYQU?=
 =?us-ascii?q?VYZgwIBgnMDEbNqgXkzgQHeQoFmAQUGFAGBOAGNXHSEeycVBoFJRIEVgnIHb?=
 =?us-ascii?q?4EFAUyCOIZ9BIMuhHyBAGOJfUiBHgNZLAFVEw0KCwcFgWYDNRIqFW4yHYEjP?=
 =?us-ascii?q?heBCxsHBYFKgUlqgQSFEiMfAzmBF4F8gShnaRUxOhcDCxgNSBEsFCMUGwQ+b?=
 =?us-ascii?q?geMLhcPgjd7CQsrIi4GgQ4wHpMoBxSSLYE1n1mEJowhlToaM6prmQaOCZV/h?=
 =?us-ascii?q?TiBaDyBWTMaCBsVO4JnE0AZD44tCwuIc79WJzICAToCBwIHDgMLkWiBfQEB?=
IronPort-Data: A9a23:1xFdZakHFUJEjitABb5c0YXo5gwHJ0RdPkR7XQ2eYbSJt1+Wr1Gzt
 xJLDT2Da6rbNzbxcop+PI2z9k1Qup+GyNExTgZq+ClgRFtH+JHPbTi7wugcHM8zwunrFh8PA
 xA2M4GYRCwMZiaC4E/raf658SUUOZigHtLUEPTDNj16WThqQSIgjQMLs+Mii+aEu/Dha++2k
 Y20+ZG31GONgWYubDpKs//b8XuDgdyr0N8mlg1mDRx0lAe2e0k9VPo3Oay3Jn3kdYhYdsbSb
 /rD1ryw4lTC9B4rDN6/+p6jGqHdauePVeQmoiM+t5mK2nCulARrukoIHKZ0hXNsttm8t4sZJ
 OOhGnCHYVxB0qXkwIzxWvTDes10FfUuFLTveRBTvSEPpqHLWyOE/hlgMK05Fa4q9Ml1RlxAy
 ccjMSsibTqBqcOw/63uH4GAhux7RCXqFJkUtnclyXTSCuwrBMmbBa7L/tRfmjw3g6iiH96HO
 JFfMmUpNkmdJUQTZT/7C7pm9Ausrnr2aSFZrFuWjaE2+GPUigd21dABNfKJK4TTFZwJwRvwS
 mTu7mj8BgtKaIal4BHf4iL23ODmrx7GV9dHfFG/3rsw6LGJ/UQXCwU+VF2nrP3/gUm7M/pfI
 lYZ0ikjt64/8AqsVNaVdx+1onSsuh8aRsoWEuc/rgqKz8L85g+DGmkCCCZMdNE8r8IwbTsw3
 1SNkpXiAjkHmLSZQHGa7rCJhSm/NSgcMSkJYipsZQkA7t/ur4EypgjCQtZqDOi+ididMSv93
 T2QtwAkirkThNJN3KK+lXjDjy+qrZHPZhUo/QiRVWWghit9ZYi4d8mr5ELd4PJoMomUVB+Cs
 WIClszY6/oBZbmJlSqQUKAWF6qoz+iKPSeaglN1GZQlsTO39BaekZt4+jpyIgJtd80DYzKsO
 ReVsgJK75gVN3yvBUNqX7+M5w0R5fCIPbzYujr8N7KivrAZmNe7wRxT
IronPort-HdrOrdr: A9a23:xRwsq6z7hE/xJ0aBqWp7KrPw5r1zdoMgy1knxilNoNJuHvBw8P
 re+MjzuiWbtN98YhsdcJW7Scq9qBDnhPtICOsqXItKNTOO0ACVxcNZnOnfKlbbdBEWmNQx6Y
 5QN4BjFdz9CkV7h87m7AT9L8wt27C8gceVbJ/lr0tFfEVNd7xq6Rt/B0KwF017QxQDOL8Cfa
 DsgPauY1GbCAwqhgPRPAh9Y9T+
X-Talos-CUID: 9a23:+nLMgWw0m3irHV3CCLFqBgU3KM4KcDrgwkvrGFajJmVDSpO0T2CPrfY=
X-Talos-MUID: 9a23:0KiO9QRfH0mHgH9WRXT9iDRmLpc0uZ6HIxodwc9ctOC2CBF/bmI=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,189,1774310400"; 
   d="scan'208";a="490181475"
Received: from rcdn-l-core-10.cisco.com ([173.37.255.147])
  by rcdn-iport-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 05 Jun 2026 23:50:23 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.102.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-10.cisco.com (Postfix) with ESMTPSA id D353918000887;
	Fri,  5 Jun 2026 23:50:21 +0000 (GMT)
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
Subject: [PATCH v3 09/13] scsi: fnic: Send NVMe LS requests through FDLS
Date: Fri,  5 Jun 2026 16:45:34 -0700
Message-ID: <20260605234538.7950-10-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260605234538.7950-1-kartilak@cisco.com>
References: <20260605234538.7950-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.102.68];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.102.68, [10.188.102.68]
X-Outbound-Node: rcdn-l-core-10.cisco.com

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
---
 drivers/scsi/fnic/fdls_fc.h   |   8 +++
 drivers/scsi/fnic/fnic_nvme.c | 115 +++++++++++++++++++++++++++++++++-
 drivers/scsi/fnic/fnic_nvme.h |   3 +
 3 files changed, 125 insertions(+), 1 deletion(-)

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
index 1cc525a24655..afbf6c1abf4a 100644
--- a/drivers/scsi/fnic/fnic_nvme.c
+++ b/drivers/scsi/fnic/fnic_nvme.c
@@ -1280,6 +1280,119 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
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
@@ -1580,7 +1693,7 @@ nvme_fc_port_template nvfnic_port = {
 	.remoteport_delete = nvfnic_remote_port_delete,
 	.create_queue = nvfnic_create_queue,
 	.delete_queue = NULL,
-	.ls_req = NULL,
+	.ls_req = nvfnic_ls_req_send,
 	.ls_abort = nvfnic_ls_req_abort,
 	.fcp_io = nvfnic_fcpio_send,
 	.fcp_abort = nvfnic_fcpio_abort,
diff --git a/drivers/scsi/fnic/fnic_nvme.h b/drivers/scsi/fnic/fnic_nvme.h
index 317b0bc4129d..837b5cdc0a6c 100644
--- a/drivers/scsi/fnic/fnic_nvme.h
+++ b/drivers/scsi/fnic/fnic_nvme.h
@@ -110,6 +110,9 @@ void nvfnic_ls_req_abort(struct nvme_fc_local_port *lport,
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

