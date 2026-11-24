Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795537030;
	b=sDRCoKvvHExjyfY8m89UiEJpMajNt5Ruwgbzyxn2v7rg1VhTJ24kAjbDZntx4uR11/W5
	 vd6sDEreM39zTyw0XUjA7f0AgniJN4Z7dw0ruM/cTIwQ2GFs8OThVvGNzVCHhvRDOPBUo
	 09OAFYJTWUG62fnfpRkxQ9jV0/ZBiAROR0U3gRKQvFb5Ws5Tu0kOvNljfY7M1ttkk3kY4
	 Uhebeyc8V+0vfVjzXPp+DQh8b838/ZSwd/5pQY3vleUDiQtckoRxe5JV2CBnOttJJL4LU
	 xepSZ+MH9Gw/HixA97rwBRDj/ytVnt19/M84MBPmV69AjZfESekdgxdR9fyGHoOD8gA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795537030;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ZrUfi/4xE4yRryePc8zCC+fsB3eBluZlSWJBRvtH1vY=;
	b=uKCl/uh3nnSPM2CJhX5sOPN17tB00851gd/330/VZH2SJb9KMdPlbG/HYH687VbUpq9t
	 rS0zwjKp6+7pcDgmGwcPh5Q4jRZb2UomLyGD5nF0jrrkltK0BxV9cp42lakv1I8C7HoCI
	 1VPIJft4Qr7bTTJkRb64K34dEw2/y3GfuqARr/sbaYKqLoVo3IsD7DmLe1DvLtIBdUwcj
	 f9SaCLkXPCqjB+ElC9kyGE4LcI1I025O4QfvW56iQLPrZgNSzW/RIYOmrAwx/kxCaVGCM
	 g0jcZjOcYftHJA6kgkGjJknzlJ8GP7njOWwnOPlq9ew0QX9cSQKpJPMku2223fQ2ieA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ahA407r2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A759606A69D;
	Tue, 24 Nov 2026 16:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ahA407r2
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795537030;
	b=qO1nf59+DFRIzDUYG+9V8hnEVlRi+GNY3A84sExak7gLiqZ/YLzGgPbQF8ZrQbfFY1R2
	 32Z1bPaq4b73XKyoYbwj9h069x0raZj2ruSeBhw0+q+PlfyLRsO7vlcquqB7CgcVuQgWH
	 v6idbcuKpD++zN7IjmsIJXYljChh4b60NfLE10yUC83EAGTZ0Q7E/0R9AvZXLFzteB6Zl
	 0wHU3hsu8D+UhXzPB5cXe06aY3WE/HlH8trcJiUJU7WUul5xdyippbcoLCBLe6rvbxgmL
	 wSJLip3nD0pEIunn4d7y7B2pzo5TKEYPtft3uyS9GoJ5Q6DrcaWLKFVuIZIJ2ly40ag==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795537030;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ZrUfi/4xE4yRryePc8zCC+fsB3eBluZlSWJBRvtH1vY=;
	b=xpAH+2yXWO6GZCUi6IWJ0g+njBmDZbJmGA1YQeYwMfSP9YIuJst0Qolls0MZn67+z2nT
	 2i3nZs95m51BqMtbNcHMKHpMuBDXGcpG2sAMgdYmCuxD2hQrTTu2J+L68vizmPxyWUz/H
	 w0UF7aAsrUNu4H8fZe+dBy+5m1Xud3SkjD0yrDlJAS3EtDLVw3qcjiK38eYpgN245dXag
	 xv6Urtz1InwhR9AN/TgwswmG6qhh1nMX7VUBUdI+8gu2yECBhAFhCRowxSe2wuOTW9ddM
	 WHvDTAgypbLpT9LdxWADZJW3torH8GM+ksl9p9UIk0YDas9d8smw1XkEpChjweISGqQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E39E51F000D0;
	Tue, 24 Nov 2026 16:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795537030;
	bh=ZrUfi/4xE4yRryePc8zCC+fsB3eBluZlSWJBRvtH1vY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ahA407r2Q6N5gfS1bEps4pt2m1Af87+0wkuVeyjWPHELYWseBsWE1xyb3XPeP5qZ0
	 +o6USQ9T98p2/Voc7eMQwtyu96Mq7/eUbKzJ9Mw7hmpU+a4AOF7igrGwszh683qkUW
	 w8dt2Qwru8UCovDmEfQOOX2YLeW7bSk9Bqu8gRxFn0C2TcxX84tJdyit7yj0pQ2Koa
	 kydJVun1VsPanZVKuEleE7/am2ByTgBa4N3JOX+XVcqVh+D0FnosWkFe5U9Oayfx5X
	 p9i2//ZgQ42J8JOLMxMqGI35BVwZXJ4JuVdblc6OYnS3puijBfK0Iybjt6SJFqDZzR
	 wnOnrwJy23cbA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id AA1E34CAE4;
	Tue, 24 Nov 2026 16:16:47 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Tue, 24 Nov 2026 10:16:52 -0600
