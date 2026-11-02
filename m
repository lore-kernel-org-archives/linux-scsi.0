Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793655539;
	b=V38ie/r8t5hwM3wBs/UUpoukizCPQbxuC0HQ+zntOe5SlyzpNB5x60DGh2S0lIRrQmDA
	 kpwNbHdHQ5b9hNK59LGyLFyRJKn50UEGCtUj410n5qsBBTWMWpfk2F4rSV1OktGVndfbb
	 niZ58F8uRC+A3F/LUmzR0yy69pxlN+j8WWlYME/PQZaxoZhGVjLK4acPRyep3JQ6tr+9U
	 jwCI7ICcRPeVzoulZym93Xi/P/X1w1ZR+y0mtLy2kbfrY4iLK+NTMHk8HdFbbDZPMQaix
	 mr0ed9K6lTjIPApIgJrlDjyzGul7ORru18aba5aBNLeaYizqXdFO9LNVLTMoaYA+KRQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655539;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=TH2a92q6skFRzGu+FgUd98dgDi0Z6e62LJ7J/mEbM1Y=;
	b=x0ITwoZfuuLc66+KkyeL7zzrT25Y1BeaXhpQTq037xVM6stjKnUdcHlJk5oIGNlpDNrf
	 XVlb58EzKQO97GwZTpQGLn/XIu1pXzSaENLJyrTKBoTpN2ym96XzdGpFSOB4xTonULI2w
	 9iir4dufu4/YPksnYaLP61abjhjnyssotsdQ+3Cdlw7fwUBQL+GoooIEbmWN1hwnQpJrA
	 GIoh7rBMJWZHRWN2LXoRebOICkWpT34AXZ5BvLdjEdF4aibWGFlvsd0AtlRzZYp1+0dxU
	 aTKec2ufQbzNMWlGqvKJ1Oa5LQVvrJYCv25JRn4Jwouy6kkzBO6JmjteW9p9JbCabTA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=arS3XhOd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32A1606A33D;
	Mon,  2 Nov 2026 21:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=arS3XhOd
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793655538;
	b=KxfNpzx9w6PDQo832g0pw5fOJ0sc3WN1SX8C582Cmfab89lVVREPq9Zk0ckD1PqsP9WN
	 L9rcfZCgnf+GLTH/fWMf1hB0+430Ntajzyy0H6tAm1OpBcnI8de7ejCbxtN41H6vNKHok
	 pAQXh2CrsPp2JHtTNv2ESb0i4qgVomYLqQFad4drhgE4IDeN9FWjhsCqejQBxmtH/IGY/
	 lWAJCg6iwycTpv0w6LKOz7289yMe3J9cq8SuntoHO6B8/JKeQcK1d1EDZhhqqPmg3CN+n
	 hCNFAldn5Q1F8bsM7f91XnEZVGxR6qW56veMDUexeVZK/D1PYceN99wmEFY9xg0igxw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793655538;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=TH2a92q6skFRzGu+FgUd98dgDi0Z6e62LJ7J/mEbM1Y=;
	b=vfjVCRGcd0wM2nWtzyShkG0FQ5tFGiGsyTH4JXpHawG1k6fPxxtEHF73cnAwr8kphrTr
	 zh58LwXW0Sn8O/wyysH2zTsQUyk5ORfAF1cvO9ijbbm1lIHPCq/EjL3B3ML0r8kGL8jA2
	 XDXWrj6EQ3ORiXNsz2F9sFPpuqV3KMNdrWMrYGX9cpY51otGcofvKflQMrL3joj4QoYtB
	 aG+T/2+fbzFH3DoTeM+xxYvBS++wXVqve8IJCCYk81PbUHW+YSkY/3o38xl2jbjEGlkL0
	 LgC4v/LvjZEeEtWwRhDKZpxlwP42h23tJ58PFfOWUqcIM2KRgXk3+11lybjqLQOT+Gg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 633951F00A23;
	Mon,  2 Nov 2026 21:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793655538;
	bh=TH2a92q6skFRzGu+FgUd98dgDi0Z6e62LJ7J/mEbM1Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=arS3XhOd1fL3AXHnWOJ12vMJp8s0YXG48qdZTyXPmLomUXo6x1UkzUuHvIPmjWPjj
	 I1DGwm/W3BeVwxKrAc0Mx/ks0jHRIg6StPhim0GCXH5I9PyLhq+qYGu3Kl/PoauAT6
	 DPWNo0ZLENKwTWNCAjEmy6r/UyqINw76dy7wfbqcB4NwwzBaTVNzCzRIPa5QPh1+K2
	 bUp8YuiTSNghkqjlbGgWvX10thSTUV7h04bJ5IKo5FH8H6JbOh9+eWnOPvwRittqvm
	 5F+pOIlKCE/RxktFfOMZa+o2Gel8+oZD40r0CIMjXzzGY1uTSfE0xIxATPITUUFGit
	 7/Smiqnj7THlQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 0A39D466BE;
	Mon,  2 Nov 2026 21:38:52 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 02 Nov 2026 15:38:52 -0600
