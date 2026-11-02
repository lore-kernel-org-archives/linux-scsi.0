Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793655536;
	b=C7jeJ3J2JI96dFQtSBGBqg+7OnXzcfFRQ64YSf3G4lueOLCQjTBXecWvMli/Im4B57oH
	 wmJH97qDjzq2GiaPPhGJzI5wqNXvmOH5aJHrdBYaTEYYO+IAkJQ1oyjb37Ni5KY7P4IbX
	 dewEOFVgyWxsV1ifVdo6iYhRk8pxYQ84cApQU7rhuLKY2qgeI1qDG3TWVAqo9uLVZ/Op1
	 I0/NzqKWIU9xquUOWDOJ/U4yJaUT1oVJmuTbYjjUoabSehdCGg7NTzOpyqupQXm7KGZV4
	 8Dkb3Znw0gNo7t4YmD2+RDANAxu2I4481oP05aEgCwlWf5NFtpHWOS1pCZJtY/VnC6g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655536;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ShvgX4q4RTycjiB/+JYXHXQZm0rY2E9eoZX/i/J6hkE=;
	b=RULFQLhCZVi2M+YgiW/ZM3jgEBmd07ygdymMsGQalozq42trzCGoFgL73u1BZBQ3yWPG
	 z1doVIUc9xNQc+GDoEeoDB//LvzB+Ej+5Wb2Iv05E/UsDpJiX4qwno1gAdVM7hFmNJ9e3
	 RrdfnaO+xTp/Lge1i4Soj5SdFznp/mpfZLhEz1E9GvN8xRbkQKyirxsD/Y6MgebkD1v+b
	 UsGNUCvb3tskjornAF/ee2WqXDHRbpEetes0vWGYNRxkXIfdWyQWv1rAwqlPc8wm4iNcL
	 ak05S/Ax3wASmAasdA45vsTx3DLCGqDVzPGPF+uuM1ePakuk5Bc2okuSkSRxeqFFlqQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IMhHQEm8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBE0606D821;
	Mon,  2 Nov 2026 21:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IMhHQEm8
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793655536;
	b=0UX5ICLXxxJq2TZy4Dz3Vw/4gHKydDutKICWO/zJE4TMYMMZid4k29wCdUucguV2ZTG8
	 jNtC+LH5snVtpNkgIpUoDS2Hhju6yNRhrwe2OE19DOA/5DF4LsyZyx7e2nA+Iios5ze42
	 eeCZhbzBogTaigmXXqnM3h1RXKC2aYUxgUtMC578SQycVh68xFNo8EHjpKCd7xm4iGzPg
	 TWsvSuc+GhRg/NRykUIonsrxi8Z1iXY0e6aninbjjE8CBoElnnlMjIs53Gy+jssKzZoK5
	 9HvgMEkcMbk53+huH8Q6PpLvn642C4Xz5O2MUWhIVxzCxmSe87ABJM0w6lsKnwGjKJw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793655536;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ShvgX4q4RTycjiB/+JYXHXQZm0rY2E9eoZX/i/J6hkE=;
	b=ivjjrdqpgWKE9P0PDlykot6hfSodG2cn2v348gEK6opVwta/W4iY/6H6DClozIpSHCoV
	 rGviqR6VJ/4rnQrqviIzkCFJdLzxgFhqMhOQxofRwvFzjbC7l0jFnpEfo0xp/v0p6BRFW
	 0HGvg/oJKESSqFqT3mU1fvr7QtyhQe9dzayS0ZNU9vzEmCQqTj6k3izLhFknG744tmXKY
	 cNzCCmPrGULtJakrQr5yf40t573Yi3RKw8b8nNJ95hYhJe5s6n2qgjPM94NHTzU6gifoL
	 YrfYdLUazQmrhNJFc4ey+gZNp4pv5VCdH0PYPNZ9m6C6Bhcq1LxC8VjQpR6NCHvhy6g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5F1FD1F00A22;
	Mon,  2 Nov 2026 21:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793655536;
	bh=ShvgX4q4RTycjiB/+JYXHXQZm0rY2E9eoZX/i/J6hkE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=IMhHQEm8njdH61W6ih1ESasIH0H6m3HlAVOMo5bEXzaWtnDOJvF52khiZml3sjHyv
	 eBteKSYmHq/Mf+Wm604jqj+yYbvS/PKBOQ9BySg9VN2N2MFDJChbGJjvkqzZNVowAi
	 d3uj52+EQuhp4SkfWUnwZsFzztipqDzkaU5t7d1ye5C13ATwo41Uid5CUy1l/ZJGzv
	 XWdKrubHASq4bkMUSj91iGqqx49CyfzSDSeBO5/3o2RMqdIl4qcsCAbv5/lb7+MIGI
	 V844DVIdWsWpPW1T0XqlMeR1nGJJBdtCzZgIaZ8EyE3rxTY5A8+Mvd3JYGKdpIUFM/
	 tU1bs65aqUkxg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id F1C52466BA;
	Mon,  2 Nov 2026 21:38:51 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 02 Nov 2026 15:38:51 -0600
Subject: [PATCH v17 11/13] scsi: ibmvfc: extend channel registration for
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
Message-Id: <20261102-ibmvfc-fpin-support-v17-11-9ee5f195ac91@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793655530; l=4601;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=1VFRENWRWzsedBm/9dHDR+vBkMrZ2AvUKwIBPOYwL3w=;
 b=XRs5WtjnhxehoTnQiqeekEGjVFK9gaJbDymKqWSR5Gk9rJhnE1XIELA1a+yPI6GRv49SU2n9l
 aML5zW+WT/jDzZxrmBatnkn++vMzlVwSGkdzZtbIYudAejEflwSpHz+
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
index 5dba084086d5..7b52401ae4d5 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -4546,7 +4546,7 @@ static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
  * @scrq_instance: async subq
  *
  **/
-static irqreturn_t __maybe_unused ibmvfc_interrupt_async_subq(int irq, void *scrq_instance)
+static irqreturn_t ibmvfc_interrupt_async_subq(int irq, void *scrq_instance)
 {
 	struct ibmvfc_queue *scrq = (struct ibmvfc_queue *)scrq_instance;
 
@@ -6939,6 +6939,19 @@ static int ibmvfc_init_crq(struct ibmvfc_host *vhost)
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
@@ -6966,7 +6979,8 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 
 	if (!scrq->irq) {
 		rc = -EINVAL;
-		dev_err(dev, "Error mapping sub-crq[%d] irq\n", index);
+		dev_err(dev, "Error mapping protocol (%d) sub-crq[%d] irq\n",
+			channels->protocol, index);
 		goto irq_failed;
 	}
 
@@ -6981,6 +6995,11 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
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
@@ -6988,15 +7007,16 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
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
2.56.0


