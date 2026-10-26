Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031159;
	b=BMl5yP2hSfOthz1W8RPo12Avh2iJYqLVe2+YfGIFCamqsuKZTtGYfkTIJn4aMarkMPkT
	 Pt5QSCcM1v9Y33wrggytMCMjOYT7yRjvqUg6JDFVQLjuR0a+ysneAEzIjBne9z6zyeWR6
	 38tYZSvIdM8faHwQDO8A16G0W6V2G6n0yB6xuQR1o8kWPzpSboYJq37DpF0l0pMQDpq9v
	 NAVsRHUNR4Vm7EZ9qyjGQFq98woOFB4yssdtzy2cOjZgTNcLIv+b0XKXyZlnbdBLTCM+N
	 pBBYBa4tcWKobcNK7Ajt0/muzKdp8Z3gZPzCTN05YpsKP2KdJs8umzpfA1+9P8COqYQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031159;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=F7Npv4/6BVdAZSR8mVUnSzo51kSho3k18+5Nnsi5eBg=;
	b=pcumsJpGNewwmakxdcMjhzRLZmbYKPEK8W7rI6mA4gOz+UgURtlG4B0iT9AOzXIK/BVf
	 LfS2s27EUix+ExXJE/Qhedphgkrf+3qQDaDHz5evB2tFxvukPicNt2e/A1x7/fWMaA8HS
	 epSETL/GM1fzKZALgbggvj02y+Bxqysrd7gIZgDQoK6dcDyYcWm1RemuC+JSR3FK/cCyV
	 i0HjdEAez3ETKnVYzHr/2O0Utp4GbUbgPAVgT+HHmlSPUh/hQB9MGEDIhm1c0hP6Dczw6
	 hpUQ3rfpwLTb8qHsItaUgSKwVzwVLz2DDQjFR6zWApYZypJJMtVpK2WgLBA2aOcKf1g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="F/aH+EZa";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22000606A336;
	Mon, 26 Oct 2026 16:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F/aH+EZa
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793031159;
	b=As89RU1qNWwGzDy8mkS3Ppjbt4Ej+6E5MbgSdoKGcoqUZ4iIq+koBx7v4oCeYQT1nRVW
	 yclJWoKXiirhxtwSoaoMCytXBTpV7rINHXQ43iLF2ZAldpOHcnYr7XJGo3zFn3kGYkl4i
	 xRWPlEdb4Qp5v4l2QfAApT6SGkGxP6l/2MyY6IsYfwPl2u5zdsoCKuAVeRdyDhc4cVG5R
	 PtLq1lfp1vtQClZ1Fw2SNqq0JMDrir0ha8L1lQHKHHCiMGUk0harMMNMRbUIvL8/C9I0T
	 VzDY6gHMxhjnjJzuMyqp2OJkjWopYSGmBb9Btm5D4bc2Q/9mi0+sSaIL6u+yLVq6KIQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793031159;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=F7Npv4/6BVdAZSR8mVUnSzo51kSho3k18+5Nnsi5eBg=;
	b=Qq/bWkw17ijXp/nxtQ539TvXihHlrABlRQJPpO0p9lwfzMW2q4WUST7HuDTxectwpvTp
	 mn6VqWfUl/+VTzxCXHSQt8Z9D+rnOko1gXPgTkSDPjL+hr1cQgZBYe7+hvYdOnMDYZUWS
	 UVOufmU2+gbumAvzIk8WyPZQYL5T4mVRtYKW73hWln3x9N99S1uPhEpckVY5dpZzFyZhh
	 DqQce8gF/xD7swHi0szAonTkWkSwYahpfFnNa7w506o7NEXd7qsgkyuEkf9A0xByvWN16
	 ZXHDmz5MTwwk91/skllgORMXPaluXZF3EwA0fahKgCoQiBuCa8N78kugJ6gXn06b41Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 0245D1F031E5;
	Mon, 26 Oct 2026 16:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793031159;
	bh=F7Npv4/6BVdAZSR8mVUnSzo51kSho3k18+5Nnsi5eBg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=F/aH+EZaF4B6S4FRJXJ3Dr8CpGwa+a6pbjeCwfTYxuo9Uxksk7JhA85mX34jGM96w
	 vkiKfSXeev0zzu8Eu0ENzhENF45rxgGnI+2Q2Aay8A+GJDOTpc0sHNEb9AvqcnohMj
	 TOwqpuQM6ziJvDARWHQYO+Um6zpvCRR2wg8xf6baDL4BfVgOPZ5vlNjUGwf/aYM33A
	 LajVTK1heXgUQYo3ZocQ3ra2ADpFDn6cbnIk6NikblvBCOoKUGAGfattygMbDfwdmp
	 lTlsM71gbDGVQD65EtYq5BLADWehSgpIb1N5S7FExKuHIN+zTVcAfA5HZJyS0NWVQ5
	 mC0ezbCjuVlWw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6F43D44D99;
	Mon, 26 Oct 2026 16:12:36 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 26 Oct 2026 11:12:38 -0500