Subject: [PATCH v17 12/13] scsi: ibmvfc: register and use asynchronous sub
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
Message-Id: <20261102-ibmvfc-fpin-support-v17-12-9ee5f195ac91@linux.ibm.com>
References: <20261102-ibmvfc-fpin-support-v17-0-9ee5f195ac91@linux.ibm.com>
In-Reply-To: <20261102-ibmvfc-fpin-support-v17-0-9ee5f195ac91@linux.ibm.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, Dave Marquardt <davemarq@linux.ibm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793655530; l=54913;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=d7nbIpCKQCkcCgpvvs8ug3Us/FCxaixG8Toga/AsWWM=;
 b=e45ze3/Q3eZPMUqZbz7TAJiCTc1PxB73tc3yXall3QEWE93lsLjm2ts6C0nx7FVDVdgCzrCgt
 KQFA5LoZLGuBq4MjtXZ5wGCFMkEKHHrNq5b5ZMrh/+IZClQqlICZdJI
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
max_queues=1, and protocol=IBMVFC_PROTO_ASYNC.

In ibmvfc_init_sub_crqs(), allocate the async sub-CRQ via
ibmvfc_alloc_channels() before allocating the SCSI channels. Change
ibmvfc_reg_sub_crqs() to return int (0 on success, -1 on failure) so
ibmvfc_init_sub_crqs() can detect registration failure per channel set
and unwind correctly: async registration failure releases async_scrqs
and disables multi-queue; SCSI registration failure releases scsi_scrqs,
deregisters and releases async_scrqs, and disables multi-queue.
ibmvfc_reg_sub_crqs() returns -1 on failure and leaves flag management
to its callers. In ibmvfc_init_sub_crqs(), registration failure of any
channel set triggers cleanup of that set and all previously registered
sets, then clears vhost->mq_enabled and vhost->do_enquiry to prevent a
host state machine stall: without this, mq_enabled remaining set causes
ibmvfc_npiv_login_done() to enter the multi-queue branch while
do_enquiry is 0, bypassing ibmvfc_channel_enquiry() and leaving the
host indefinitely in IBMVFC_HOST_ACTION_INIT_WAIT. In
ibmvfc_reenable_crq_queue() and ibmvfc_reset_crq(), if any
ibmvfc_reg_sub_crqs() call fails, all three channel sets are
deregistered and mq_enabled and do_enquiry are cleared.

mq_enabled and do_enquiry are bitfields packed into the same word as
other state flags such as using_channels. All failure-path writes to
mq_enabled, do_enquiry, and nvme_enabled are performed under host_lock
to prevent lost updates from concurrent read-modify-write operations on
the packed bitfield word.

Remove vhost->mq_enabled from the ibmvfc_dereg_sub_crqs() guard,
relying solely on !channels->scrqs. The previous guard caused all
deregistration calls after a registration failure to be silently
skipped: since ibmvfc_reg_sub_crqs() clears mq_enabled on failure, any
previously registered channel sets (e.g. async_scrqs registered before
scsi_scrqs fails) would be leaked -- their hypervisor sub-CRQ
registrations and IRQ handlers left active while
ibmvfc_release_channels() subsequently freed the underlying memory.
ibmvfc_deregister_channel() already guards individually on scrq->cookie
and scrq->irq, so iterating unconditionally over channels with scrqs
allocated is safe.

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
Set async_sub_crq_handle unconditionally so the handle is communicated
to VIOS even when scsi_channels and nvme_channels are both 0; omitting
it on the CANCEL_CHANNELS path would leave the async sub-CRQ registered
and advertised but unused.

In ibmvfc_set_login_info(), advertise IBMVFC_USE_ASYNC_SUBQ,
IBMVFC_CAN_HANDLE_FPIN, and IBMVFC_YES_SCSI capabilities whenever
multi-queue channels are enabled. IBMVFC_YES_SCSI was previously only
set for NVMe-enabled configurations; move it to the common multi-queue
path so it is always advertised when channels are in use.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 89543b65a2af..2e51d5dd086e 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -191,7 +191,7 @@ static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *);
 static void ibmvfc_tgt_move_login(struct ibmvfc_target *);

 static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *, struct ibmvfc_channels *);
-static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *, struct ibmvfc_channels *);
+static int ibmvfc_reg_sub_crqs(struct ibmvfc_host *, struct ibmvfc_channels *);

 static const char *unknown_error = "unknown error";

@@ -966,6 +966,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	unsigned long flags;

+	ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);

@@ -988,8 +989,17 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(&vhost->host->host_lock, flags);

-	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
-	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
+	if (ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs) ||
+	    ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs) ||
+	    ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs)) {
+		ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
+		ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
+		ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
+		spin_lock_irqsave(&vhost->host->host_lock, flags);
+		vhost->do_enquiry = 0;
+		vhost->mq_enabled = 0;
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+	}

 	return rc;
 }
@@ -1008,6 +1018,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	struct ibmvfc_queue *crq = &vhost->crq;

+	ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);

@@ -1044,8 +1055,17 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(&vhost->host->host_lock, flags);

-	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
-	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
+	if (ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs) ||
+	    ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs) ||
+	    ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs)) {
+		ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
+		ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
+		ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
+		spin_lock_irqsave(&vhost->host->host_lock, flags);
+		vhost->do_enquiry = 0;
+		vhost->mq_enabled = 0;
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+	}

 	return rc;
 }
