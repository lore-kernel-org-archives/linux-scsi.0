Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793655536;
	b=i+PJB9nRvyigLlUEulfyAqglAYfqImhUL5bl8kINBeS5ZyZc9QUwsmsv5uSPZsD05ai6
	 uYn4w7Gm/JY4t/N8LcLLacTBgFDPxLt+2+wyKYDTCxv+Aovm1zPnvrWFW1K+4jIJu1LtH
	 zN5cE6Illm/bin7C/27ua8UXeIQLS1NW2Yi1IoJtdORoI7sIJVLQojfgcY95R8ap/gjbk
	 L7+4AjgKUcgLdIGZHkAqsuTqYEjdfmrl6k2ti0haeB2EhtixNWM7JY3YgiTkav+uUgv4W
	 7JM4HuzV1KjanJZtE6plIVzoeqoNA6o7bHZKEebaf+mMv74DeSXuydhDaQEIUrttQIQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655536;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=sJMcAYcoUTWQFWujTsU8rKB0PJ6Mwry7U0/HNEkGZjg=;
	b=dVlKTgeBoxLP0lQnybZnjB4BV8E2hRv78szSDMv549EOamiIOVFpKtnycYDICezWqWgm
	 WnNkx865SKm3bthMOWF/YgAtJt2+31/xmy2U8qt3Z8bVSULHE15bDzQWQOg3tws/5Fwfh
	 v9hJqKUtLvSCeAswhsCIh4suKoRRpBhJDSk2n5nQ/Flpn2YiKApcGFWLIEiCdlqjfx6Xo
	 XWPsr9goU2AGF+XO/9uIqL9JFh3Bovk12q5+0TJCfiMlkTKCPWLfbFnmdv4wUwdsVwoJg
	 BUoYmbNesBB4dpwg/EtSoDKQg/BTZvUnhBdIZxAWNJCQ89zMqVEMg2nFqhitzz48q+g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BSKMeMUT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C35606D814;
	Mon,  2 Nov 2026 21:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BSKMeMUT
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793655535;
	b=tYNmlrC+fS1+f5BL5lxZupZZcd/x1I+u5LxujZvy1fD6qrgvgM7WFsI+7pWES0J9Y3F3
	 ezWxJbybEFxRy1CXl5FxS29LzQTAI90hA9X5yJRImF5EbgHgiiHfa1Dq6mTVS30Ydep0G
	 EYuRnp0GjlxGNIB3vd9a3CIwPx1lyttpqOkkzAHoYrGo5jEa0GdRk2ps1djCXjTmcLGJR
	 1sWO2cYvNf83l03tFH+EddwPLoyU6wQSuV7z2RYPsMMy5oO1heIcQGR9VnBu2D0NZkzl6
	 +Bnv9SiiB0fvMv3Nvmb2jTQsVEVnBS/szMtOdKtW4qChjYqs7x4PdE7QTTsgfD5WJmA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793655535;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=sJMcAYcoUTWQFWujTsU8rKB0PJ6Mwry7U0/HNEkGZjg=;
	b=gNwGLJPSMIUyO4FSay2i3Lct2YPUP0660N83/Op3vEjNdBEUdRd3nZhud064IBghAiut
	 OXDWrsNj7CDOwlnGk1360Ew5Wzsm+rVoFixYfuW3lzuVTYV4/7GMymjUCTYsnR1dEzE0B
	 24IniuGRAter2q+GNB9J/5XDJ8VJ0bP0A8Z6BdfNNBJWE5itYaJ1kIJ3Hyl10/d/J0Gdi
	 QBRc0ibtocbHdxgJWfQFMHCWm+fg8OP8ZbF4oh1PNEP/iPPFk73SC9anezcZR47/N9dON
	 KeJANg9wfHCcopwfJv2x5NwqShuCu//+9tpJEwq+k/mNupq8Y+atZXIqd9/IbDGVcVg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A0CF21F00A20;
	Mon,  2 Nov 2026 21:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793655535;
	bh=sJMcAYcoUTWQFWujTsU8rKB0PJ6Mwry7U0/HNEkGZjg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=BSKMeMUTvZflQ7aFkPYPvl6Oh5pg0jIB7MdVEw5/6BaW+AMUmECYA7KUbV/JTDK2v
	 uX1/3HHAyU6+LIfL9XfFeZMtB0gyGU3lmXfBDtShdx1N7ZiznaZhiQYmvyGPNfAA+3
	 LqKYY/Aivkbz2Xkk1sq0+LTC2oWeWAwPTSkZkHXaWWASOtKoqtI2+qAx97bq073Fox
	 uHfZzL5vFWUh52YEdTRLAbAmJaGddnvOD7XMJ0wwCTNKolQufjwXckH1KaG5bNP2+s
	 P/rSC83NAcveVvDJ03Dn2Y8e0llMBzG9NMLgD+Uz9V2HMcQtrN52Gsiy6H5MC3Wjtk
	 JHnKFTBBZSroA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id E423D466B6;
	Mon,  2 Nov 2026 21:38:51 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 02 Nov 2026 15:38:50 -0600