Subject: [PATCH v16 06/12] scsi: ibmvfc: add NOOP command support
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
Message-Id: <20261026-ibmvfc-fpin-support-v16-6-a900aa657ed5@linux.ibm.com>
References: <20261026-ibmvfc-fpin-support-v16-0-a900aa657ed5@linux.ibm.com>
In-Reply-To: <20261026-ibmvfc-fpin-support-v16-0-a900aa657ed5@linux.ibm.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, Dave Marquardt <davemarq@linux.ibm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793031155; l=4964;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=YGRbIUdNWWyi7nKL+Hl5vEf39hZjfHe6uwnKRRlVDEE=;
 b=RbADDqKxCVwXVunO8QitHv+yesB1fToy6qFfL1zysiQjtc2xNJwmY1G2tiNi27vd485HI5MLw
 0KdUtQRfU/SDzXR7HtU0+NYo4G31Kp9mpJ1+U5loRDSULU/BN8sMHNA
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
index 1cd39d36edf5..b52bf7863b2d 100644
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
@@ -3706,6 +3708,14 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
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
@@ -4225,9 +4235,10 @@ static int ibmvfc_toggle_scrq_irq(struct ibmvfc_queue *scrq, int enable)
 	return rc;
 }
 
-static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
+static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_queue *scrq,
 			       struct list_head *evt_doneq)
 {
+	struct ibmvfc_host *vhost = scrq->vhost;
 	struct ibmvfc_event *evt = (struct ibmvfc_event *)be64_to_cpu(crq->ioba);
 
 	switch (crq->valid) {
@@ -4236,7 +4247,20 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost
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
 
@@ -4244,7 +4268,7 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost
 	 * things we send. Make sure this response is to something we
 	 * actually sent
 	 */
-	if (unlikely(!ibmvfc_valid_event(&evt->queue->evt_pool, evt))) {
+	if (unlikely(!ibmvfc_valid_event(&scrq->evt_pool, evt))) {
 		dev_err(vhost->dev, "Returned correlation_token 0x%08llx is invalid!\n",
 			crq->ioba);
 		return;
@@ -4287,7 +4311,7 @@ static void ibmvfc_drain_sub_crq(struct ibmvfc_queue *scrq)
 	spin_lock_irqsave(scrq->q_lock, flags);
 	while (!done) {
 		while ((crq = ibmvfc_next_scrq(scrq)) != NULL) {
-			ibmvfc_handle_scrq(crq, scrq->vhost, &evt_doneq);
+			ibmvfc_handle_scrq(crq, scrq, &evt_doneq);
 			crq->valid = 0;
 			wmb();
 		}
@@ -4295,7 +4319,7 @@ static void ibmvfc_drain_sub_crq(struct ibmvfc_queue *scrq)
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


