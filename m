Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793655536;
	b=O1GF1QNqOd7yY1qsE1ZGPhOQptGnnnX/+ZsST5i8zQ+4E6zMg+5dd6zWNJek3MIBiMV8
	 5T/B7iyN6Hl2kBZRdHBZPv9Gy0/QIxp9OwKz9LaedJRILZ5yxNxoYjgOuINskzMNozaqq
	 bpMyfiTNoTm/PEcM1zGv/lVO/lYi6JudqT3exF+LEvpJiJQuu8vL9Bo5/862gPBmC5gLv
	 fHsyyAlW5B6RzMn9yKfCFGW+QBHDO+hPZu5N/quXLd8q7gjWyCVS4tCUmqV6ARFcINOHO
	 PIEK5tcmRoKTgCB6CNnZtXk8ulTjBcqjX0kserMdkYSIEVHyqF3L9RhPuI/Gx7/43eA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655536;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=e4LyrNgZt64xR3KrcZFWHOFdeaakWHHtPMgNKePQe1E=;
	b=DEYfjh197zZrZDqBGckP67ahXqCVEgJxUkBUO5QrIg7imBaot2C9ke2UmUtpp0fGehHq
	 9Bu5rfswjwk+RQTI+9do1RI8DQNEtvipOTLHMQs71OOXpDlfAyFYZGre35f+fiYpC+oxC
	 GVxMJJoGtbV8rTRAZO9DgF8x0ifjw3nE0wymq3JT5jE65HB6Slmirvk6r5ev8JeQ2jfQK
	 sc9l0YXJ+jIGW1Gw7iLeW5fnk++b4LDH4/0j2vX3RdYQ0CAjK+gBhnjPcjzRBBkqWkwp3
	 tGaYOFex2lpFDM3lziPe3U/f8fB75PP/YDI46fj2pIfEEFL6CiyvybrZ1WJu5OCkkNA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I7UFUbIm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A260A606D80E;
	Mon,  2 Nov 2026 21:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I7UFUbIm
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793655535;
	b=zh3UOJO2if1wVb88LsLF4EMY6Xe5gvJ+4WjVHjEfQeLwSPwZC5fh7vbv86Y9YntJWOG/
	 Q0kPTNo8w8chEMjIZe6kcVNlGZiv9RMySw5Z7u1BtUTdJtAbSRd0FQykTUNstKG1jVqLW
	 h02wFxmTi0m0KPqyrECWFLx52A23DXuOkhW5eyYwinTFpCrifHvGTxOkMMKrO+uMur41S
	 gdBnC0eCvgr8kg2tkFjlePHKpIou9AoWcfyVNXI1YZc8BubCg2iZ9IVBYcf3TLH87P3Wd
	 MXdBEK2XH/dRYwSM+ytXN4WP84sa4uqzxJ357VTN0cpCvmIp+CMWZHCbuBUm5cleC9A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793655535;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=e4LyrNgZt64xR3KrcZFWHOFdeaakWHHtPMgNKePQe1E=;
	b=obJDZ/oplT4MVSHlAqmVuJ+C04MRL09E5SMks6umyU9PCptYCB+OMdxHuo93t/1jFChn
	 TSBlqwjn5elhdjkrNJZlGn7nx6qYyeTEHqMrz3yMU22RUD7Ffe6dMPJvontJwYCST0X+B
	 k3yx/3XShKEVB8BM5X4F2VOgooPaO0M0/MGYLlVPTRj7UiSO4PqwnqaHbW4bmWdynFkqg
	 urGAFOpMWQ/CgZZDxOZWeOp53UVNfg5bODpuuhrhHcv0P/Y+PGyka+SqNqyOGCifbiqKB
	 UbK8CV1PX7LQLK0ikXIhj2k0bVcQdr8HLPtYyjCkQ6ncigoW0ZEwUlu33AA6CV8LMUA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7AAA21F00A1C;
	Mon,  2 Nov 2026 21:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793655535;
	bh=e4LyrNgZt64xR3KrcZFWHOFdeaakWHHtPMgNKePQe1E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=I7UFUbImijaXjJQ3ckfJMwfAYdrZHRV0+yrqrrkwmkAmBUPmdVjfX6Q+1XSlLnZaw
	 jP9cnWKZBXRUFRVrzzqs1p8vikRewR0bCyZ9Fc0H3hCVdf+oZm96ZA3Y2pyzk190Ut
	 H+p7YvIAPRqRfaloqMHvFTkwKdBUkkDXFR/oh1rj4a0MOFd/BJMc+McCyaSrvbA2hM
	 GQD8LmZT4KNjuEys9xeDwBMAA3R0ZzlZYRkNUGuqeKLLCPJ6+EVMsY8kiQQrliirIp
	 k+Gos7lVxaivuV4Ilz7ly/UGIONTNSop5QBM+Q5Ohe1oGWgj+Yz54ydRBXkoEjtvI2
	 sCk0r8Zf2KKZA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id BA22E466AA;
	Mon,  2 Nov 2026 21:38:51 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 02 Nov 2026 15:38:47 -0600