Subject: [PATCH v17 10/13] scsi: ibmvfc: add interrupt routine for
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
Message-Id: <20261102-ibmvfc-fpin-support-v17-10-9ee5f195ac91@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793655530; l=5369;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=rzRLzI/0DVNhhsjrydAeA8hyA2ajK90jlhszpnL3xos=;
 b=E/5P1HqoZ3V9tvYvqD5EyMstXcAxwAb0XhIaRK1PE6k/X9kmXDL6FpYuVXNC+I/7/o4Ot/y3E
 bwWXEdT7McaBjFjJnObXysgTKuKPWHgCPfH6BAP9Mm2cqAspxNDwZSM
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

ibmvfc_drain_async_subq() separates ring drain from event dispatch.
With host_lock and q_lock both held, it loops over available entries
via ibmvfc_next_async_scrq() and passes each one to
ibmvfc_queue_async_subq_entry(). That helper allocates a
struct ibmvfc_async_drain_entry node with kzalloc_obj(..., GFP_ATOMIC),
copies the event into it, and appends it to a local doneq list.
The node is zero-allocated because struct ibmvfc_async_crq_event is a
union and the copied sub-CRQ is smaller than the main CRQ member; the
remaining bytes are later copied wholesale into the FPIN work item. The
valid bit is cleared and a write barrier issued regardless of whether
the allocation succeeded. If the GFP_ATOMIC allocation fails, a
ratelimited error is logged and that event is dropped; it is not
retried. After draining the inner loop, both locks
are still held while the sub-CRQ IRQ is re-enabled and one final
ring check is performed to close the race between the last drain and
IRQ re-enable; any newly arrived entry is collected the same way. Only
after both locks are released does ibmvfc_drain_async_subq() walk doneq,
re-taking host_lock around each ibmvfc_handle_async() call before
freeing the node.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 100 ++++++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 7406e7182777..5dba084086d5 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -4456,6 +4456,106 @@ static struct ibmvfc_crq *ibmvfc_next_scrq(struct ibmvfc_queue *scrq)
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
+struct ibmvfc_async_drain_entry {
+	struct ibmvfc_async_crq_event event;
+	struct list_head list;
+};
+
+/**
+ * ibmvfc_queue_async_subq_entry - Copy an async sub-CRQ entry to a deferred list
+ * @vhost:	ibmvfc host struct
+ * @crq:	async sub-CRQ entry to consume
+ * @doneq:	list on which to queue the copied event for later dispatch
+ *
+ * Copies @crq into a newly allocated ibmvfc_async_drain_entry and appends it
+ * to @doneq. If the allocation fails, a ratelimited error is logged and the
+ * event is dropped. In either case the entry is returned to the adapter by
+ * clearing its valid bit.
+ **/
+static void ibmvfc_queue_async_subq_entry(struct ibmvfc_host *vhost,
+					  struct ibmvfc_async_sub_crq *crq,
+					  struct list_head *doneq)
+{
+	struct ibmvfc_async_drain_entry *entry;
+
+	entry = kzalloc_obj(*entry, GFP_ATOMIC);
+	if (entry) {
+		entry->event.type = IBMVFC_ASYNC_CRQ_SUB;
+		entry->event.subq = *crq;
+		list_add_tail(&entry->list, doneq);
+	} else
+		dev_err_ratelimited(vhost->dev,
+				    "Couldn't allocate async drain entry\n");
+	crq->valid = 0;
+	wmb();	/* complete write */
+}
+
+static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
+{
+	struct ibmvfc_host *vhost = scrq->vhost;
+	struct ibmvfc_async_drain_entry *entry, *temp;
+	struct ibmvfc_async_sub_crq *crq;
+	LIST_HEAD(doneq);
+	unsigned long flags;
+	int done = 0;
+
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
+	spin_lock(scrq->q_lock);
+	while (!done) {
+		while ((crq = ibmvfc_next_async_scrq(scrq)) != NULL)
+			ibmvfc_queue_async_subq_entry(vhost, crq, &doneq);
+
+		ibmvfc_toggle_scrq_irq(scrq, 1);
+		crq = ibmvfc_next_async_scrq(scrq);
+		if (crq != NULL) {
+			ibmvfc_toggle_scrq_irq(scrq, 0);
+			ibmvfc_queue_async_subq_entry(vhost, crq, &doneq);
+		} else
+			done = 1;
+	}
+	spin_unlock(scrq->q_lock);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+
+	list_for_each_entry_safe(entry, temp, &doneq, list) {
+		list_del(&entry->list);
+		spin_lock_irqsave(&vhost->host->host_lock, flags);
+		ibmvfc_handle_async(&entry->event, vhost);
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+		kfree(entry);
+	}
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


