Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792448154;
	b=Zw0OA6zi+x0tn7FHk8OChL45joFqcV2gf8bVP6dv+81NKdg/OlI/0JhjXeCjqLaajmYO
	 lfDuzpwvJNhjxN/YLHrY8tB3I1HOPfCTUqVClO146/Grj5y1bdYcz3dTH3Fv5sDZHC8QR
	 +EAbc/6H6RBtX0qx0CduTTVpfzocOqn3zk6KTg/Xqpud87723Ivgl3nWLwsqa3sGK81XV
	 v9YBkyV0xmE/Y6Pj+oZHe2MwuDmcmHgZR8XmFUAq6eQKkx3/D/wjWp937S9jFgmB+uj9A
	 vHaVEymM1Q5UK8QuueFF7mef+OBHzZ186jdjXPfr35O0wUtPFhNHJOeUJh7a/tXNBOA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792448154;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Xk2Ztj7DCrgZY5fc7/Gh6Jqs3mmiRMALdj9sBB1Hdyw=;
	b=z0ldgrvH05R3isAKftIBmx48vTUmYH2upDBxbnQSU0CV4BMLq2kMZZc9BxbTOFt/eBQv
	 dnoRVxULfsjLYpPdKiS92DYbdXk32kCBLudpe1LStCqQSiOKIqtJF5qXcraffCQ6lMf7K
	 D4xXU7d6HBcH+qQMSZdXZylcD9vMmyREEXcQ7hBVzdIsmIzjFpu/OluWlb321uociDXV8
	 oEyVc6djjCjlFNztiKWYsnaekJlraIB3ySYX/xZDHSaONJlmRWjMaKlxVn/rT0Y5zdwQv
	 JFimT25k9MMbbHNviVrbxbV3an+3vplOSVMvx7of56zpHatUtzQI5pLJ2UnxlGU6Vqg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZHAgFBTt;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F209460A2606;
	Mon, 19 Oct 2026 22:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZHAgFBTt
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792448153;
	b=UP/RVWV/nviS4j2fDC54RTplF161Ggdiy3XN2yrL+8A71usTTim+U/vP1W06dZ4ISU0b
	 ftsttNuZKgZlCDvm6GxTEsUoayMnk5s133g1ipM7XiAc96mYQTp9c6Mtiq+SUors9oFOY
	 OzwWRiZaAHK7oeGNWvKVQQB71G2azuhbC9AmsUx11T9XqE3mScT42dCHvI8iyo9B0i2mG
	 eXuL1Nfes2Pvl9og9Q40pIpeCAfZcqXZmYl4j60gzUoh7x8r5AjKaGeLBX0JxYIucsBK8
	 alVgLyQWXI2uXC+hzUnRpB9YIEZ3t3scHh8gehFn3UyZ9mGkoc7SIYdPCI8rMwEimeQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792448153;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Xk2Ztj7DCrgZY5fc7/Gh6Jqs3mmiRMALdj9sBB1Hdyw=;
	b=duod8ID7ujZr/zZHB9hSqkz+Jmk1DY8ZkYRbaoNzNwW1RXjCALnlV288zmjPRhBnlSpS
	 43orXznagQKDVLlucQc6ZV/EEh28XT+ve2/F0OrRGeCYgg+BEoPLaYQ3U8BPA5qCDQFxg
	 BEQo/sHR4lAtxw44hFvL/401/xVDIex6QXa4eQJznePBoO2+yUKUI+Z+WA6hMQGugHxMX
	 p60FGMPUYI995hheLXmYnF+Z8cpBQRuGZkJwZ389LyXwOVsYK94rhy+g6S5nzqBJzEEyh
	 TWX+eBrNQiWhoDKBrEdwWdw6FhKjoyIv4Ya5IUWMn5+l4WKplxvxN/9CSm4KL2+yFQg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4FB681F000C7;
	Mon, 19 Oct 2026 22:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792448153;
	bh=Xk2Ztj7DCrgZY5fc7/Gh6Jqs3mmiRMALdj9sBB1Hdyw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ZHAgFBTtlpGcm3VCQPSIj3buLGZUSwo3V3xZxGEL6sBnY7WOV1seq+8QLwhdS4bXS
	 EO/ZYNfFGnwAn3qEtPKW+tI2s1+YW4gO85wbwbnjoEHo7XJDIH2rFRurNhnuceMyfJ
	 GOVFLVWRkmucbjkYAtGW3541ax9X4Rj8UaYnCfHtAP2yTT59ijy4/ZQE7h7Eq0CbIa
	 imKFU95rIWCKmDL0jKlcmOjp7qU9RBGMdRp9HJP4XIa3x8zTRfB1EikxEhOxm9A+Zj
	 vtij9knDeImAnoNa3nolz/BBF53AQ9mrIlTULph6Jv0/Y5OM3aXxSGEG8bbzxJVz0Z
	 Dgu2SDc4vCA8Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 5261940682;
	Mon, 19 Oct 2026 22:15:49 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 19 Oct 2026 17:15:55 -0500