Subject: [PATCH v17 07/13] scsi: ibmvfc: add NOOP command support
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
Message-Id: <20261102-ibmvfc-fpin-support-v17-7-9ee5f195ac91@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793655530; l=4964;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=12s3yvKM2ln2h1W8cSWuwGEtumFWqMqdS2nMeA7r9ZE=;
 b=SAVDlVpCt54Fanbx8u5OWqP48AoerwWjdsN6AOFsXoSr1VoZymq5t2RHLWJY0bE6SJrOIW0yg
 p/UOZXzO5JWCHJktJ77RgGzdLjs1qR6ABGHMAHaKzAaPj85mNKhYo7v
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
index a87beaeca13c..b9b571db4464 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -1580,7 +1580,9 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 		login_info->flags |= cpu_to_be16(IBMVFC_CLIENT_MIGRATED);
 
 	login_info->max_cmds = cpu_to_be32(max_cmds);
-	login_info->capabilities = cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN);
+	login_info->capabilities =
+		cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN |
+			    IBMVFC_CAN_USE_NOOP_CMD);
 
 	if (vhost->mq_enabled || vhost->using_channels) {
 		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
@@ -3729,6 +3731,14 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
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
@@ -4248,9 +4258,10 @@ static int ibmvfc_toggle_scrq_irq(struct ibmvfc_queue *scrq, int enable)
 	return rc;
 }
 
-static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
+static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_queue *scrq,
 			       struct list_head *evt_doneq)
 {
+	struct ibmvfc_host *vhost = scrq->vhost;
 	struct ibmvfc_event *evt = (struct ibmvfc_event *)be64_to_cpu(crq->ioba);
 
 	switch (crq->valid) {
@@ -4259,7 +4270,20 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost
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
 
@@ -4267,7 +4291,7 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost
 	 * things we send. Make sure this response is to something we
 	 * actually sent
 	 */
-	if (unlikely(!ibmvfc_valid_event(&evt->queue->evt_pool, evt))) {
+	if (unlikely(!ibmvfc_valid_event(&scrq->evt_pool, evt))) {
 		dev_err(vhost->dev, "Returned correlation_token 0x%08llx is invalid!\n",
 			crq->ioba);
 		return;
@@ -4310,7 +4334,7 @@ static void ibmvfc_drain_sub_crq(struct ibmvfc_queue *scrq)
 	spin_lock_irqsave(scrq->q_lock, flags);
 	while (!done) {
 		while ((crq = ibmvfc_next_scrq(scrq)) != NULL) {
-			ibmvfc_handle_scrq(crq, scrq->vhost, &evt_doneq);
+			ibmvfc_handle_scrq(crq, scrq, &evt_doneq);
 			crq->valid = 0;
 			wmb();
 		}
@@ -4318,7 +4342,7 @@ static void ibmvfc_drain_sub_crq(struct ibmvfc_queue *scrq)
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


