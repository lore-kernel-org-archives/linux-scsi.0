Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795537024;
	b=iw/P7WyBLHuHeg/xitbNteOUy4/BDZ7GIUSaMdQu+hZTFQ+qIy1Tqm0gy+Vrhfdlt0DJ
	 c5hGY5OMYKaBQzOtf2+ipZiotidaKr3ioVr9NPqjUJgTwqiHmIhb/bgwgugy9z08VLE5y
	 r26AzlU2R388ZFI2ruPV+dZb62K0z3SLRWng+ePoqIkjkn5SSAEijycqDfp3rLaJfR52o
	 kcKJlDNIKU0BO93M/RTCnnWbn3+l76XfZnf2eZCPiKDfh2Zbrxp5g+1/t1AN0NL+gn3L9
	 HAeaOZwM2VuscyGH7D1KjYT3tYGsVZf3OWbON4QqPomsJTtHHcdiiZbKTChbV0CYw2A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795537024;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=OFykWNXoR0xowbonHUTjWkHYzNjImDV5PSCRJVbKTBY=;
	b=SmxrANw6xwwkdajceuFqNek6TqpvwplZqZsoy2iT5vj98e4HdRrZ89HrhK9MYFNKAWVW
	 Tj41D20U4K5HAI+Ci7tibWRCtia14Hgi0W3SoZ+Wgi6Agb5nMnDLoHVpSu2CWpsleee7E
	 pQ6+Ba7fSe8gE0JAOzmPIlz4aVyMiGrADUA4TJ1DYWzmBQrLsAR6yAkt+Jbogl++pr9a4
	 xa9SFMLU7PHT+1hAvuQLlh2BBSNtFUI095fgBml+FmfU3DXbtrd8hBs5q3gbCqmfttNQO
	 rR3ArmsYWQFqtdiIfQslyi0Jjrpxr1B2Deu+r1HQdTq8eBWyuViPJ33yYyZcOPVv1xA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NR7rYUgz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7DF606A685;
	Tue, 24 Nov 2026 16:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NR7rYUgz
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795537024;
	b=xsMd6nvt744WMof7Zob/mSbLhQ50jQMl7K+Zm92BY0X083bfo9QwFerqRWDPp6EZxfaQ
	 h/tNFzxDEDfjT26dY5y2tOAyQUZHai0TffXQSgCa6wkJjb0UEPbHu90XN6dMq4/v5c+hj
	 6QoOIjfM/KMx79cPRTOaKiReACOdTl1DT/P7oAugXQpFxd3BsuZvbMOIvd8Y4DSN1eaCZ
	 ANbsU5PSaDV79NGVeeECtw0DHc56sKvEogLBdHG2RPTkLUG7GDlVPzXzHnx1c2UavjsDO
	 92qI76aYZD8h+A1X8qXM4WuzAxtlfFrx0QZjQQfjh+2uNzUhwNOWXUNA0ja0YRX3oqw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795537024;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=OFykWNXoR0xowbonHUTjWkHYzNjImDV5PSCRJVbKTBY=;
	b=NLuJXazhpL5UUkpRyfjVwKjumxe3hZrJz9Apx4F18qNQYmMK8wBAdYvEbEcke5p0jRqR
	 e+84mTxRRnQAyqfiv6gvKGsDk5tj/P6SR1kjEjSquBfZ71lN5C4eQejToKvg9RhOZj5SQ
	 1Uo/giraREpSqAT/1yoV0vMOVVzRMRIQh7Z/rUAL4MUV+YQCk5jpBHObOPp3bSit0+rWJ
	 tFi7Z+SbzEkRi01wZuIltv1kq2a+NTNxcZGN/CYP0zLcMUL3CH9c4nhp/5HGIDexkXaLT
	 mf0i1mZwFYLL3PGkrlsRyZbNRRaKevw8/tvu/eXNO4zOJAUDbNmYY7r5FDCwjqMzOSQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 41B8F1F00A3C;
	Tue, 24 Nov 2026 16:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795537024;
	bh=OFykWNXoR0xowbonHUTjWkHYzNjImDV5PSCRJVbKTBY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=NR7rYUgzvgs9uOB+FW42oaXuvhfhke7KGeoqixDqhfaYRPY9Zte4+TMdTnW0SZWMU
	 NWS5iVbKF7hl8d/5sojLQpE9eORnOOPRHUQYzgA08MyRRG6/uIJh0syURW3InkWXwa
	 woohtHseeOL1XaAaRGb82naeUq7eKW2k7C7G/+yc7YtPJPJNGejbhWLzyw9VMtSzcB
	 oLI9VRoh0ivxioq+yW5NWnikp5QcyUxlb6pbNKNf3YDjyFRuORKtFbIbns6MRWEVyZ
	 Ok3t4MxfqrnHsqaZw/im5ceKfJl/cwmmgdoOotB1M9QBHxon5ytkKMtjqp5tbTF+ah
	 EjTHrAZ7CypLw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3B6A94CAD4;
	Tue, 24 Nov 2026 16:16:47 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Tue, 24 Nov 2026 10:16:48 -0600
Subject: [PATCH v19 07/13] scsi: ibmvfc: add NOOP command support
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
Message-Id: <20261124-ibmvfc-fpin-support-v19-7-2aaffe5fe7d2@linux.ibm.com>
References: <20261124-ibmvfc-fpin-support-v19-0-2aaffe5fe7d2@linux.ibm.com>
In-Reply-To: <20261124-ibmvfc-fpin-support-v19-0-2aaffe5fe7d2@linux.ibm.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, Dave Marquardt <davemarq@linux.ibm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795537005; l=4964;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=LnEyUGO2BjT9LfyE1wdcTKE18GxtKfNuL4n39GgQfuY=;
 b=rzHix6kUjOqtA3vAd5l4x8OiaVKZFACHtUC1et3kj1TUq5yl1bJMXo4mw3mSOcqvCqHwSHUjz
 j6pJTyfcTKNCYQuu9qKBFQxB0kOh0svYYhUcOejKK+a8AmDhvO1bqXE
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
index e797ffb4665e..ea3bfc010270 100644
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
2.56.1


