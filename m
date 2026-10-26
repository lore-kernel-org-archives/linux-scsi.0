Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031160;
	b=zdfYk9c5tIXkp8pDXX6DJoQ7VD1UudEm769cAyZqwh4MPzBjniVamxcwN4BTx1bvV69A
	 is8AmSmLZvjO/RpsVBwY1i60yt/Qy1tjBOx4pMGmuk9ZpGh7PjYqGeiuDukv6p+Kxw01c
	 GRpRjIxJvdTrVasPU6glcPnv8zSqt40LmpfLgPS7ppjhrZ/VvfKWOhCyjyDlO4r62Na9q
	 /e8EmHWOAkGxAHrzHRx2ZcBvjZG1bAPX/idZwhjnVCZ/ynMhw9JbI2LI929VYB8oih8jG
	 wKKg9We3ktdPyvsjjFvYdw7emLvBXHPCi/fEAsJGF3uSm2kWmyTiSHXDGJBvbMB+yvg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031160;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ZvJXQfHEE7VvzG2+OpjGruH0r7tUMmjxlKPJBxc62Pg=;
	b=XMYxbwy5PUw/hNw4paMjWK8D+TfKsky0eMpfJsSfEvgp0E5N4S5fJ/dVlKXjsBMKWY/w
	 XWrXPER9HHXVsq/L+ce13oKGb/6Shg2IE0FdxfGtDEx3PhUtbY7psIXvZnRgd2nIkdiZ7
	 ydISDNIO+8kkbH7EMTzVjPPWp+5TpIBt+Ttv6frsWQHxUjd8IO+cQs1O+x4O8qP014n78
	 dC6GrEbSccJepBBvJHTYpYeYNagLznY/NJwFBNsOQfufROOAKSbw2dNUmPf+FT2ridLtf
	 cMOKKTsFIgCi2HFPNPYHXm+vC6UM2yqNekvN5SqmhNvesd9cbHYX2tHskGHFdjhnYIw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UCDk5Txo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD33606A32A;
	Mon, 26 Oct 2026 16:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UCDk5Txo
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793031160;
	b=xK1KBC8t8AD3cpl+rn0GdRX7S4Z7F5gyiEU4eCWvyMKee4RU79Du8blFfZTYrR4gwpG7
	 3uoB2+13BNqEQ0vezrXsbjnBrA4cg3bOCFx9gHsIUh1w6I/d82O9Jf3R0HoC+JlotQ1uA
	 HasS6oHHzOeSH+IyHM/nyRPTuIoD+tbCnrWXkhYQnEGEz7cAJ6RkKRSUx3EqVMCK+TU5V
	 THH5wFiR5t5IVXyoc7ywfOwFzAPJuXXa/JnD4anJuvn0352PXuOM2cXeV4CZyvHL9fBe/
	 5Jh7cRxWduzJRqREvcEnY9RjGUvjylwCXXwbpytyGqq2DQE+3tqcxWNrbmJTw2IewUQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793031160;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ZvJXQfHEE7VvzG2+OpjGruH0r7tUMmjxlKPJBxc62Pg=;
	b=RL3AfTe4et03oP/96bnNA29J/YuUpnaUF1fbr0CdSGyqk2XhBA5FZ1hb0kDiZvpxe71T
	 HDFJf1D1cAu1PCrL7cOluCVH1aojwkJmF7E9s+Ao/ZE4JblWhGcbYEhCPRakjGskXPJ+v
	 ievGzBGoBu9DlRST8NphsRQxJ74hDk+9UhevCFYrz5ZXg7p53ImlIkdeqSn7EW0IzlS6K
	 73lAsc8jPTemsgrEhnj4KTEanrAhn6vMNtKrqJ5HCjaQgDktlcOnd9ZASs0+nmgxQo7v4
	 +mpHaWZSjenp1BHea07G6YImkAzIxZF1vemzrLo/qpMmWMKZCzJF/L+ntz62tYrxvow==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 220AD1F031E6;
	Mon, 26 Oct 2026 16:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793031160;
	bh=ZvJXQfHEE7VvzG2+OpjGruH0r7tUMmjxlKPJBxc62Pg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=UCDk5TxoX6vRuBhqzNXon2R6ti5QmTD7J01e06+3Lpk2AoA3OGW8PEL5ca4bazGMK
	 rgaZoHOqdESZa3gUdwLiWn5D93tV3N8uQc1MVloxLRcynfoeTtuIKvbQPKHXkARa3c
	 +fPUn0IJUnJ3cvtq8kc4bpvlZh6aetB9TpX+f/AqSRWQ3L+3Pb+HK/6HMp4KuxOr1f
	 R1kWjZ6fFzAJmZUsbzYxwGy8VB7feXj9bLJREy3cujDxp7xXGd2eKlSvQPPJaXZ9W4
	 khOu/Anz4osoUKsFzD+hDlk/t6lUOdi3SOSKcGU9iE7/gceBxu+CsX58PWHMEB7v/S
	 AorF0p3WkVuTA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 8AC0D44DA5;
	Mon, 26 Oct 2026 16:12:36 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 26 Oct 2026 11:12:41 -0500