Subject: [PATCH v15 10/11] scsi: ibmvfc: register and use asynchronous sub
 CRQ for events
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261019-ibmvfc-fpin-support-v15-10-a858726e178a@linux.ibm.com>
References: <20261019-ibmvfc-fpin-support-v15-0-a858726e178a@linux.ibm.com>
In-Reply-To: <20261019-ibmvfc-fpin-support-v15-0-a858726e178a@linux.ibm.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, Dave Marquardt <davemarq@linux.ibm.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792448148; l=12459;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=qvxpALcfzPOnlHpZd2xWVJEYCUaOcQ+Ez2c5y8IawwY=;
 b=3d3i3PU9dNsbiJ/AvfSC06riTfYKsOm5Ru3ITYsVMgOtF0MF8Ri8nyN+KQ39FhfC1hjtBKCpN
 TO0JHgSY4JrCCICJ0Qg1Ljz8dHhr8BVHCIcPFVbW9ND1SghjaLeb8Si
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com
Content-Transfer-Encoding: 7bit

From: Dave Marquardt <davemarq@linux.ibm.com>

Wire the async sub-CRQ into the sub-CRQ lifecycle so it is allocated,
registered, and freed alongside the SCSI channel queues.

In ibmvfc_probe(), initialize vhost->async_scrqs with desired_queues=1,
max_queues=1, and protocol=IBMVFC_PROTO_ASYNC. Add
ibmvfc_release_channels() as a helper to free a channels array and its
queue buffers.

In ibmvfc_init_sub_crqs(), allocate the async sub-CRQ via
ibmvfc_alloc_channels() before allocating the SCSI channels. Register it
with the VIOS via ibmvfc_reg_sub_crqs(). Either failure disables
multi-queue and aborts init. In ibmvfc_reg_sub_crqs(), also clear
vhost->mq_enabled on registration failure to prevent a host state
machine stall: without this, mq_enabled remaining set causes
ibmvfc_npiv_login_done() to enter the multi-queue branch while
do_enquiry is 0, bypassing both
ibmvfc_channel_enquiry() and the fallback that would wake up the work
queue, leaving the host indefinitely in IBMVFC_HOST_ACTION_INIT_WAIT.

Both mq_enabled and do_enquiry are bitfields packed into the same word
as other state flags such as using_channels. Writes to these fields
from ibmvfc_reg_sub_crqs() and ibmvfc_init_sub_crqs() are performed
outside host_lock, while concurrent writers like
ibmvfc_channel_setup_done() hold host_lock when modifying other fields
in the same word. To prevent lost updates from concurrent
read-modify-write operations on the packed bitfield word, take
host_lock around all failure-path writes to mq_enabled, do_enquiry, and
nvme_enabled in ibmvfc_reg_sub_crqs() and ibmvfc_init_sub_crqs().

In ibmvfc_alloc_channels(), select IBMVFC_ASYNC_SUB_CRQ_FMT for async
protocol channels instead of IBMVFC_SUB_CRQ_FMT, so the queue is sized
for ibmvfc_async_sub_crq entries. Zero active_queues on allocation
failure to ensure the field is always consistent with scrqs.

In ibmvfc_release_sub_crqs(), ibmvfc_reenable_crq_queue(), and
ibmvfc_reset_crq(), deregister and re-register the async sub-CRQ
alongside the SCSI channel queues.

In ibmvfc_channel_setup_done(), compute async->active_queues from the
VIOS response: set it to 1 only when async->scrqs is non-NULL and the
response contains a non-zero async_sub_crq_handle, otherwise 0. Store
the handle in vhost->async_scrqs.scrqs[0].vios_cookie via the
active_queues loop. Clamp scsi->active_queues and nvme->active_queues
to their respective max_queues values before using them as loop bounds,
preventing out-of-bounds access to scrqs[] if the hypervisor returns a
larger value than was allocated. In ibmvfc_channel_setup(), guard the
access to async->scrqs[0].cookie behind a NULL check to prevent a
dereference when mq_enabled is 0 and async->scrqs was never allocated.

