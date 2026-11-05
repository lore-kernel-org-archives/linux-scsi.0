Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793899384;
	b=sepnJzhh44zCcuDLg2p1g0X0gbyo7qM2H0bcdPeEu8fznb11K5dDWoB7umzfvyHKEUP+
	 A3oPTN7gBi7WBT/oWQYYNrmJc85twIWftS2hKI0OjBszp8Nhb25KWdD/iZwxsdYlxutza
	 7QrIvQizwcnaOubmXdMG7rY86txDr0KuKT8xHcr15lXoi+SVBivqf6u5znejHrJKCt260
	 ObM+fB3HsPhPecls4RIDUt2v+Xsu5h6fhyKwusActtlZAlR24qZxWJOOog4/cX5AjLfV3
	 e8SaSjxt3dcCMcUJW9HdyXQoOBJSnfmF48bEKmB6OKQH1tdWLsqsitfEYGLEC5XyYiA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899384;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=e4LyrNgZt64xR3KrcZFWHOFdeaakWHHtPMgNKePQe1E=;
	b=Cvd0I/mQp/ZhQaX5EpPJzX89zw76Dz2Z3Scp/kMJaz35dqMaOa2OGQd6MLXK0WPgWsAh
	 yuO3rDGUXwHKk7FuOLuoL4qDK/5HmMZyGM5fM7k1YoVAB1z69A51DP4o+v0mOBUwC30AT
	 ffQvu+N8BbBqHGJ8PuUbWSzWeUD4VSem3yfe/1miO2pG6bxViKOLaEQ03KJCjRFZisy98
	 jC41WMBewnY6VUO2sjp56EmnrwdFO+/B6DTAUFOrVHGw7aWTXF7gDQrZWeto94spfN+K0
	 eFR6PPl2touxS5ToSpg04Ff6chrMn1nLNFaBNuu8rxlFZ8BcwfDXl3z1Tqh0whK7ovA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oLPd92vE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80746082BCA;
	Thu,  5 Nov 2026 17:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oLPd92vE
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793899383;
	b=cfxxN3A6vmhZk8Ut2b9gzGsMrQ4oCwEj2pdfxJ6Lf6sMQ/KoicmHn8gsx3UYeOjeIO61
	 Fx5g+Guq303/CT0j+RHZmJn+yywMqbM9lP0mXv9qIsWPdIGjoqbNRgdjCO5/AQZmVtWfk
	 9IlNGqZ0Z6oXtvf6FbwEcM0pxL7W9kxEVPSPC0WAfYZdMm7Hi6tWsHl/LJmujE1Fr44Zs
	 ArMiWaXLMpnmgHIr177JZF7ZWDKelsvaELwNeHuyNnKjuZnd572JrpUZreX546LONGThk
	 /BtHdepsCYvvGjF5c+/fxK17a8jfymVNg1gxFuNp9vW6CqHGLXFSd9O7Z7RoApSGLdg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793899383;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=e4LyrNgZt64xR3KrcZFWHOFdeaakWHHtPMgNKePQe1E=;
	b=xFESSuBzSCTpFP5OAYUW/padnufT5RJr2NHBl5q68w2wwALmgLXGstDKFIa1c6Jg4cGa
	 YN2nWDRfx5OfL7haBCC5G8KuJuEHulN1Tuc2ZlOMKIBlZWnA+YtuLURlM7qaJ8Hzyi4Bo
	 qwALb1BARycQ6mj50GRYU2HPXag9fczlJofcBxo1nXyFRMJB7qgr+UcKRbp8IqNU7Qysz
	 8fAJ3+iUqyW4VIOglBIT8fHQ+10oD2qO8cjz9XavmzOAjicHXAHyt3Tg2Z1gAHK2u42sy
	 64v6EBn2rGJppl7M87P+cBpo01xIIsAOlb9xv5k3hTspeHyGBdRisqj6E+Nus0Hja4g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 882881F00A24;
	Thu,  5 Nov 2026 17:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793899383;
	bh=e4LyrNgZt64xR3KrcZFWHOFdeaakWHHtPMgNKePQe1E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=oLPd92vE16l6Ux0YlZJNru5l3vYf6Hk/RI5nV9IT7R6MSLMOn8vJwmrhNMilsEnVE
	 gPzzOW8plRuphflUhq/5puKZ2qTA9jXeoxWjEPPUY2fGhnZrwcZTD24LAETJwqOmnD
	 SsjfhCOqN0DCOzRiWu0J/H37bNDwjHmurCyxiYzRyQRbHYRgz3tNwUWWq7XeOfQ2dw
	 gS9rMqRlDtq1x96P3++um7aXyz4fe7shwt19v8seZ+XFu9YyUZN0JDTQPVyRx4/q2G
	 4zVvnjfxS8QcwwrDqLIDHJaRw9ZNqObBOYuywE8/C27WDWdgbwec3uH5Ropt59xTrA
	 PBIxPpeGeavRg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 95C8B47386;
	Thu,  5 Nov 2026 17:22:58 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Thu, 05 Nov 2026 11:23:00 -0600
Subject: [PATCH v18 07/13] scsi: ibmvfc: add NOOP command support
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
Message-Id: <20261105-ibmvfc-fpin-support-v18-7-d683b74736a3@linux.ibm.com>
References: <20261105-ibmvfc-fpin-support-v18-0-d683b74736a3@linux.ibm.com>
In-Reply-To: <20261105-ibmvfc-fpin-support-v18-0-d683b74736a3@linux.ibm.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, Dave Marquardt <davemarq@linux.ibm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793899377; l=4964;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=12s3yvKM2ln2h1W8cSWuwGEtumFWqMqdS2nMeA7r9ZE=;
 b=88X/cPZkwa7DaSifd7v2VZzH3AH4xUk+bBduxBqCkdcOb8R60R7nn8pRPPNzVJ76eZtRO7iTj
 6lSsylzz8lKAXFkK9/zAsLdtneGdDzqteVDRudQNOklKSDLcFrm2MXu
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