@@ -1586,9 +1606,11 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)

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
@@ -5857,6 +5879,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 {
 	struct ibmvfc_host *vhost = evt->vhost;
 	struct ibmvfc_channel_setup *setup = vhost->channel_setup_buf;
+	struct ibmvfc_channels *async = &vhost->async_scrqs;
 	struct ibmvfc_channels *scsi = &vhost->scsi_scrqs;
 	struct ibmvfc_channels *nvme = &vhost->nvme_scrqs;
 	u32 mad_status = be16_to_cpu(evt->xfer_iu->channel_setup.common.status);
@@ -5870,8 +5893,11 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
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
@@ -5887,6 +5913,8 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 		for (i = 0; i < nvme->active_queues; i++)
 			nvme->scrqs[i].vios_cookie =
 				be64_to_cpu(setup->channel_handles[scsi->active_queues + i]);
+		for (i = 0; i < async->active_queues; i++)
+			async->scrqs[i].vios_cookie = be64_to_cpu(setup->async_sub_crq_handle);

 		ibmvfc_dbg(vhost, "Using %u SCSI channels\n",
 			   scsi->active_queues);
@@ -5921,6 +5949,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 	struct ibmvfc_event *evt = ibmvfc_get_reserved_event(&vhost->crq);
 	struct ibmvfc_channels *scsi = &vhost->scsi_scrqs;
 	struct ibmvfc_channels *nvme = &vhost->nvme_scrqs;
+	struct ibmvfc_channels *async = &vhost->async_scrqs;
 	unsigned int scsi_channels =
 		min(scsi->desired_queues, vhost->max_vios_scsi_channels);
 	unsigned int nvme_channels =
@@ -5946,6 +5975,8 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 		for (i = 0; i < nvme_channels; i++)
 			setup_buf->channel_handles[scsi_channels + i] =
 				cpu_to_be64(nvme->scrqs[i].cookie);
+		if (async->scrqs)
+			setup_buf->async_sub_crq_handle = cpu_to_be64(async->scrqs[0].cookie);
 	}

 	ibmvfc_init_event(evt, ibmvfc_channel_setup_done, IBMVFC_MAD_FORMAT);
@@ -6793,6 +6824,9 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *vhost,
 		queue->evt_depth = scsi_qdepth;
 		queue->reserved_depth = IBMVFC_NUM_INTERNAL_SUBQ_REQ;
 		break;
+	case IBMVFC_ASYNC_SUB_CRQ_FMT:
+		fmt_size = sizeof(*queue->msgs.async_scrq);
+		break;
 	default:
 		dev_warn(dev, "Unknown command/response queue message format: %d\n", fmt);
 		return -EINVAL;
@@ -7034,25 +7068,41 @@ VISIBLE_IF_KUNIT void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
 }
 EXPORT_SYMBOL_IF_KUNIT(ibmvfc_deregister_channel);

-static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
+/**
+ * ibmvfc_reg_sub_crqs - Register all queues in a channel set with the hypervisor
+ * @vhost:	ibmvfc host struct
+ * @channels:	channel set to register
+ *
+ * Iterates over channels->max_queues entries and calls ibmvfc_register_channel()
+ * for each. If any registration fails, previously registered queues in this
+ * channel set are deregistered and -1 is returned. The caller is responsible
+ * for clearing vhost->mq_enabled and vhost->do_enquiry and for deregistering
+ * any previously registered channel sets. Returns 0 immediately (without
+ * iterating) if mq_enabled is 0 or channels->scrqs is NULL.
+ *
+ * Return:
+ * * %0	- success, or multi-queue disabled / channels not allocated
+ * * %-1	- channel registration failed
+ */
+static int ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
 				struct ibmvfc_channels *channels)
 {
 	int i, j;

 	ENTER;
 	if (!vhost->mq_enabled || !channels->scrqs)
-		return;
+		return 0;

 	for (i = 0; i < channels->max_queues; i++) {
 		if (ibmvfc_register_channel(vhost, channels, i)) {
 			for (j = i; j > 0; j--)
 				ibmvfc_deregister_channel(vhost, channels, j - 1);
-			vhost->do_enquiry = 0;
-			return;
+			return -1;
 		}
 	}

 	LEAVE;
+	return 0;
 }

 static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *vhost,
@@ -7061,7 +7111,7 @@ static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *vhost,
 	int i;

 	ENTER;
-	if (!vhost->mq_enabled || !channels->scrqs)
+	if (!channels->scrqs)
 		return;

 	for (i = 0; i < channels->max_queues; i++)
@@ -7074,16 +7124,21 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
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
@@ -7099,30 +7154,6 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
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
@@ -7141,9 +7172,74 @@ static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
 	}
 }

