Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792448153;
	b=v/Fg++VqUrT8Rzu6i0auQVTxzYy7rIL0wIsM66vUxRo5z1t2bcbYvng6HZsVhSDdalkj
	 ednXnW+u4C+4hNmFHtcn3IRP720oPCgoCkIR8P9wxin3CasQnQUUaYP5LAUA7gqrvpQse
	 JDafrSnRAfbISAasuVea7H/X+qCP0JB5KNtVSi7o38mzqXZtwP5jnWg5ytQz8TyCb0jVx
	 ipc2R2Op+tv8iTdxNLjdJHsC/sjyfwQ+4M9fY6h/dI1TGuowbQLRPqYK47v5klKPyNHZl
	 RCZAtHP6SkUey4jfOw2heiiNQHAHwhNvVF9ATzcGC8jPkCho3D8V9Jp1int47iz3d9A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792448153;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=SiAW1dWmqx/2VIzxs7RTo8DOr656EBaLFtSaD8Naxe4=;
	b=QWg+0hhpwXRXmFyqDeWhJZghm6rkE8n2o2UxgM767YglDJ0HDFLTJRWvnFrpphHNpNqn
	 7F1EZW1jBNy84BRdJs2UwPTzSl7r0YfowV0mzI+H/28/HInQ87TayOdUtpGnsO2LxGVvL
	 ZX7+LCb4y/R4ceFQSkC8K4/zi+0cievrHhEb6gpntd1yUJcaSGb1OpE8D0uLTAnRaZkXR
	 5BfmNwjT7u7S+8YKFNfsJiur4FIKqQp+b0NVqImwNkaNfQiEfORkg42MF696gCoZDdxF5
	 CTmw7TlBdh2KP6oPDdQ41alrocyfa34A3j+wfV03yvIBr1Ld9hhNJUyYVNJzCmmePYw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b4f+DlnF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729E9606A33B;
	Mon, 19 Oct 2026 22:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b4f+DlnF
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792448153;
	b=d/rhnOo9x3bfxfS836xyIk0lYcOphhsMVV6rtsuchT2G/Dd7gip0jzcWdRd0Ti+VzCf1
	 o3CzrWBkS0tm85tOZVV7GA+XZ6t8mpeBgOHMrHLLE4cd6wRVe/rwclIwKw48ZuJurvUKm
	 qBbL/3oVlrC/quG3rBWD+Rz8V1XuxJjTukfBB0CziNZI+bMoaV3WTxodzoji6YkgPuszM
	 5OmLa7yhx+1oXhkH+82hLJyNeUTCXXllbn4P6g0OqrKqgbwUu+A8tKDofkvPjJexpXgSK
	 9k4TRepGEN+Kdi+Yaw8Kj8rlXLQ7RmyVepoRCeT82AUlAT1x7PMhl9nteAkTQdGBUJA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792448153;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=SiAW1dWmqx/2VIzxs7RTo8DOr656EBaLFtSaD8Naxe4=;
	b=pChKjXoaDk36mZK3eLGzN/rqlPbMsJWm8OyYQbz5JPN/a76JG264UGwfdnFoBs/OctzO
	 2XItOilPtx7nx6/lqOd5xRFNwJ1+6weq5nUhykyeiFHL5OJksJq5e7oJPsEJbcg4Ah1d6
	 IoAv0eCo+W4zZ6tS05yqOhEe0L9bbS+8gPW7vKSXvs8ZcvxGMpLo1pceYQMlOl6NX3IL+
	 waqYcEbzibJpUwNMFl/0cJK37Ra1ILBKszypxNQY/pWcMK20lS1IXCyJTyOTtbe7JqDK9
	 UmtnXkXKBNzGh/Lo7oI61qsukbYQ7t5Cy8idzQl+jO9wKJJV4mwxkYbnZcCBjdKZZ+w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4AC291F000CD;
	Mon, 19 Oct 2026 22:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792448153;
	bh=SiAW1dWmqx/2VIzxs7RTo8DOr656EBaLFtSaD8Naxe4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=b4f+DlnFe8EhKAI2yOtHGo3xJUlu/36qvxnq+qiTYgZqZ+mVPHjKfJ0mLb3tEoEG8
	 quYEKpRlyzl4+l2XutQ+h12ndvHWwX2nki1qpkYsQaDnRQo9ht+rbpmX/n5s5aABQa
	 bsHZzDvZsJA7GNIPNA8wr1IpaezYR5NTxYu8zVIw58vG4frCbpDR41fI1hW7snlX6F
	 q5z4vXmRba5TEgmfs+17ew1FqoI9d7lGNUqTUL2QSixGVPHopUJApF2K1H8ZgZyACx
	 J7Y6HgaN8XBzSK+Dffs0VY0XgN12POVWGCjAcWqIs/nF/piJJFT0xyA7AkcBlz5v7L
	 6WL9e035dUzXw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4CF7A4067D;
	Mon, 19 Oct 2026 22:15:49 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 19 Oct 2026 17:15:54 -0500
