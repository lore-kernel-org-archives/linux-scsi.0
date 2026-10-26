Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031161;
	b=acRUefnXPn4u8ioO7XGOlg1/zXNeQZQV4+9ZLYyB7CC4zjfGEDJEq82dpUykADEzx5qb
	 AJiNtUWf315bBuSfReJPvOBumkzbzFWGYTCA1RkfQp8vXMze2F4Ry9OvhA3vJcc85OGxI
	 aB6OquI+iImM6ri+Zm/EBNlOC3JVm6hF+u0MFktFgTbn+x1OjLB+xaRq2bi0RHcSfsbXc
	 Sc9Jp8eDPUn9e/ZiYj/DrmjlB95Mt9B9ub4+OlEDldnv/LDlwiZepv0XdzjB1Nu2sEnXK
	 cU6TaRjieA9o/S4e00GRfmAk9vUh0I89rDb+skRXxRsJUd3/NLCaS+30/cy94v/LLWA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031161;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=lfuLPlVQhdJOnAgkFO90WPDc+N4hlkO2cI/tS5tw52c=;
	b=DobTJyl69lX6kFMiBtW/z8U+JgY/nKyd+HHT+4WqwE2IOcwvafsH6kbjeVNTGiVV64+o
	 SHhTMuWYjDIUIIpd1SZ0BOAVMFIlKBHy9rjt64cE7ZfgOzbSf2FJj8GNdZawFw4K4IrhN
	 3be/8T4vVa5Ja2ZseeiD8Gv9f7xcB8sZluL6f0sIlhm27wCtHtnX7J1BY5yWKrtQ1Pm+T
	 NEeh6xM3gzXyPQQ98JSszlBiPA8NmCOx2j66yeJmgvbwbCi3j4rnES2kL4OAwW8BTXZdX
	 hTa+bWkGo8cwSoohRBeGETF9qX6R40eGOktAayxNXUDUEhwoF3ApmJFfFfgFojKLWCQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="l/ygkOBZ";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4912606A327;
	Mon, 26 Oct 2026 16:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l/ygkOBZ
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793031160;
	b=jvjgvv/WNwiL1brDFcK95POLidSqyJF1OW2gy8JMDMo2EYnTlL/lS0WSfyD01Po3i1/S
	 N1XZgTIO3ksMVsBFAEzcY/g3WSo3x9hZ1I9rEnhDF8rkj1Iepm+dv2gbrSR+ETvVsf1tZ
	 fJmMVlmJI4Bo7MY7GY8emDYccbAuc4SKaY6Fw3tlXOxrZYorwoMzbbH5p7LAzQ7oPvZ6C
	 HgLKuno+zi+vXq6FYyM5uy1pgsWM9vZj8gnoh43WJ5r348Gy4tj3dYvYL1rtmJHDO4pMs
	 eR4vIBal9dCOzWm54OPadm4561rP8h/3c2n6zuWvwDawxdhbupzEAJv0SAHCnPEkvXA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793031160;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=lfuLPlVQhdJOnAgkFO90WPDc+N4hlkO2cI/tS5tw52c=;
	b=LDr7QJwvATWrddgojL2awYfpBeh4BjI6BxEx81B3h3UZGibw34EHFPePguMlvSBhmrIT
	 E4PfC2cg1haBwfjdgAOySZrBae1P8wC62wWv/vLxNTWnDv+ce077tsaLIDbPqxtiPyHnj
	 rjiNdfoJk1VhCO1aQycX9SB5/dKZUeXwZYJIkGI7UGjxBRETI6CqU9X33i3emyZl/Ht2I
	 WSGzvkDnVMRoqn2dbtbuBr6UZ7MhtVys7bYwGrtjFPaz2XFpNpxhD9imwVMKNaeurpVIz
	 UES+aCr6WHyzjB+ZEs6l5rRfSdEHRgKzCw/ZtHRRnlVRkehBxL2ibFJjcmonXPPelvw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 21F911F031E9;
	Mon, 26 Oct 2026 16:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793031160;
	bh=lfuLPlVQhdJOnAgkFO90WPDc+N4hlkO2cI/tS5tw52c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=l/ygkOBZ1aopmXdl3cXqDdWJJyWqUCxTEg37LX2YjClAfHs6wllmvbmgZBPlXemP6
	 Oe/i3Y3ttJNrC0qne8MLtQtG4+WrjSuEakmwZerF08l8DhUMdf3Uweh3BT6dmnngBa
	 jGDYWuUsj3NN8L1D68oQMWnNIY3VhPdYvz2mmb5Hq0xImrGNPd9NPSgLipRBN3wIcE
	 /cfsiMAXv6FWgCxOmDRir6P2HKZBldm6ONcv8zxzMJPZzhrcNkT/1sXTrMEX/rbBg1
	 5y7hpxvN/KIoHxL/3jEOTPKU/16ZPcIUuOs72NOAK2YIy84S2QRUqdL4gLp1WD9/ua
	 4WfOeDgWtB1IA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 941C644DA9;
	Mon, 26 Oct 2026 16:12:36 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 26 Oct 2026 11:12:42 -0500
Subject: [PATCH v16 10/12] scsi: ibmvfc: extend channel reg/dereg helpers
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
Message-Id: <20261026-ibmvfc-fpin-support-v16-10-a900aa657ed5@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793031155; l=4174;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=wTL59RHYkrbE9xcNfoFZTQ8F3+zRzTJvSIa5hchzqpQ=;
 b=hZsoW4PPBCXj0aDpsJ629TP9AajJcujRxEYCukyIKLY7RYbFI7CC8O3J8xbBv3jSCdKXOOf4a
 mjR2RIArVKGCQl6R1MnAHGipdd8FkeGRwT61vFjf+RrI0CSWiYGD1nA
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
index 2cb38757333a..af11726b76be 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -4443,7 +4443,7 @@ static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
  * @scrq_instance: async subq
  *
  **/
-static irqreturn_t __maybe_unused ibmvfc_interrupt_async_subq(int irq, void *scrq_instance)
+static irqreturn_t ibmvfc_interrupt_async_subq(int irq, void *scrq_instance)
 {
 	struct ibmvfc_queue *scrq = (struct ibmvfc_queue *)scrq_instance;
 
@@ -6833,6 +6833,19 @@ static int ibmvfc_init_crq(struct ibmvfc_host *vhost)
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
@@ -6860,7 +6873,8 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 
 	if (!scrq->irq) {
 		rc = -EINVAL;
-		dev_err(dev, "Error mapping sub-crq[%d] irq\n", index);
+		dev_err(dev, "Error mapping protocol (%d) sub-crq[%d] irq\n",
+			channels->protocol, index);
 		goto irq_failed;
 	}
 
@@ -6875,23 +6889,29 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
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


