Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792448151;
	b=FRyIIGb/0BCupcBSolzjwiQ1sWawHE1RBsWUh7IBLj8zQhuXT6pqlHZa/oa0zPYWxZGx
	 ybQfQxNlR05MjTAKCo+OIGrhkYnzpblFnUZqi8sUVQTee/fr8VAowYoT3d6/dt8b2B0A+
	 jxIJ8H4MXvF4Xyz6xk8wiTQsI1J3/Rfz6ngRbxhgRNWJ72oASDJWnQsARpIyf+yM076hS
	 bcYNDcxpxmreVNR5nAhvjpzi+kFiQpYmWmKEpc5fHAPLT87K1f7TBEKcPYjX3lZXG2rqG
	 +PK/HJ4dE2hwrZ2z6+UDv0NNdRxsUPgSPnjO4DusxA9R2hBp3cH7i97WEtAf/rAQOoA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792448151;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=C8U2KCtW2gkZ7Clqkc7+4hsRlGxw+1f7tFdd8uYfw3c=;
	b=MjAiu0S4fk5F+p1/Z+Ja+OYOh0WPtP+KftkFf8p55X+Mou3Y1QXEbxuQgkZESulrXHK/
	 MNYqvUw0Q4wx76qUwbadvXvwOhcc5MruVc6ymZIyy/Q/oPlzefkj7YUunHGZOnFeyrhWF
	 MHzQXYSpT1si0oGxdpLXEuO0OieM8WOxj2BsVLaTa5bqdhnV0BGy9o5iY67D/HA9dCOeF
	 z5KEMsDdpB2Xg25eNv8HUVYGmWlDFs12VlWUkGyWKCynlpSwLkjLRiBXDApRE+khdAb4B
	 VYLYzc5GtexA2MSydRpT9qIvbO7H+clfaJ3Np5QrpdH2EoesYRmJSgU4R30+9zE4b6w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NoNRN5Pa;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A695D606A31B;
	Mon, 19 Oct 2026 22:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NoNRN5Pa
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792448150;
	b=M/uMNA4OV3maeaJShNlv47pYjzQBGU9CLbgRpzKlJNnpSl1X18NhWSyJ7Bu0mdjRa8d4
	 HKio6rBVaYQRa8pohz8WgfaDIp2VOd41wYCcnIuP0JuNuXevyZzWpOCpJrPE7vDbhMj8x
	 KtSVaqq1qigXTxsCLizjauQwtpygycYzrG5sxSaDKwKxjivM6JsntRcUShLctU+2lc/mV
	 rUpgjxz/Flo+zxbkPI9Oggm1drq9oVC8rTuCXSD4K1N5OTeGGrrfsjy8VrzfsF8RMllBs
	 X2nOQTRkqw4ZOfhRYHeeQpNorylp1/bWLqDVNo+zfQUfnLm8q5O3MsIs4+qUwTpIZOA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792448150;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=C8U2KCtW2gkZ7Clqkc7+4hsRlGxw+1f7tFdd8uYfw3c=;
	b=3CldibCDgdf/sGK5kpVaMN7SSMPDSLno0XzDmYbzYuBdCdx4hSE/Q7mpH1Mjj1c3pxaU
	 64QNhRs1u/5CFcx+aihTRon3APBZAkrVBeEJL1pveQ+8S4PYWbTlCISYZ3HFC85wytoN6
	 0xcNhLJGOPRf/DIrrW72rOr6719SZsOS2zh6CAgHgXtOdsnaG/7zKMyDuwpA26gRdVHGf
	 3FoAfDFCGKyeV7t33aklraY9X27fm9qSqPjYKmNM9yv0HrOP52utmsC6FpZWuSbcAje2U
	 ex1TpePI9XT8n6o53Ye1YUcVNoh7Fnred5f25rI9jnXyuwE3Tqqc26nKMwRyEvKm9OA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BD3D51F000C8;
	Mon, 19 Oct 2026 22:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792448150;
	bh=C8U2KCtW2gkZ7Clqkc7+4hsRlGxw+1f7tFdd8uYfw3c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=NoNRN5PanC8iTmmDSh7t2n10LtHk7w5WDwRS182Gu+9vCL/oRTjNoiw1L976yZb1J
	 PV0ekCivBuFd8Zc9Y3eDsjh9YxQppkvoeAj+F9X61R6o5M1an/k3kQ9m5gnbjIDUUS
	 uqZcFB5YWd8V2dKwfMIAa8pHWfpu2+hu9q5gHfuW6njtzlwkJrV8nyKo+KcCPm6mpg
	 fVzlag6hk8inTIvfZKhYhT5VRrvnTSTY7V3ERXnpYgFGJixez6hLPvJJ3Fh0zFov5m
	 +6GsxnIKc8jiDoBJAMtZldA5mP9udnRbGhaQ3YyVdlJcMqinIBKkSdW4Snlo+rx5ip
	 RYUeJbCQt/ojQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 1F26040644;
	Mon, 19 Oct 2026 22:15:49 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 19 Oct 2026 17:15:46 -0500
Subject: [PATCH v15 01/11] scsi: ibmvfc: fix IRQ leak and guard deregister
 on channel reg failure
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
Message-Id: <20261019-ibmvfc-fpin-support-v15-1-a858726e178a@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792448148; l=1764;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=sg9Lbgea4G1OveFwjkYaq90w+e+5hioGkpYGXVuzHdo=;
 b=XHxxpKyKOPUSQxOCELptGm/YkrQMCTGpzBDPZT3aXC/9GvbutqZxbf8oQ/HxjEYHy0DP1Lav3
 gEx5uFoozvHARXWZk0D/oz85SQm/10uimR2LWSk+IZxZRyzEONZAXFE
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com
Content-Transfer-Encoding: 7bit

From: Dave Marquardt <davemarq@linux.ibm.com>

If request_irq() fails during ibmvfc_register_channel(), the error path
disposes of the IRQ mapping via irq_dispose_mapping() but leaves scrq->irq
populated with the stale virq number. A subsequent call to
ibmvfc_deregister_channel() during teardown or reset cleanup then
unconditionally invokes free_irq() and irq_dispose_mapping() on the stale
IRQ descriptor, triggering kernel warnings.

Fix this by:
1. Explicitly setting scrq->irq to 0 after irq_dispose_mapping() in the
   ibmvfc_register_channel() error path.
2. Guarding free_irq() and irq_dispose_mapping() with a check for scrq->irq
   in ibmvfc_deregister_channel() so unmapped or unregistered queues are
   safely skipped.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 0b154e07299c..7818838669ae 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -6435,6 +6435,7 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 	if (rc) {
 		dev_err(dev, "Couldn't register sub-crq[%d] irq\n", index);
 		irq_dispose_mapping(scrq->irq);
+		scrq->irq = 0;
 		goto irq_failed;
 	}
 
@@ -6463,9 +6464,11 @@ static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
 
 	ENTER;
 
-	free_irq(scrq->irq, scrq);
-	irq_dispose_mapping(scrq->irq);
-	scrq->irq = 0;
+	if (scrq->irq) {
+		free_irq(scrq->irq, scrq);
+		irq_dispose_mapping(scrq->irq);
+		scrq->irq = 0;
+	}
 
 	do {
 		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address,

-- 
2.56.0