Subject: [PATCH v19 11/13] scsi: ibmvfc: extend channel registration for
 async sub-CRQ
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
Message-Id: <20261124-ibmvfc-fpin-support-v19-11-2aaffe5fe7d2@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795537005; l=4601;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=ZxuONs3mfa9hV/g9VClPHCsCpHjcPivaU4Joobpcqwg=;
 b=4miBavlkJq92NrUKeErwhmlkYniRbz2H/jplyk1TVd0yoCL3fd2lFz+dfuYb0RLWZ2F3H2vIV
 zJ4vJUSJ5QUAFf0NuCaBj9qb+MI0tdJdBHPL1DbHCHrIqloM6uBQPA4
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com
Content-Transfer-Encoding: 7bit

From: Dave Marquardt <davemarq@linux.ibm.com>

ibmvfc_register_channel() previously only handled SCSI and NVMe
sub-CRQ channels identified by the channel protocol (IBMVFC_PROTO_SCSI,
IBMVFC_PROTO_NVME). The async sub-CRQ had no registration path through
this helper, requiring separate handling.

Add a new IBMVFC_PROTO_ASYNC protocol value to enum ibmvfc_protocol and
handle it in ibmvfc_register_channel(): the IRQ is named
"ibmvfc-<addr>-async<index>" and the handler is set to
ibmvfc_interrupt_async_subq rather than the per-protocol
ibmvfc_interrupt_mq handler.

ibmvfc_deregister_channel() does not depend on the channel protocol, so
it needs no change to handle async sub-CRQs.

Remove the __maybe_unused annotation from ibmvfc_interrupt_async_subq
now that it is referenced in ibmvfc_register_channel().

Include the channel protocol in the IRQ mapping and request_irq()
error messages in ibmvfc_register_channel() to distinguish async
sub-CRQ failures from SCSI/NVMe sub-CRQ failures. Add a kernel-doc
header to ibmvfc_register_channel().

Set scrq->hwq_id before calling request_irq() rather than after it
succeeds. The handler can run as soon as the IRQ is requested, and
ibmvfc_toggle_scrq_irq() reports hwq_id in its error message. The
failure path does not use hwq_id, so no cleanup is affected.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 30 +++++++++++++++++++++++++-----
 drivers/scsi/ibmvscsi/ibmvfc.h      |  1 +
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 50c225b22b8b..5e8b25673ff5 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -4551,7 +4551,7 @@ static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
  * @scrq_instance: async subq
  *
  **/
-static irqreturn_t __maybe_unused ibmvfc_interrupt_async_subq(int irq, void *scrq_instance)
+static irqreturn_t ibmvfc_interrupt_async_subq(int irq, void *scrq_instance)
 {
 	struct ibmvfc_queue *scrq = (struct ibmvfc_queue *)scrq_instance;
 
@@ -6944,6 +6944,19 @@ static int ibmvfc_init_crq(struct ibmvfc_host *vhost)
 	return retrc;
 }
 
+/**
+ * ibmvfc_register_channel - Register a sub-CRQ channel with the hypervisor
+ * @vhost:	ibmvfc host struct
+ * @channels:	ibmvfc channels struct containing the channel array and protocol
+ * @index:	index into the channels array for the queue to register
+ *
+ * Register a sub-CRQ with the hypervisor via h_reg_sub_crq, map its hardware
+ * IRQ to a Linux IRQ, and bind an interrupt handler to it. The handler is
+ * selected based on the channel protocol.
+ *
+ * Return value:
+ *	0 on success / non-zero on failure
+ **/
 static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 				   struct ibmvfc_channels *channels,
 				   int index)
@@ -6971,7 +6984,8 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 
 	if (!scrq->irq) {
 		rc = -EINVAL;
-		dev_err(dev, "Error mapping sub-crq[%d] irq\n", index);
+		dev_err(dev, "Error mapping protocol (%d) sub-crq[%d] irq\n",
+			channels->protocol, index);
 		goto irq_failed;
 	}
 
@@ -6986,6 +7000,11 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 			 vdev->unit_address, index);
 		scrq->handler = ibmvfc_interrupt_mq;
 		break;
+	case IBMVFC_PROTO_ASYNC:
+		snprintf(scrq->name, sizeof(scrq->name), "ibmvfc-%x-async%d",
+			 vdev->unit_address, index);
+		scrq->handler = ibmvfc_interrupt_async_subq;
+		break;
 	default:
 		dev_err(dev, "Unknown channel protocol (%d)\n",
 			channels->protocol);
@@ -6993,15 +7012,16 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 		goto irq_mapping_failed;
 	}
 
+	scrq->hwq_id = index;
+
 	rc = request_irq(scrq->irq, scrq->handler, 0, scrq->name, scrq);
 
 	if (rc) {
-		dev_err(dev, "Couldn't register sub-crq[%d] irq\n", index);
+		dev_err(dev, "Couldn't register protocol (%d) sub-crq[%d] irq\n",
+			channels->protocol, index);
 		goto irq_mapping_failed;
 	}
 
-	scrq->hwq_id = index;
-
 	LEAVE;
 	return 0;
 
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 86b600ec57c7..f77966c85b0e 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -839,6 +839,7 @@ enum ibmvfc_target_action {
 enum ibmvfc_protocol {
 	IBMVFC_PROTO_SCSI = 0,
 	IBMVFC_PROTO_NVME = 1,
+	IBMVFC_PROTO_ASYNC = 2,
 };
 
 struct ibmvfc_target {

-- 
2.56.1