+/**
+ * ibmvfc_init_sub_crqs - Allocate and register all sub-CRQ channel sets
+ * @vhost:	ibmvfc host struct
+ *
+ * Allocates and registers the async, SCSI, and (if nvme_enabled) NVMe
+ * sub-CRQ channel sets in order. Returns immediately if mq_enabled is 0.
+ *
+ * On failure at any stage, previously registered and allocated channel sets
+ * are deregistered and freed in reverse order, and vhost->mq_enabled and
+ * vhost->do_enquiry are cleared under host_lock to prevent the host state
+ * machine from stalling in IBMVFC_HOST_ACTION_INIT_WAIT.
+ */
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
+	if (ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs))
+		goto release_async_sub_crq;
+
+	if (ibmvfc_alloc_channels(vhost, &vhost->scsi_scrqs))
+		goto deregister_async_sub_crq;
+
+	if (ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs))
+		goto release_scsi_sub_crqs;
+
+	if (vhost->nvme_enabled) {
+		if (ibmvfc_alloc_channels(vhost, &vhost->nvme_scrqs)) {
+			spin_lock_irqsave(&vhost->host->host_lock, flags);
+			vhost->nvme_enabled = 0;
+			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+		} else if (ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs)) {
+			ibmvfc_release_channels(vhost, &vhost->nvme_scrqs);
+			spin_lock_irqsave(&vhost->host->host_lock, flags);
+			vhost->nvme_enabled = 0;
+			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+		}
+	}
+
+	LEAVE;
+	return;
+
+release_scsi_sub_crqs:
+	ibmvfc_release_channels(vhost, &vhost->scsi_scrqs);
+deregister_async_sub_crq:
+	ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
+release_async_sub_crq:
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

@@ -7409,6 +7505,9 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	vhost->task_set = 1;

 	vhost->mq_enabled = mq_enabled;
+	vhost->async_scrqs.desired_queues = 1;
+	vhost->async_scrqs.max_queues = 1;
+	vhost->async_scrqs.protocol = IBMVFC_PROTO_ASYNC;
 	vhost->scsi_scrqs.desired_queues = min(shost->nr_hw_queues, nr_scsi_channels);
 	vhost->scsi_scrqs.max_queues = shost->nr_hw_queues;
 	vhost->scsi_scrqs.protocol = IBMVFC_PROTO_SCSI;

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 89543b65a2af..2e51d5dd086e 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -191,7 +191,7 @@ static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *);
 static void ibmvfc_tgt_move_login(struct ibmvfc_target *);

 static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *, struct ibmvfc_channels *);
-static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *, struct ibmvfc_channels *);
+static int ibmvfc_reg_sub_crqs(struct ibmvfc_host *, struct ibmvfc_channels *);

 static const char *unknown_error = "unknown error";

@@ -966,6 +966,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	unsigned long flags;

+	ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);

@@ -988,8 +989,17 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(&vhost->host->host_lock, flags);

-	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
-	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
+	if (ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs) ||
+	    ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs) ||
+	    ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs)) {
+		ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
+		ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
+		ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
+		spin_lock_irqsave(&vhost->host->host_lock, flags);
+		vhost->do_enquiry = 0;
+		vhost->mq_enabled = 0;
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+	}

 	return rc;
 }
@@ -1008,6 +1018,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	struct ibmvfc_queue *crq = &vhost->crq;

+	ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);

@@ -1044,8 +1055,17 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(&vhost->host->host_lock, flags);

-	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
-	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
+	if (ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs) ||
+	    ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs) ||
+	    ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs)) {
+		ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
+		ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
+		ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
+		spin_lock_irqsave(&vhost->host->host_lock, flags);
+		vhost->do_enquiry = 0;
+		vhost->mq_enabled = 0;
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+	}

 	return rc;
 }
@@ -1586,9 +1606,11 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)

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
@@ -5857,6 +5879,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 {
 	struct ibmvfc_host *vhost = evt->vhost;
 	struct ibmvfc_channel_setup *setup = vhost->channel_setup_buf;
+	struct ibmvfc_channels *async = &vhost->async_scrqs;
 	struct ibmvfc_channels *scsi = &vhost->scsi_scrqs;
 	struct ibmvfc_channels *nvme = &vhost->nvme_scrqs;
 	u32 mad_status = be16_to_cpu(evt->xfer_iu->channel_setup.common.status);
@@ -5870,8 +5893,11 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
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
@@ -5887,6 +5913,8 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 		for (i = 0; i < nvme->active_queues; i++)
 			nvme->scrqs[i].vios_cookie =
 				be64_to_cpu(setup->channel_handles[scsi->active_queues + i]);
+		for (i = 0; i < async->active_queues; i++)
+			async->scrqs[i].vios_cookie = be64_to_cpu(setup->async_sub_crq_handle);

 		ibmvfc_dbg(vhost, "Using %u SCSI channels\n",
 			   scsi->active_queues);
@@ -5921,6 +5949,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 	struct ibmvfc_event *evt = ibmvfc_get_reserved_event(&vhost->crq);
 	struct ibmvfc_channels *scsi = &vhost->scsi_scrqs;
 	struct ibmvfc_channels *nvme = &vhost->nvme_scrqs;
+	struct ibmvfc_channels *async = &vhost->async_scrqs;
 	unsigned int scsi_channels =
 		min(scsi->desired_queues, vhost->max_vios_scsi_channels);
 	unsigned int nvme_channels =
@@ -5946,6 +5975,8 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 		for (i = 0; i < nvme_channels; i++)
 			setup_buf->channel_handles[scsi_channels + i] =
 				cpu_to_be64(nvme->scrqs[i].cookie);
+		if (async->scrqs)
+			setup_buf->async_sub_crq_handle = cpu_to_be64(async->scrqs[0].cookie);
 	}

 	ibmvfc_init_event(evt, ibmvfc_channel_setup_done, IBMVFC_MAD_FORMAT);