In ibmvfc_set_login_info(), advertise IBMVFC_USE_ASYNC_SUBQ,
IBMVFC_CAN_HANDLE_FPIN, and IBMVFC_YES_SCSI capabilities whenever
multi-queue channels are enabled. IBMVFC_YES_SCSI was previously only
set for NVMe-enabled configurations; move it to the common multi-queue
path so it is always advertised when channels are in use.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 108 ++++++++++++++++++++++++++----------
 1 file changed, 79 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 7e012281d368..0d603542fe34 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -964,6 +964,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	unsigned long flags;
 
+	ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
 
@@ -986,6 +987,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
+	ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs);
 	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
 	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
 
@@ -1006,6 +1008,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	struct ibmvfc_queue *crq = &vhost->crq;
 
+	ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
 
@@ -1042,6 +1045,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
+	ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs);
 	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
 	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
 
@@ -1584,9 +1588,11 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 
 	if (vhost->mq_enabled || vhost->using_channels) {
 		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
+		login_info->capabilities |= cpu_to_be64(IBMVFC_USE_ASYNC_SUBQ);
+		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_HANDLE_FPIN);
+		login_info->capabilities |= cpu_to_be64(IBMVFC_YES_SCSI);
 		if (vhost->nvme_enabled) {
 			login_info->capabilities |= cpu_to_be64(IBMVFC_YES_NVMEOF);
-			login_info->capabilities |= cpu_to_be64(IBMVFC_YES_SCSI);
 			login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_WWPN_ALL);
 		}
 	}
@@ -5802,6 +5808,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 {
 	struct ibmvfc_host *vhost = evt->vhost;
 	struct ibmvfc_channel_setup *setup = vhost->channel_setup_buf;
+	struct ibmvfc_channels *async = &vhost->async_scrqs;
 	struct ibmvfc_channels *scsi = &vhost->scsi_scrqs;
 	struct ibmvfc_channels *nvme = &vhost->nvme_scrqs;
 	u32 mad_status = be16_to_cpu(evt->xfer_iu->channel_setup.common.status);
@@ -5815,8 +5822,11 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 		ibmvfc_dbg(vhost, "Channel Setup succeeded\n");
 		flags = be32_to_cpu(setup->flags);
 		vhost->do_enquiry = 0;
-		scsi->active_queues = be32_to_cpu(setup->num_scsi_subq_channels);
-		nvme->active_queues = be32_to_cpu(setup->num_nvme_subq_channels);
+		scsi->active_queues = min(be32_to_cpu(setup->num_scsi_subq_channels),
+					  scsi->max_queues);
+		nvme->active_queues = min(be32_to_cpu(setup->num_nvme_subq_channels),
+					  nvme->max_queues);
+		async->active_queues = (async->scrqs && setup->async_sub_crq_handle) ? 1 : 0;
 
 		if (flags & IBMVFC_CHANNELS_CANCELED) {
 			ibmvfc_dbg(vhost, "Channels Canceled\n");
@@ -5832,6 +5842,8 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 		for (i = 0; i < nvme->active_queues; i++)
 			nvme->scrqs[i].vios_cookie =
 				be64_to_cpu(setup->channel_handles[scsi->active_queues + i]);
+		for (i = 0; i < async->active_queues; i++)
+			async->scrqs[i].vios_cookie = be64_to_cpu(setup->async_sub_crq_handle);
 
 		ibmvfc_dbg(vhost, "Using %u SCSI channels\n",
 			   scsi->active_queues);
@@ -5866,6 +5878,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 	struct ibmvfc_event *evt = ibmvfc_get_reserved_event(&vhost->crq);
 	struct ibmvfc_channels *scsi = &vhost->scsi_scrqs;
 	struct ibmvfc_channels *nvme = &vhost->nvme_scrqs;
+	struct ibmvfc_channels *async = &vhost->async_scrqs;
 	unsigned int scsi_channels =
 		min(scsi->desired_queues, vhost->max_vios_scsi_channels);
 	unsigned int nvme_channels =
@@ -5891,6 +5904,8 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 		for (i = 0; i < nvme_channels; i++)
 			setup_buf->channel_handles[scsi_channels + i] =
 				cpu_to_be64(nvme->scrqs[i].cookie);
+		if (async->scrqs)
+			setup_buf->async_sub_crq_handle = cpu_to_be64(async->scrqs[0].cookie);
 	}
 
 	ibmvfc_init_event(evt, ibmvfc_channel_setup_done, IBMVFC_MAD_FORMAT);
@@ -6738,6 +6753,9 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *vhost,
 		queue->evt_depth = scsi_qdepth;
 		queue->reserved_depth = IBMVFC_NUM_INTERNAL_SUBQ_REQ;
 		break;
+	case IBMVFC_ASYNC_SUB_CRQ_FMT:
+		fmt_size = sizeof(*queue->msgs.async_scrq);
+		break;
 	default:
 		dev_warn(dev, "Unknown command/response queue message format: %d\n", fmt);
 		return -EINVAL;
@@ -6977,6 +6995,7 @@ EXPORT_SYMBOL_IF_KUNIT(ibmvfc_deregister_channel);
 static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
 				struct ibmvfc_channels *channels)
 {
+	unsigned long flags;
 	int i, j;
 
 	ENTER;
@@ -6987,7 +7006,10 @@ static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
 		if (ibmvfc_register_channel(vhost, channels, i)) {
 			for (j = i; j > 0; j--)
 				ibmvfc_deregister_channel(vhost, channels, j - 1);
+			spin_lock_irqsave(&vhost->host->host_lock, flags);
 			vhost->do_enquiry = 0;
+			vhost->mq_enabled = 0;
+			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 			return;
 		}
 	}
