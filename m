Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795537018;
	b=dGbFfCnFwmsAdt3M7K2f8Sf96xG4FnawjY0vMN+owmO+3O7nIEkTPMTTro3Yz+qnY+pd
	 Y1PQVLxku+cgJgEQyYFHJ8pLHv26p7Vm5a8NCTI90enK84HxUcSHS1OcfrX2MH9Nmj254
	 b66yl7eZ/cgvFN0837CnewiA0lRHxdpj/lolE8pNwwWwRGqfFihdSm30Zsc+ih7FhVlAK
	 szFnx0/y23SoQftw+7YRPoMJUWZjqCHtu8lKmgUSiHtSGlwQnfRNZW5i81DUoO8PlPjgD
	 htvhL7Q1z42Ef+fhAaVhDsalBfEOM+26QRKE9HSiiwpdIdvLsgh1uay8w0L88q4D6lw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795537018;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=iWHHpK7I1aPxhjQiISteCfAmv4UI48rr2CE7X1IOAQg=;
	b=SGZTovNqrj7510cjcZcwO3Vea6v9cMJYjAQPPpZeM8ZfMSBBNQswonb3mAjcleNNctZ5
	 y0J08gcGKyF4NPbggsYUubk4H29bSo+tEVYHllTqX6xwFpdaxqMWAfv+ovdhJ4PxfiWpz
	 Y7Mn1OopYBs2eqkoy6dk5BNwz/UKBF+O+vg4MvolAR096feUaEeNzkcBWJUWoZVMJFsqA
	 j916dKE5xHWc7dWtcO1bHM1WVrM1bb7fP8trraHU3QYnctXkWtTGqnOpzdr5tLrY3ISA/
	 0PBejmDAr5nF7ZrHlRW28htZMACEJreFMU7ea201YGqfH2KadbOxZzq6/oUPLv2eFOg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PxIttCPQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E540D606A339;
	Tue, 24 Nov 2026 16:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PxIttCPQ
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795537017;
	b=p6jL8VX+XL+K/sRb7Tmixb03U8ABGU1+yaGFk5No6xgcVY/Qb16M/DsnMvKDbeFEW5oK
	 TAQhUUQyZEYF95+288PftWxfwNUUfuN9PW1zHBE4Xubib53kcCLK+9hgcSpgxk6wsIiw9
	 QnWbTL8V9DQ+ksOid6EEG11U4teKEMndYVxzEZsD4/K1kJF4WdpUvjHfS1z9QfKCnaxmk
	 w/vhyAOAxfY/VOLqx2tBo22X5weLRJiUSv/y0isGoiL3VHHNkI3YNwl/EAIjSo1msh/0f
	 u3hiWlZ8Sgh23alHvyP85kw/XFYynI95AoJBX6/sDGitWcq+fxbWt2a0/pP8H82rCCw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795537017;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=iWHHpK7I1aPxhjQiISteCfAmv4UI48rr2CE7X1IOAQg=;
	b=A4h0ZgG3PiyszKIQOZ1yP5PVINfOn+DIYdPPRJJT0BFxpxc12V3+7yFo64Bn209D5yrn
	 fSjakga61p6qJ48TJBksClBzvPJpPLUwpX9XpPsuHKfUs/AJI/FRea0Onx4mfqEEg+z1C
	 LOEnoz3f6OrZtZkfR//PoEPXzdRZPt3LkcPJrc6dem7cRqIXyNDXwfNNSJaNN2nYUPSrG
	 7ohnf5SV/z4mLFq5JdMkmO2az/eJX3WJFyST8EuksyMYHzlcTZx+dRCmKdxhF20S6QqFI
	 D3dGxkXry2YvboTBkWrDqvZnF6nDz+PYBFRgRYam2W5neP15tcX3kHiqWZjpMrbqdkQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 109B11F000CF;
	Tue, 24 Nov 2026 16:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795537017;
	bh=iWHHpK7I1aPxhjQiISteCfAmv4UI48rr2CE7X1IOAQg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=PxIttCPQT1UgXuf/BzffGeoWWB3rMZDayWDyXldViuM4eezGoV3aVc02xV7uu9UDF
	 HJFTN6/smdO43AdsB1k1xjt0QFweexmqXOxkfvghf8RPQdIShK49a9+hYYBSaYm0hC
	 46IXAM112hgXh5vl9NuTp8NSuxdSM+kdgkYLL4EnF4rHn/traT9RLeHrJZXuRKp1cc
	 8iUO4pUaqjO5S1IbRP1sCD8weyoDik+1tnOPnKhMbghQeaaih198acrfTlIkdz5Mg8
	 zH8cxZ4NcpgoDWMRmw5QBFRnou1qmieDM1TuXc2gcyHauCUoUczkfuVnZsQgzqEes7
	 F7MF/2rGnPjUQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 8A2584CAB3;
	Tue, 24 Nov 2026 16:16:46 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Tue, 24 Nov 2026 10:16:42 -0600
Subject: [PATCH v19 01/13] scsi: ibmvfc: fix IRQ leak and guard deregister
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
Message-Id: <20261124-ibmvfc-fpin-support-v19-1-2aaffe5fe7d2@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795537005; l=1764;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=pdRCCHFHcIdzSMz7J4MKijZ8CZDRz+a9xWemOyE6eEE=;
 b=cofSvstI90OfaG2ybZFQXJ6mMGEhqhcz6zh9/b5TO7osR+Npb8hKcEHCgGpGJT9EcGAGh4DTe
 LjavmDHJm07AwPE1trauYdPAmaqRfxMQ1nzbM2P7SIyua/L4ULiNpnN
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
2.56.1