@@ -6793,6 +6824,9 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *vhost,
 		queue->evt_depth = scsi_qdepth;
 		queue->reserved_depth = IBMVFC_NUM_INTERNAL_SUBQ_REQ;
 		break;
+	case IBMVFC_ASYNC_SUB_CRQ_FMT:
+		fmt_size = sizeof(*queue->msgs.async_scrq);
+		break;
 	default:
 		dev_warn(dev, "Unknown command/response queue message format: %d\n", fmt);
 		return -EINVAL;
@@ -7034,25 +7068,41 @@ VISIBLE_IF_KUNIT void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
 }
 EXPORT_SYMBOL_IF_KUNIT(ibmvfc_deregister_channel);

-static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
+/**
+ * ibmvfc_reg_sub_crqs - Register all queues in a channel set with the hypervisor
+ * @vhost:	ibmvfc host struct
+ * @channels:	channel set to register
+ *
+ * Iterates over channels->max_queues entries and calls ibmvfc_register_channel()
+ * for each. If any registration fails, previously registered queues in this
+ * channel set are deregistered and -1 is returned. The caller is responsible
+ * for clearing vhost->mq_enabled and vhost->do_enquiry and for deregistering
+ * any previously registered channel sets. Returns 0 immediately (without
+ * iterating) if mq_enabled is 0 or channels->scrqs is NULL.
+ *
+ * Return:
+ * * %0	- success, or multi-queue disabled / channels not allocated
+ * * %-1	- channel registration failed
+ */
+static int ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
 				struct ibmvfc_channels *channels)
 {
 	int i, j;

 	ENTER;
 	if (!vhost->mq_enabled || !channels->scrqs)
-		return;
+		return 0;

 	for (i = 0; i < channels->max_queues; i++) {
 		if (ibmvfc_register_channel(vhost, channels, i)) {
 			for (j = i; j > 0; j--)
 				ibmvfc_deregister_channel(vhost, channels, j - 1);
-			vhost->do_enquiry = 0;
-			return;
+			return -1;
 		}
 	}

 	LEAVE;
+	return 0;
 }

 static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *vhost,
@@ -7061,7 +7111,7 @@ static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *vhost,
 	int i;

 	ENTER;
-	if (!vhost->mq_enabled || !channels->scrqs)
+	if (!channels->scrqs)
 		return;

 	for (i = 0; i < channels->max_queues; i++)
@@ -7074,16 +7124,21 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
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
@@ -7099,30 +7154,6 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
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
@@ -7141,9 +7172,74 @@ static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
 	}
 }

+/**
+ * ibmvfc_init_sub_crqs - Allocate and register all sub-CRQ channel sets
+ * @vhost:	ibmvfc host struct
+ *
+ * Allocates and registers the async, SCSI, and (if nvme_enabled) NVMe
+ * sub-CRQ channel sets in order. Returns immediately if mq_enabled is 0.
+ *
+ * On failure at any stage, previously registered and allocated channel sets
+ * are deregistered and freed in reverse order, and vhost->mq_enabled and
+ * vhost->do_enquiry are cleared under host_lock to prevent the host state
+ * machine from stalling in IBMVFC_HOST_ACTION_INIT_WAIT.
+ */
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
+	if (ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs))
+		goto release_async_sub_crq;
+
+	if (ibmvfc_alloc_channels(vhost, &vhost->scsi_scrqs))
+		goto deregister_async_sub_crq;
+
+	if (ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs))
+		goto release_scsi_sub_crqs;
+
+	if (vhost->nvme_enabled) {
+		if (ibmvfc_alloc_channels(vhost, &vhost->nvme_scrqs)) {
+			spin_lock_irqsave(&vhost->host->host_lock, flags);
+			vhost->nvme_enabled = 0;
+			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+		} else if (ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs)) {
+			ibmvfc_release_channels(vhost, &vhost->nvme_scrqs);
+			spin_lock_irqsave(&vhost->host->host_lock, flags);
+			vhost->nvme_enabled = 0;
+			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+		}
+	}
+
+	LEAVE;
+	return;
+
+release_scsi_sub_crqs:
+	ibmvfc_release_channels(vhost, &vhost->scsi_scrqs);
+deregister_async_sub_crq:
+	ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
+release_async_sub_crq:
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

@@ -7409,6 +7505,9 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	vhost->task_set = 1;

 	vhost->mq_enabled = mq_enabled;
+	vhost->async_scrqs.desired_queues = 1;
+	vhost->async_scrqs.max_queues = 1;
+	vhost->async_scrqs.protocol = IBMVFC_PROTO_ASYNC;
 	vhost->scsi_scrqs.desired_queues = min(shost->nr_hw_queues, nr_scsi_channels);
 	vhost->scsi_scrqs.max_queues = shost->nr_hw_queues;
 	vhost->scsi_scrqs.protocol = IBMVFC_PROTO_SCSI;

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 89543b65a2af..d7dd5996dc39 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -191,7 +191,7 @@ static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *);
 static void ibmvfc_tgt_move_login(struct ibmvfc_target *);

 static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *, struct ibmvfc_channels *);
-static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *, struct ibmvfc_channels *);
+static int ibmvfc_reg_sub_crqs(struct ibmvfc_host *, struct ibmvfc_channels *);

 static const char *unknown_error = "unknown error";

@@ -966,6 +966,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	unsigned long flags;

+	ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);