Subject: [PATCH v15 09/11] scsi: ibmvfc: extend channel reg/dereg helpers
 for async sub-CRQ
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
Message-Id: <20261019-ibmvfc-fpin-support-v15-9-a858726e178a@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792448148; l=4174;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=5womOToxpHLcD0Koo67IAN7Vu9wXmXDzbMbtaAcT9G0=;
 b=OmaBbzwa6atDhWxiFj6O0nm2Zg9A6hTiNkOKMMzI9mvrWQ02PZ9qKg/ZxJ6vlSD7Bq/jrxsPd
 wjxIxMr399wCjfLKLvFoVIivXKHD7kcWSzmVOGfSUyw35/L76Wqs++f
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com
Content-Transfer-Encoding: 7bit

From: Dave Marquardt <davemarq@linux.ibm.com>

ibmvfc_register_channel() and ibmvfc_deregister_channel() previously only
handled SCSI and NVMe sub-CRQ channels identified by the channel protocol
(IBMVFC_PROTO_SCSI, IBMVFC_PROTO_NVME). The async sub-CRQ had no
registration path through these helpers, requiring separate handling.

Add a new IBMVFC_PROTO_ASYNC protocol value to enum ibmvfc_protocol.
Extend both functions to handle IBMVFC_PROTO_ASYNC channels: the IRQ is
named "ibmvfc-<addr>-async<index>" and the handler is set to
ibmvfc_interrupt_async_subq rather than the per-protocol
ibmvfc_interrupt_mq handler.

Remove the __maybe_unused annotation from ibmvfc_interrupt_async_subq
now that it is referenced in ibmvfc_register_channel().

Error messages in both paths are updated to include the channel protocol
to distinguish async sub-CRQ failures from SCSI/NVMe sub-CRQ failures.
Kernel-doc headers are added to both functions.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 30 +++++++++++++++++++++++++-----
 drivers/scsi/ibmvscsi/ibmvfc.h      |  1 +
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index c1ee8eb57491..7e012281d368 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -4441,7 +4441,7 @@ static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
  * @scrq_instance: async subq
  *
  **/
-static irqreturn_t __maybe_unused ibmvfc_interrupt_async_subq(int irq, void *scrq_instance)
+static irqreturn_t ibmvfc_interrupt_async_subq(int irq, void *scrq_instance)
 {
 	struct ibmvfc_queue *scrq = (struct ibmvfc_queue *)scrq_instance;
 
@@ -6831,6 +6831,19 @@ static int ibmvfc_init_crq(struct ibmvfc_host *vhost)
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
@@ -6858,7 +6871,8 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 
 	if (!scrq->irq) {
 		rc = -EINVAL;
-		dev_err(dev, "Error mapping sub-crq[%d] irq\n", index);
+		dev_err(dev, "Error mapping protocol (%d) sub-crq[%d] irq\n",
+			channels->protocol, index);
 		goto irq_failed;
 	}
 
@@ -6873,23 +6887,29 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
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
 		goto irq_failed;
 	}
 
+	scrq->hwq_id = index;
+
 	rc = request_irq(scrq->irq, scrq->handler, 0, scrq->name, scrq);
 
 	if (rc) {
-		dev_err(dev, "Couldn't register sub-crq[%d] irq\n", index);
+		dev_err(dev, "Couldn't register protocol (%d) sub-crq[%d] irq\n",
+			channels->protocol, index);
 		irq_dispose_mapping(scrq->irq);
 		scrq->irq = 0;
 		goto irq_failed;
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
2.56.0