@@ -7014,16 +7036,21 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
 				 struct ibmvfc_channels *channels)
 {
 	struct ibmvfc_queue *scrq;
+	enum ibmvfc_msg_fmt fmt;
 	int i, j;
 	int rc = 0;
 
 	channels->scrqs = kzalloc_objs(*channels->scrqs, channels->max_queues);
-	if (!channels->scrqs)
+	if (!channels->scrqs) {
+		channels->active_queues = 0;
 		return -ENOMEM;
+	}
 
+	fmt = (channels->protocol != IBMVFC_PROTO_ASYNC) ? IBMVFC_SUB_CRQ_FMT :
+		IBMVFC_ASYNC_SUB_CRQ_FMT;
 	for (i = 0; i < channels->max_queues; i++) {
 		scrq = &channels->scrqs[i];
-		rc = ibmvfc_alloc_queue(vhost, scrq, IBMVFC_SUB_CRQ_FMT);
+		rc = ibmvfc_alloc_queue(vhost, scrq, fmt);
 		if (rc) {
 			for (j = i; j > 0; j--) {
 				scrq = &channels->scrqs[j - 1];
@@ -7039,30 +7066,6 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
 	return rc;
 }
 
-static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
-{
-	ENTER;
-	if (!vhost->mq_enabled)
-		return;
-
-	if (ibmvfc_alloc_channels(vhost, &vhost->scsi_scrqs)) {
-		vhost->do_enquiry = 0;
-		vhost->mq_enabled = 0;
-		return;
-	}
-
-	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
-
-	if (vhost->nvme_enabled) {
-		if (ibmvfc_alloc_channels(vhost, &vhost->nvme_scrqs))
-			vhost->nvme_enabled = 0;
-		else
-			ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
-	}
-
-	LEAVE;
-}
-
 static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
 				    struct ibmvfc_channels *channels)
 {
@@ -7081,9 +7084,53 @@ static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
 	}
 }
 
+static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
+{
+	unsigned long flags;
+
+	ENTER;
+	if (!vhost->mq_enabled)
+		return;
+
+	/* register async_sub_crq channel */
+	if (ibmvfc_alloc_channels(vhost, &vhost->async_scrqs))
+		goto out;
+
+	ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs);
+
+	if (ibmvfc_alloc_channels(vhost, &vhost->scsi_scrqs))
+		goto deregister_async_sub_crq;
+
+	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
+
+	if (vhost->nvme_enabled) {
+		if (ibmvfc_alloc_channels(vhost, &vhost->nvme_scrqs)) {
+			spin_lock_irqsave(&vhost->host->host_lock, flags);
+			vhost->nvme_enabled = 0;
+			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+		} else
+			ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
+	}
+
+	LEAVE;
+	return;
+
+deregister_async_sub_crq:
+	ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
+	ibmvfc_release_channels(vhost, &vhost->async_scrqs);
+out:
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
+	vhost->do_enquiry = 0;
+	vhost->mq_enabled = 0;
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+}
+
 static void ibmvfc_release_sub_crqs(struct ibmvfc_host *vhost)
 {
 	ENTER;
+	ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
+	ibmvfc_release_channels(vhost, &vhost->async_scrqs);
+
 	if (!vhost->scsi_scrqs.scrqs)
 		return;
 
@@ -7349,6 +7396,9 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	vhost->task_set = 1;
 
 	vhost->mq_enabled = mq_enabled;
+	vhost->async_scrqs.desired_queues = 1;
+	vhost->async_scrqs.max_queues = 1;
+	vhost->async_scrqs.protocol = IBMVFC_PROTO_ASYNC;
 	vhost->scsi_scrqs.desired_queues = min(shost->nr_hw_queues, nr_scsi_channels);
 	vhost->scsi_scrqs.max_queues = shost->nr_hw_queues;
 	vhost->scsi_scrqs.protocol = IBMVFC_PROTO_SCSI;

-- 
2.56.0