@@ -988,8 +989,17 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(&vhost->host->host_lock, flags);

-	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
-	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
+	if (ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs) ||
+	    ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs) ||
+	    ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs)) {
+		ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
+		ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
+		ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
+		spin_lock_irqsave(&vhost->host->host_lock, flags);
+		vhost->do_enquiry = 0;
+		vhost->mq_enabled = 0;
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+	}

 	return rc;
 }
@@ -1008,6 +1018,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	struct ibmvfc_queue *crq = &vhost->crq;

+	ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);

@@ -1044,8 +1055,17 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(&vhost->host->host_lock, flags);

-	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
-	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
+	if (ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs) ||
+	    ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs) ||
+	    ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs)) {
+		ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
+		ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
+		ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
+		spin_lock_irqsave(&vhost->host->host_lock, flags);
+		vhost->do_enquiry = 0;
+		vhost->mq_enabled = 0;
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+	}

 	return rc;
 }
@@ -1586,9 +1606,11 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)

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
@@ -5857,6 +5879,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 {
 	struct ibmvfc_host *vhost = evt->vhost;
 	struct ibmvfc_channel_setup *setup = vhost->channel_setup_buf;
+	struct ibmvfc_channels *async = &vhost->async_scrqs;
 	struct ibmvfc_channels *scsi = &vhost->scsi_scrqs;
 	struct ibmvfc_channels *nvme = &vhost->nvme_scrqs;
 	u32 mad_status = be16_to_cpu(evt->xfer_iu->channel_setup.common.status);
@@ -5870,8 +5893,11 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
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
@@ -5887,6 +5913,8 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 		for (i = 0; i < nvme->active_queues; i++)
 			nvme->scrqs[i].vios_cookie =
 				be64_to_cpu(setup->channel_handles[scsi->active_queues + i]);
+		for (i = 0; i < async->active_queues; i++)
+			async->scrqs[i].vios_cookie = be64_to_cpu(setup->async_sub_crq_handle);

 		ibmvfc_dbg(vhost, "Using %u SCSI channels\n",
 			   scsi->active_queues);
@@ -5921,6 +5949,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 	struct ibmvfc_event *evt = ibmvfc_get_reserved_event(&vhost->crq);
 	struct ibmvfc_channels *scsi = &vhost->scsi_scrqs;
 	struct ibmvfc_channels *nvme = &vhost->nvme_scrqs;
+	struct ibmvfc_channels *async = &vhost->async_scrqs;
 	unsigned int scsi_channels =
 		min(scsi->desired_queues, vhost->max_vios_scsi_channels);
 	unsigned int nvme_channels =
@@ -5948,6 +5977,9 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 				cpu_to_be64(nvme->scrqs[i].cookie);
 	}

+	if (async->scrqs)
+		setup_buf->async_sub_crq_handle = cpu_to_be64(async->scrqs[0].cookie);
+
 	ibmvfc_init_event(evt, ibmvfc_channel_setup_done, IBMVFC_MAD_FORMAT);
 	mad = &evt->iu.channel_setup;
 	memset(mad, 0, sizeof(*mad));
@@ -6793,6 +6825,9 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *vhost,
 		queue->evt_depth = scsi_qdepth;
 		queue->reserved_depth = IBMVFC_NUM_INTERNAL_SUBQ_REQ;
 		break;
+	case IBMVFC_ASYNC_SUB_CRQ_FMT:
+		fmt_size = sizeof(*queue->msgs.async_scrq);
+		break;
 	default:
 		dev_warn(dev, "Unknown command/response queue message format: %d\n", fmt);
 		return -EINVAL;
@@ -7034,25 +7069,41 @@ VISIBLE_IF_KUNIT void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
 }
 EXPORT_SYMBOL_IF_KUNIT(ibmvfc_deregister_channel);

-static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
+/**
+ * ibmvfc_reg_sub_crqs - Register all queues in a channel set with the hypervisor
+ * @vhost:	ibmvfc host struct
+ * @channels:	channel set to register
+ *
+ * Iterates over channels->max_queues entries and calls ibmvfc_register_channel()
+ * for each. If any registration fails, previously registered queues in this
+ * channel set are deregistered and -1 is returned. The caller is responsible
+ * for clearing vhost->mq_enabled and vhost->do_enquiry and for deregistering
+ * any previously registered channel sets. Returns 0 immediately (without
+ * iterating) if mq_enabled is 0 or channels->scrqs is NULL.
+ *
+ * Return:
+ * * %0	- success, or multi-queue disabled / channels not allocated
+ * * %-1	- channel registration failed
+ */
+static int ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
 				struct ibmvfc_channels *channels)
 {
 	int i, j;

 	ENTER;
 	if (!vhost->mq_enabled || !channels->scrqs)
-		return;
+		return 0;

 	for (i = 0; i < channels->max_queues; i++) {
 		if (ibmvfc_register_channel(vhost, channels, i)) {
 			for (j = i; j > 0; j--)
 				ibmvfc_deregister_channel(vhost, channels, j - 1);
-			vhost->do_enquiry = 0;
-			return;
+			return -1;
 		}
 	}

 	LEAVE;
+	return 0;
 }

 static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *vhost,
@@ -7061,7 +7112,7 @@ static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *vhost,
 	int i;

 	ENTER;