Subject: [PATCH v16 09/12] scsi: ibmvfc: add interrupt routine for
 asynchronous sub CRQ
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
Message-Id: <20261026-ibmvfc-fpin-support-v16-9-a900aa657ed5@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793031155; l=3347;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=go7bhrtGZ2dJgmunhF9sAEtDO56741ZtmMW3WsNf3J4=;
 b=YeNEVXD2yEAzkSpchkqjQ4s4lwYyDDj+2Ae9TWYDelihqk7eOG4r1GLXkulazakgduJQAFM/v
 mucLVGPe36VBMu8ktQOMI7DvGbFzTl5I6aDGTPqrzvlVFSgXT30vsnt
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com
Content-Transfer-Encoding: 7bit

From: Dave Marquardt <davemarq@linux.ibm.com>

Add ibmvfc_interrupt_async_subq(), an IRQ handler dedicated to
asynchronous sub-CRQ events from the adapter. The handler disables
the sub-CRQ IRQ and then calls ibmvfc_drain_async_subq() to consume
all pending entries before re-enabling interrupts.

Add ibmvfc_next_async_scrq() to traverse the async sub-CRQ ring
directly via msgs.async_scrq[], returning a typed
struct ibmvfc_async_sub_crq * without the cast that would be needed
when going through ibmvfc_next_scrq().

ibmvfc_drain_async_subq() holds the host lock and per-queue q_lock
while processing. It loops over available entries via
ibmvfc_next_async_scrq(), wrapping each in a struct
ibmvfc_async_crq_event and dispatching to ibmvfc_handle_async(),
then clears the valid bit and issues a write barrier. After draining,
it re-enables the sub-CRQ IRQ and performs one final check for a
newly arrived entry to close the IRQ-enable race; if one is found it
is processed before exiting the loop.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 66 +++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 64981a5a39fb..2cb38757333a 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -4387,6 +4387,72 @@ static struct ibmvfc_crq *ibmvfc_next_scrq(struct ibmvfc_queue *scrq)
 	return crq;
 }
 
+static struct ibmvfc_async_sub_crq *ibmvfc_next_async_scrq(struct ibmvfc_queue *scrq)
+{
+	struct ibmvfc_async_sub_crq *crq;
+
+	crq = &scrq->msgs.async_scrq[scrq->cur];
+	if (crq->valid & 0x80) {
+		if (++scrq->cur == scrq->size)
+			scrq->cur = 0;
+		rmb();
+	} else
+		crq = NULL;
+
+	return crq;
+}
+
+static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
+{
+	struct ibmvfc_host *vhost = scrq->vhost;
+	struct ibmvfc_async_crq_event ae = {
+		.type = IBMVFC_ASYNC_CRQ_SUB,
+	};
+	struct ibmvfc_async_sub_crq *crq;
+	unsigned long flags;
+	int done = 0;
+
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
+	spin_lock(scrq->q_lock);
+	while (!done) {
+		while ((crq = ibmvfc_next_async_scrq(scrq)) != NULL) {
+			ae.subq = *crq;
+			ibmvfc_handle_async(&ae, scrq->vhost);
+			crq->valid = 0;
+			wmb();	/* complete write */
+		}
+
+		ibmvfc_toggle_scrq_irq(scrq, 1);
+		crq = ibmvfc_next_async_scrq(scrq);
+		if (crq != NULL) {
+			ae.subq = *crq;
+			ibmvfc_toggle_scrq_irq(scrq, 0);
+			ibmvfc_handle_async(&ae, scrq->vhost);
+			crq->valid = 0;
+			wmb();	/* complete write */
+		} else
+			done = 1;
+	}
+	spin_unlock(scrq->q_lock);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+}
+
+/**
+ * ibmvfc_interrupt_async_subq - Handle an async event from the adapter
+ * @irq:           interrupt request
+ * @scrq_instance: async subq
+ *
+ **/
+static irqreturn_t __maybe_unused ibmvfc_interrupt_async_subq(int irq, void *scrq_instance)
+{
+	struct ibmvfc_queue *scrq = (struct ibmvfc_queue *)scrq_instance;
+
+	ibmvfc_toggle_scrq_irq(scrq, 0);
+	ibmvfc_drain_async_subq(scrq);
+
+	return IRQ_HANDLED;
+}
+
 static void ibmvfc_drain_sub_crq(struct ibmvfc_queue *scrq)
 {
 	struct ibmvfc_crq *crq;

-- 
2.56.0


