Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792448153;
	b=KgUh9ysY86FWwc8TjCcAU1v6uNsNkA9zof5pnQtqHJEvTbNGhpX4VXt9Ok6/xXYqeMRH
	 PW33zM65Zitu3ypfGQF4Vb3fAcYZzqkOkVm6goNstGvJDLrMpHUA9on/ONMik9QH0Kaqf
	 VHfxwEyeZWYEDOFk4x/dB1sZAWpTllVaG88T73PuVfaaR/kt8dULoMLeaxCX+4muC2jPt
	 Y0XIlQ/Vi+Tjg10VQ36jwq2USMU4NECkN3fTieP4z87ds0tQComhyk49MDuabyMPWwxP5
	 ThZVBfA0jLbmNqkqKDuxE3Wz955dO1Z8QFOzi8J8orJGfXIwxqXhL7HAWb2qpQVGHVQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792448153;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=hT7NVPv9/Qo2RCG3o4cr1F44bSdqkY76pKPgsrWtGO4=;
	b=CZ4mR/1PKgcNATTLwq9kegABliQMhQltfVnyCAqcP+FvNKrLlFw69y71BleBjx9eQC5f
	 MXdozG56G7aT+I/BoLNeDThoV0UYMjplhchqTwrvRNvxAo7EN9ARqw20zUfVvPn22V8P8
	 +E/aZRStOSI7qMWy9RRxJ/ySrGDtAfMe4X7hEUUi16iNrswHkHXSQe30DE9KHlM6buU5K
	 Olrk2yj5heBkYWW7txyYwFfeVlepZeA7f6cS3fcPcfw3byGw4ZEEkAynTdm2LEo9E+Svr
	 xE9lOE31So436m5967QZhbaxyTlgkp7qZ9q9I+2aYF3GMiT6a7y9/EHoTvDmaWOaKyQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="nsw8yE/m";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB98606A333;
	Mon, 19 Oct 2026 22:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nsw8yE/m
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792448152;
	b=0+04bMhfQR0zmyiEa1OOXuJmPbIcbIPTtjtp1YQCXUacOuvQj3KRJpNCIlzRnump7bUL
	 YWDK43vV3K/z04e5v6azDza8zquWJsaLRVISR3jTueannH4+XRjTNCiwtsJs3EV+aMAgZ
	 UG6tp0DfSfRQoBJt565ERiAd9AM7Z9cMBgms+cGhbhocGddIn+3QzXLfcXiHdzJNcuLk6
	 Ci+q8xRmqNXjRRU8zhHA03/jKgaUuRKW2QqiOo9LHTcZhxtk4UnfH1TKO9NvK8FnXkC5g
	 EqhelzvCt4gXnU6rZR4Biu0nTfnx2Dg6VrsdLgb4ojNuXi49bKo+6JZ8g4wUZbN6nYA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792448152;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=hT7NVPv9/Qo2RCG3o4cr1F44bSdqkY76pKPgsrWtGO4=;
	b=hvKB4Kfgsk8xce7i6BNx4PcgY0H267qpz+dJCfyYypybqDwt4ieJx+RdX5FG5PHGy6OT
	 lcgNm3Fj7wI6kTIJszcY9WMl9LtP8T9lsW03D/yMVhO906Mpw4v2zKTpQLH6fkmq9BUwY
	 Rkufi219tIL4iW3cBWNNZJWnWVYQWBUPRlducENBZfWLr9FpChqaH3HVW4Dk7SZE/6/Om
	 A65Di3DyVkJdfaqroUtks/3phA75c46uumWiOrBV1DS0xN8y0WqotmzMVMWVNyNhGAJ/p
	 48SZYiTFOJbxoqLa+fcJLsKZTQ2aNpeV3ifNUTIbOPHwIKPQJN5omndLCELfGLEuoUQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id DFD741F000C9;
	Mon, 19 Oct 2026 22:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792448152;
	bh=hT7NVPv9/Qo2RCG3o4cr1F44bSdqkY76pKPgsrWtGO4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=nsw8yE/m2GQ5X9Yr9EzN0YtEhQGhKDfcv9/sSx5jIrTI9RAAUL9m877teX5VPNkpV
	 dgJRErocbM1MSkoADhot4+pXb1a69MQKnry3/DDotkzQC2qqNE828L1EIAJ+wyNI9c
	 Slxe9Kk1/W0iKqlySYvnSt6h/QKnAMAD0LV8eZIsZqNPRMfcQW/f4BRabDPbybHoUw
	 0rd36/OmiokyNYxGjO3xJ5EYbn+6C4qRlaM6S04EpuSqvnL1qZbOWFoHO4PwH3zx+U
	 8ap2SeSFWH0Y+pmUvMRqPLRZ4DrlmFtQE9joGKZMd95K4bOApkpbeACYXwdIVv81zo
	 eIWzBoWiwEZkw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3609440665;
	Mon, 19 Oct 2026 22:15:49 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 19 Oct 2026 17:15:50 -0500
Subject: [PATCH v15 05/11] scsi: ibmvfc: add NOOP command support
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
Message-Id: <20261019-ibmvfc-fpin-support-v15-5-a858726e178a@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792448148; l=4964;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=9U1Rp9qw7GBQ+XBdV2e6qjMf/GLldIjsj7fz7F7Hor4=;
 b=+GKfKsKyDIj0YrDsA60zXYqxuZYxH0GHFyLRgily3qEldNcL/Ic+fUy0kDvQjl8UA9JFHLy65
 GqggI6VUNYHD2PHWHrKmH/7fRYF7ouMMTPaZ+cHH5JuzKW4omdmrV2L
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com
Content-Transfer-Encoding: 7bit