-	if (!vhost->mq_enabled || !channels->scrqs)
+	if (!channels->scrqs)
 		return;

 	for (i = 0; i < channels->max_queues; i++)
@@ -7074,16 +7125,21 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
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
@@ -7099,30 +7155,6 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
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
@@ -7141,9 +7173,74 @@ static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
 	}
 }

+/**
+ * ibmvfc_init_sub_crqs - Allocate and register all sub-CRQ channel sets
+ * @vhost:	ibmvfc host struct
+ *
+ * Allocates and registers the async, SCSI, and (if nvme_enabled) NVMe
+ * sub-CRQ channel sets in order. Returns immediately if mq_enabled is 0.
+ *
+ * On failure at any stage, previously registered and allocated channel sets
+ * are deregistered and freed in reverse order, and vhost->mq_enabled and
+ * vhost->do_enquiry are cleared under host_lock to prevent the host state
+ * machine from stalling in IBMVFC_HOST_ACTION_INIT_WAIT.
+ */
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
+	if (ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs))
+		goto release_async_sub_crq;
+
+	if (ibmvfc_alloc_channels(vhost, &vhost->scsi_scrqs))
+		goto deregister_async_sub_crq;
+
+	if (ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs))
+		goto release_scsi_sub_crqs;
+
+	if (vhost->nvme_enabled) {
+		if (ibmvfc_alloc_channels(vhost, &vhost->nvme_scrqs)) {
+			spin_lock_irqsave(&vhost->host->host_lock, flags);
+			vhost->nvme_enabled = 0;
+			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+		} else if (ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs)) {
+			ibmvfc_release_channels(vhost, &vhost->nvme_scrqs);
+			spin_lock_irqsave(&vhost->host->host_lock, flags);
+			vhost->nvme_enabled = 0;
+			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+		}
+	}
+
+	LEAVE;
+	return;
+
+release_scsi_sub_crqs:
+	ibmvfc_release_channels(vhost, &vhost->scsi_scrqs);
+deregister_async_sub_crq:
+	ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
+release_async_sub_crq:
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

@@ -7409,6 +7506,9 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	vhost->task_set = 1;

 	vhost->mq_enabled = mq_enabled;
+	vhost->async_scrqs.desired_queues = 1;
+	vhost->async_scrqs.max_queues = 1;
+	vhost->async_scrqs.protocol = IBMVFC_PROTO_ASYNC;
 	vhost->scsi_scrqs.desired_queues = min(shost->nr_hw_queues, nr_scsi_channels);
 	vhost->scsi_scrqs.max_queues = shost->nr_hw_queues;
 	vhost->scsi_scrqs.protocol = IBMVFC_PROTO_SCSI;
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 178 ++++++++++++++++++++++++++++--------
 1 file changed, 139 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 7b52401ae4d5..6e1ecf6891c7 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -191,7 +191,7 @@ static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *);
 static void ibmvfc_tgt_move_login(struct ibmvfc_target *);
 
 static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *, struct ibmvfc_channels *);
-static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *, struct ibmvfc_channels *);
+static int ibmvfc_reg_sub_crqs(struct ibmvfc_host *, struct ibmvfc_channels *);
 
 static const char *unknown_error = "unknown error";
 
@@ -966,6 +966,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	unsigned long flags;
 
+	ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
 
@@ -988,8 +989,17 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
-	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
-	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
+	if (ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs) ||
+	    ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs) ||
+	    ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs)) {
+		ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
+		ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
+		ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
+		spin_lock_irqsave(&vhost->host->host_lock, flags);
+		vhost->do_enquiry = 0;
+		vhost->mq_enabled = 0;
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+	}
 
 	return rc;
 }
@@ -1008,6 +1018,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	struct ibmvfc_queue *crq = &vhost->crq;
 
+	ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
 
@@ -1044,8 +1055,17 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
-	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
-	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
+	if (ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs) ||
+	    ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs) ||
+	    ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs)) {
+		ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
+		ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
+		ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
+		spin_lock_irqsave(&vhost->host->host_lock, flags);
+		vhost->do_enquiry = 0;
+		vhost->mq_enabled = 0;
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+	}
 
 	return rc;
 }
@@ -1586,9 +1606,11 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 
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
@@ -5907,6 +5929,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 {
 	struct ibmvfc_host *vhost = evt->vhost;
 	struct ibmvfc_channel_setup *setup = vhost->channel_setup_buf;
+	struct ibmvfc_channels *async = &vhost->async_scrqs;
 	struct ibmvfc_channels *scsi = &vhost->scsi_scrqs;
 	struct ibmvfc_channels *nvme = &vhost->nvme_scrqs;
 	u32 mad_status = be16_to_cpu(evt->xfer_iu->channel_setup.common.status);
@@ -5920,8 +5943,11 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
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
@@ -5937,6 +5963,8 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 		for (i = 0; i < nvme->active_queues; i++)
 			nvme->scrqs[i].vios_cookie =
 				be64_to_cpu(setup->channel_handles[scsi->active_queues + i]);
+		for (i = 0; i < async->active_queues; i++)
+			async->scrqs[i].vios_cookie = be64_to_cpu(setup->async_sub_crq_handle);
 
 		ibmvfc_dbg(vhost, "Using %u SCSI channels\n",
 			   scsi->active_queues);
@@ -5971,6 +5999,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 	struct ibmvfc_event *evt = ibmvfc_get_reserved_event(&vhost->crq);
 	struct ibmvfc_channels *scsi = &vhost->scsi_scrqs;
 	struct ibmvfc_channels *nvme = &vhost->nvme_scrqs;
+	struct ibmvfc_channels *async = &vhost->async_scrqs;
 	unsigned int scsi_channels =
 		min(scsi->desired_queues, vhost->max_vios_scsi_channels);
 	unsigned int nvme_channels =
@@ -5998,6 +6027,9 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 				cpu_to_be64(nvme->scrqs[i].cookie);
 	}
 
