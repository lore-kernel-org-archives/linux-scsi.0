Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792448154;
	b=lt88dTM1NYECKS0JmdEY0KVvAr8PiPwKagVZoNY9gQ4lSbFbkpqFmGETpMvVYtE9xWYl
	 +siABU2Mi0S/pQAYfGf4nyHZotj8dUOP9yEujwkVU+6upenrwUOlRpuCaozNvq+nbkL5a
	 zEGLDN0Liq+UEJPjABSZnGpEAiB5i5NCLlVfaC710CLTsGkrAjsmYCDzKe/ypBKL5jiAW
	 9XUDTFDft9XZ72YZwpqqEalEKJlu9jU1HZRiD4ohthBTeDgA9pymrJH1kSYHQV886dUZq
	 Erbma/ai4fS5DlcGo4v57M+cvKyEAPgX6jxR9NgvbqcJQcwRKFeGNDLHNVh9j3LVrKg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792448154;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1SsAn/4D2KY8LrxXXAic0O4wc9gDlFfVuJBtWgZjhik=;
	b=zn80yQaZQU52aJM/JqoKYJI7BAbYVP9HZdH80xMAhpELGtioG4CB8lSExEcMF/f95D3y
	 aytfwHoFlk+YM3SMdE1Fa1VdzEmtA/zGrWO6Qqap9QGmDaTWLT+lVUjQdcla8B8OzyQ5H
	 LdPoDqnS3atjZSEhUiKXFm/h0+OGKUeBscoooVTnL4bqBugqEsM42vABd4gWy1xCdj0SM
	 bjmwpVkgzzer/+Gl1q66F//g5YwX/Jo6dGw5DG7lZZ+bGnI5Y3oJHwjS4FmAgGXv4PGRf
	 yO/mdcTYhO3G5zetXvH/yr31E4XQb0FdYTn+fjtTf1qu9l0LdqyGBuasJjynxVgn8bA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bYkwTALH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F95960A260D;
	Mon, 19 Oct 2026 22:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bYkwTALH
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792448154;
	b=kSB1Iz0gufp1l26JULcV1o86K80KuuBoeSFWps/Rg8IJrll++7hDbkcf2Ojk1chWSKk4
	 daQdzDyx9nfmDcM70GvBXrpD7K4Eur4zBXK5bw4O8CaghvxfqvFQ+FZY18HcOyfIRZzDT
	 cB0mw+rqAiJsycD8Q5VaqXNXDBLI19wMzv3hoVnDzEHfNOh99EOh9RUgZQRMo2P6TXCt2
	 w7gtBX5XG1HMGJULEQQjPu9F66hrV0dL800NNJ6Is78DflISLlyGw3fSyD0MRnpEF7Pvy
	 myfKZbJ1f3Z5uDt0XE5yL0ufW2etHV4egwDeFGhRIbEXbUlMs5Tuspz0bJqED+a3TTg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792448154;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1SsAn/4D2KY8LrxXXAic0O4wc9gDlFfVuJBtWgZjhik=;
	b=y7uL0HgnfNsouMiEgXioNeiRnsPSCpI1rWgQVugP/g1fZ2UvQ29XK2cfxsKuiecVE3zF
	 tRvO0ZIbBGnEhTKaF2gN1/o/cG/lfjKgwsrpwTdvkWrSwGaM+qY27SVYN0iDSJKxGbXjV
	 8HSnPhprH/6vAR/b4YOiHCWS96Fsqj1cH11ydasBXkRuGUCsY5AMTzRldszYhJX1u2iCG
	 0gFHHsimyvxUnYsUw5v5LFPKhPqtOTDX3iPm127oADQtm0CWJLkxIWGQd7jZ6936TmVnN
	 h8UAmN+RvBOwo0r37hsGW6b11DGT7CloIrawv0uDCqUJiUSI+Mj1oWIhutjjbeDAR0g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7C1E11F000CB;
	Mon, 19 Oct 2026 22:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792448154;
	bh=1SsAn/4D2KY8LrxXXAic0O4wc9gDlFfVuJBtWgZjhik=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=bYkwTALHV+njm1Y1HifTYYB2GWPiSX1vSy8JJBEs6W+Ua7wXfGbCRij+GtCjPm+Wm
	 6UlKpT12C71skZ6OknL60+posaULWMf3OljWIsrF1JXvVCPzB11WcIjbYx7iMKhD5M
	 YK6T1pcQeWZ5YEsdMp322OOYRfIvKBJtwpb/G+PZUBhU+XQJtE6JI6q7TJj1pSYqHA
	 eLTzn7jLXMnWv5biiqyVupYGtHKLs5Rqiz8ILnhkxqzsdeBMDwZXG4C/a+sNmEB+se
	 EloZcCZWQwdTxfETPlKaHb8aqhM/tdmSms0rXs7SCfarCsEUMKM7882/CTfgLNdeRU
	 GMNr2kcGa+pYw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4774D40677;
	Mon, 19 Oct 2026 22:15:49 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 19 Oct 2026 17:15:53 -0500
Subject: [PATCH v15 08/11] scsi: ibmvfc: add interrupt routine for
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
Message-Id: <20261019-ibmvfc-fpin-support-v15-8-a858726e178a@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792448148; l=3347;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=Eh62A6Y+lUfh8f/4MfnlRnZuPDVmZGcaIx37w0Ng5Nk=;
 b=lmal3ZJbbuXVU+J5raFMWwUbcZohCA5sCclg4BawB9XPE5od/3xkcuFdf7j/W0qC/N+CMq9Ex
 Xkc59LGpcayBikZLgOvCZ/+cex83yGJQ+p34p8/+PMQyFo1Nx60lSpS
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
index eeba6e6b3cae..c1ee8eb57491 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -4385,6 +4385,72 @@ static struct ibmvfc_crq *ibmvfc_next_scrq(struct ibmvfc_queue *scrq)
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


