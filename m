Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793899383;
	b=Cjn98Wf+gty5jymdnRx4bBtlaL5Ry4zK0yYOo7Fz4XJJbyVtHQqb7TFiFdGVzbO5MSKr
	 9Jaau1q4voFpagVJyrcIgEVdLTzcF1Vsx3UFwKxV0w+EupgxtoJuToq2nWsDFkdpyApaR
	 bITJ5k+b58fLmKJEVVffe/iVL0z3B3G5CibFzVRB6If0VHE8dFCUWUAOJ7UL5gHO5ugWF
	 YkS4aPCeztQmtUKxEQ1oYLeYhJaEhE6kIeImgOZL+KU3XeUcqAixUsnrREb7NZtYbdbMi
	 DVAlPQf4vR674w4ZQLDePWZILyPpex4ET1OSWfe13XhxVbOS+0/jKAvtPmcOID1h49Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899383;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ShvgX4q4RTycjiB/+JYXHXQZm0rY2E9eoZX/i/J6hkE=;
	b=BG5rhjmh5rwWl9LTP5jL5nyjT5qJB1Nb7QDoPaCm4uEjGJ2G708+Q2mDnQ7iphm5gUve
	 coXHnW5rX5ziLthj6XiwJCQZy72MAvE2xKp2Lkv26bbz0Z8FMRrsaN6Wr1vmXzKsMCEGm
	 083xwNGIVYoHcQYbYa577lnfj+9xxNgG0csr7cj+DaEyWjZDKh+HAZtkmeC3856mD+1/b
	 BlqbTZ4Gos/gY4uy0HOA+vSPlcn2vQux7Rn68sO8mOnOGbx1dM2T9IbYdrDwzi2/W8RSE
	 A4Nj5+6QB8RZt4trDBjSDiZj6X7JBcTm5Rtc1eYKH8qlLVM60IbmbV+epeLGCbxNAew==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iFay9PoQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955BC6082BC5;
	Thu,  5 Nov 2026 17:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iFay9PoQ
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793899383;
	b=YLZLgJV9PhfaLnpBexC3PiujVkW2Yz4JFSS+VX/ETat1+zP/ehcF6JxruU0jdPbRgl4k
	 VsH8oGq/zpJxbYvf2UraYeH1rNdGilgWlju2vyjIEyAOvAgtT7eu8TIAQhARkJ7CegbGv
	 xIrYsGB/1gO9aiAIDvH3RR+wplH94juJuQsM/d0YXH6gntO+RR+OGnk0Nu2K65Ury8Iuh
	 ScLzhlQwizOQWRCXlDo0dP2u+Npk/qMdCtcRvPxw0kzXawzJsuCkd2jgdp+lDp7wZQgwA
	 KrdnqUs1dBIAfk5u2wNi7R5luR8eP7AhsEGZJJchrvIQhuHLS9SrS+mzpstIvqfw+OA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793899383;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ShvgX4q4RTycjiB/+JYXHXQZm0rY2E9eoZX/i/J6hkE=;
	b=hsAd1uOoK8Ov2gfi5IPgu4QrH4kJOicPpQlYpXVImvNdTfV+iShMiUbu0L17zhi/YVVl
	 QX4nHLUeN5C6kaKnUXZVGhhLNRqDaATICEwrEwyMXGmWB8E5rGlbfZGIbtBGFVYUYZFqh
	 HJY3FLmTdCHRW1nSr2Wnt+NArUC868H4Y1k0RewS16GG6esZu2+eSGtchuWbyoMvsKjDM
	 fEQZj4FpDqJS9uLDxQMBD2zqPYcZf7tm33D/COscl9TG7tltjwARjhcYZK/16uSWVru4U
	 zd2uTwnXir5MLfz57AFm660tO8QEm13KuleEXmYfKVibOAOMNd9/ktDaaypzAR9Auqg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 625D21F00A2B;
	Thu,  5 Nov 2026 17:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793899383;
	bh=ShvgX4q4RTycjiB/+JYXHXQZm0rY2E9eoZX/i/J6hkE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=iFay9PoQajhIdN5ILHk09qeJSqi1L3BuXWhc8vPMjgs8duyxect64ZN8gonPFHWEg
	 u8tzt+RecMDStCA46fQW6XG1w8ddDOia+XLdQC11DMpwJKjMSqNL8aM7AuTrDyvYye
	 A1rPJuDrygXV72+9oeIu55DpIULAGn+DLgPZqPng+soiitS5ml2TtxefWrXjbg6HSJ
	 Z1p359AOB3wSnTSkt2nxxAV4czujuz61G9c2rM7cugtx7FihWwnpXtBBTg589KwJbm
	 Tnhl5TxqvTPYhzbkrf/VLJ5j6sAzRBQ0y915p+G7fAuDWe+FYgdToJgz56HdSxXfs4
	 JJlFAvfLzCoMg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D4BD147396;
	Thu,  5 Nov 2026 17:22:58 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Thu, 05 Nov 2026 11:23:04 -0600
Subject: [PATCH v18 11/13] scsi: ibmvfc: extend channel registration for
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
Message-Id: <20261105-ibmvfc-fpin-support-v18-11-d683b74736a3@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793899377; l=4601;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=1VFRENWRWzsedBm/9dHDR+vBkMrZ2AvUKwIBPOYwL3w=;
 b=aniZt7sWwIUs+73yvPAvdVno0UpztDE9hge1Ig60mNWEwNuvi5zwi9vqWu+MOFI3oti9spimD
 FVTPO4p/M6OA8wLz21S+3mNnssiPWVZ70jDf6Nw1RtFCoV8XnmBQmQu
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