+	if (async->scrqs)
+		setup_buf->async_sub_crq_handle = cpu_to_be64(async->scrqs[0].cookie);
+
 	ibmvfc_init_event(evt, ibmvfc_channel_setup_done, IBMVFC_MAD_FORMAT);
 	mad = &evt->iu.channel_setup;
 	memset(mad, 0, sizeof(*mad));
@@ -6843,6 +6875,9 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *vhost,
 		queue->evt_depth = scsi_qdepth;
 		queue->reserved_depth = IBMVFC_NUM_INTERNAL_SUBQ_REQ;
 		break;
+	case IBMVFC_ASYNC_SUB_CRQ_FMT:
+		fmt_size = sizeof(*queue->msgs.async_scrq);
+		break;
 	default:
 		dev_warn(dev, "Unknown command/response queue message format: %d\n", fmt);
 		return -EINVAL;
@@ -7084,25 +7119,41 @@ VISIBLE_IF_KUNIT void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
 }
 EXPORT_SYMBOL_IF_KUNIT(ibmvfc_deregister_channel);
 
-static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
+/**
+ * ibmvfc_reg_sub_crqs - Register all queues in a channel set with the hypervisor
+ * @vhost:	ibmvfc host struct
+ * @channels:	channel set to register
+ *
+ * Iterates over channels->max_queues entries and calls ibmvfc_register_channel()
+ * for each. If any registration fails, previously registered queues in this
+ * channel set are deregistered and -1 is returned. The caller is responsible
+ * for clearing vhost->mq_enabled and vhost->do_enquiry and for deregistering
+ * any previously registered channel sets. Returns 0 immediately (without
+ * iterating) if mq_enabled is 0 or channels->scrqs is NULL.
+ *
+ * Return:
+ * * %0	- success, or multi-queue disabled / channels not allocated
+ * * %-1	- channel registration failed
+ */
+static int ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
 				struct ibmvfc_channels *channels)
 {
 	int i, j;
 
 	ENTER;
 	if (!vhost->mq_enabled || !channels->scrqs)
-		return;
+		return 0;
 
 	for (i = 0; i < channels->max_queues; i++) {
 		if (ibmvfc_register_channel(vhost, channels, i)) {
 			for (j = i; j > 0; j--)
 				ibmvfc_deregister_channel(vhost, channels, j - 1);
-			vhost->do_enquiry = 0;
-			return;
+			return -1;
 		}
 	}
 
 	LEAVE;
+	return 0;
 }
 
 static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *vhost,
@@ -7111,7 +7162,7 @@ static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *vhost,
 	int i;
 
 	ENTER;
-	if (!vhost->mq_enabled || !channels->scrqs)
+	if (!channels->scrqs)
 		return;
 
 	for (i = 0; i < channels->max_queues; i++)
@@ -7124,16 +7175,21 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
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
@@ -7149,30 +7205,6 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
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
@@ -7191,9 +7223,74 @@ static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
 	}
 }
 
+/**
+ * ibmvfc_init_sub_crqs - Allocate and register all sub-CRQ channel sets
+ * @vhost:	ibmvfc host struct
+ *
+ * Allocates and registers the async, SCSI, and (if nvme_enabled) NVMe
+ * sub-CRQ channel sets in order. Returns immediately if mq_enabled is 0.
+ *
+ * On failure at any stage, previously registered and allocated channel sets
+ * are deregistered and freed in reverse order, and vhost->mq_enabled and
+ * vhost->do_enquiry are cleared under host_lock to prevent the host state
+ * machine from stalling in IBMVFC_HOST_ACTION_INIT_WAIT.
+ */
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
+	if (ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs))
+		goto release_async_sub_crq;
+
+	if (ibmvfc_alloc_channels(vhost, &vhost->scsi_scrqs))
+		goto deregister_async_sub_crq;
+
+	if (ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs))
+		goto release_scsi_sub_crqs;
+
+	if (vhost->nvme_enabled) {
+		if (ibmvfc_alloc_channels(vhost, &vhost->nvme_scrqs)) {
+			spin_lock_irqsave(&vhost->host->host_lock, flags);
+			vhost->nvme_enabled = 0;
+			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+		} else if (ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs)) {
+			ibmvfc_release_channels(vhost, &vhost->nvme_scrqs);
+			spin_lock_irqsave(&vhost->host->host_lock, flags);
+			vhost->nvme_enabled = 0;
+			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+		}
+	}
+
+	LEAVE;
+	return;
+
+release_scsi_sub_crqs:
+	ibmvfc_release_channels(vhost, &vhost->scsi_scrqs);
+deregister_async_sub_crq:
+	ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
+release_async_sub_crq:
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
 
@@ -7459,6 +7556,9 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
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