From: Dave Marquardt <davemarq@linux.ibm.com>

Add support for handling IBMVFC_NOOP format CRQ messages from the
VIOS partner.

Advertise the client's ability to handle NOOP commands by setting the
IBMVFC_CAN_USE_NOOP_CMD capability in ibmvfc_set_login_info().

Handle and ignore IBMVFC_NOOP format messages in both ibmvfc_handle_crq()
and ibmvfc_handle_scrq(). In both handlers, log a rate-limited error if a
NOOP is received while in the IBMVFC_ACTIVE state without the partner
having advertised IBMVFC_SUPPORT_NOOP_CMD.

In ibmvfc_handle_scrq(), also fix a typo ("Got and invalid" -> "Got an
invalid"), add a missing return on invalid message types, and guard
against null event pointers before processing CRQ responses.

Change ibmvfc_handle_scrq() to take a struct ibmvfc_queue *scrq
parameter instead of struct ibmvfc_host *vhost, deriving vhost from
scrq->vhost internally. Use &scrq->evt_pool for event validation instead
of &evt->queue->evt_pool, avoiding a potential wild pointer dereference
if crq->ioba contains a non-zero garbage token before ibmvfc_valid_event()
has a chance to validate it.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 0750e722c46c..6816b8f2ad9a 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -1578,7 +1578,9 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 		login_info->flags |= cpu_to_be16(IBMVFC_CLIENT_MIGRATED);
 
 	login_info->max_cmds = cpu_to_be32(max_cmds);
-	login_info->capabilities = cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN);
+	login_info->capabilities =
+		cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN |
+			    IBMVFC_CAN_USE_NOOP_CMD);
 
 	if (vhost->mq_enabled || vhost->using_channels) {
 		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
@@ -3704,6 +3706,14 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
 	if (crq->format == IBMVFC_ASYNC_EVENT)
 		return;
 
+	if (crq->format == IBMVFC_NOOP) {
+		if (vhost->state == IBMVFC_ACTIVE &&
+		    !ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NOOP_CMD))
+			dev_err_ratelimited(vhost->dev,
+					    "Received unexpected NOOP command from partner\n");
+		return;
+	}
+
 	/* The only kind of payload CRQs we should get are responses to
 	 * things we send. Make sure this response is to something we
 	 * actually sent
@@ -4223,9 +4233,10 @@ static int ibmvfc_toggle_scrq_irq(struct ibmvfc_queue *scrq, int enable)
 	return rc;
 }
 
-static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
+static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_queue *scrq,
 			       struct list_head *evt_doneq)
 {
+	struct ibmvfc_host *vhost = scrq->vhost;
 	struct ibmvfc_event *evt = (struct ibmvfc_event *)be64_to_cpu(crq->ioba);
 
 	switch (crq->valid) {
@@ -4234,7 +4245,20 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost
 	case IBMVFC_CRQ_XPORT_EVENT:
 		return;
 	default:
-		dev_err(vhost->dev, "Got and invalid message type 0x%02x\n", crq->valid);
+		dev_err(vhost->dev, "Got an invalid message type 0x%02x\n", crq->valid);
+		return;
+	}
+
+	if (crq->format == IBMVFC_NOOP) {
+		if (vhost->state == IBMVFC_ACTIVE &&
+		    !ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NOOP_CMD))
+			dev_err_ratelimited(vhost->dev,
+					    "Received unexpected NOOP command from partner\n");
+		return;
+	}
+
+	if (unlikely(!evt)) {
+		dev_err(vhost->dev, "Received null event\n");
 		return;
 	}
 
@@ -4242,7 +4266,7 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost
 	 * things we send. Make sure this response is to something we
 	 * actually sent
 	 */
-	if (unlikely(!ibmvfc_valid_event(&evt->queue->evt_pool, evt))) {
+	if (unlikely(!ibmvfc_valid_event(&scrq->evt_pool, evt))) {
 		dev_err(vhost->dev, "Returned correlation_token 0x%08llx is invalid!\n",
 			crq->ioba);
 		return;
@@ -4285,7 +4309,7 @@ static void ibmvfc_drain_sub_crq(struct ibmvfc_queue *scrq)
 	spin_lock_irqsave(scrq->q_lock, flags);
 	while (!done) {
 		while ((crq = ibmvfc_next_scrq(scrq)) != NULL) {
-			ibmvfc_handle_scrq(crq, scrq->vhost, &evt_doneq);
+			ibmvfc_handle_scrq(crq, scrq, &evt_doneq);
 			crq->valid = 0;
 			wmb();
 		}
@@ -4293,7 +4317,7 @@ static void ibmvfc_drain_sub_crq(struct ibmvfc_queue *scrq)
 		ibmvfc_toggle_scrq_irq(scrq, 1);
 		if ((crq = ibmvfc_next_scrq(scrq)) != NULL) {
 			ibmvfc_toggle_scrq_irq(scrq, 0);
-			ibmvfc_handle_scrq(crq, scrq->vhost, &evt_doneq);
+			ibmvfc_handle_scrq(crq, scrq, &evt_doneq);
 			crq->valid = 0;
 			wmb();
 		} else

-- 
2.56.0


