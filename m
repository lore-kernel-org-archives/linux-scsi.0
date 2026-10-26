Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031159;
	b=IfkAZ16LDVytdqZJyS2FB9dGgxBVnGIYf862Lf4+tMvCNrfWT5jFEcUtMfhlt3wl4F9M
	 Tm3jGb+snijC8TOB4ey/WWeQf5aCFTFftbvrrc9BpS4963P86LObL8fztKc3g7YOxVMjm
	 5NjsLhObY+O1EnfSLBJ3rjR8Y6lny37HkOZA9zPEckpYCltM9m3r97O8GDVYAQ/H9dAvg
	 cK+1e0t6XOT7TzbeMEN20jaa/Rv6kFkoTSI6GlmL6PbqwSkGr84R0RwMlUZXYOkfCDnux
	 hx8BRghnZ0yQ0uHvMGnIgPePNZvPh1uHz8S6RBGNgxV/eodFXx7BjZ628azaY1LSR3g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031159;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=C8U2KCtW2gkZ7Clqkc7+4hsRlGxw+1f7tFdd8uYfw3c=;
	b=krHIODrlmGM4Xfk4f0gM2BDaWKnXz8aKtKoczmVDDxhvCm9/BuooMptPpWklNCZ6Er7z
	 BNRdl5AJPyqSMPAUjlWjZSSSAXhnWa8VzeChlaU8ts0VOXlaG3ZlNueJcOfDwLb1KAKSp
	 J6f1PEmERsWp/FVzAB1ekrOFcM5GAtV1jHQHjWTNz6uI2ukcg/fNP6pxv/dKwmHe1nVLo
	 EuRXPKUorY8L/o4R2t6loBKxCqJ3Rsvo1Nzf1wvWIgZPTodCmB+HZviBUoeZ3go5sDz4j
	 ETkHvLq0B+Faga9/xfcbHqejJs4xJGbXsppyXiHKmv0NSGZiAvwnvZSgH9NsEQIjYug==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="U2lKkDH/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0741606A326;
	Mon, 26 Oct 2026 16:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U2lKkDH/
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793031158;
	b=WrES6PQi7UVopr/SZ2JajxpXeVbyVkZ7MZZnpduFeAjOFr5hPJl07k6FQT4XY/Tmn7if
	 AN0XA/2lCsHj1Rx48ZB3tfYcN99pND39l5t40pE5Uy+ehWFrKEpahtNqwecYUa7+oRDk3
	 J/WHpWwLgWuO7aj6hX8+ngLdujNSQ93GAfk+DKz6sfd/RwFJehJE98m2wxsCUSS33CjUb
	 hAyeMuq+fTqwU8IY6/6ObkhBUkv8h0SVLhhw3gMstdei0FX9duX0svdt9cBDeNwsLrokR
	 /gBBiRoXNqTx3dm23e4pefQx7nFUK1T5E6LOTxULZi6i+x67Fu3II1ce2KM7pwjQdUw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793031158;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=C8U2KCtW2gkZ7Clqkc7+4hsRlGxw+1f7tFdd8uYfw3c=;
	b=upNvLUwjro/+Wuu2pMPUqGbtZsrnOfmhJdGUsgLLMSZ9BkV0x2PgyogRhP/Ct1UeuMBA
	 3TySKqS1Bw4jXcDbPQAg9BBnlFQpaZ6CHs2oANesFDDn5q4yxc7bBG6OEpHJgQDz8Cfb3
	 G3tKaObG136bbvnZzIUFchqXuepK+YAhrcPhj6RWhiROAQfK8n+sAfXPs9LQCXlFDu9J3
	 tW6PNw8Q7uh10P8MjsAZqkYjY7is2DEOJpYndSX41bV12WhoJ895S/XqK5tPQ/V7dWhbs
	 WGbRRd58MTAnCuITpCiInBRCu2Pu/FUMUtlTsaH0m1u20nSpIiaR6Vyl8NEtFW4rEow==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D6E401F031E2;
	Mon, 26 Oct 2026 16:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793031158;
	bh=C8U2KCtW2gkZ7Clqkc7+4hsRlGxw+1f7tFdd8uYfw3c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=U2lKkDH/C5qkdeMZvHbP2B8V49AWdfHTVYuoZnGIAfKIPjpusnRkFZtoadL8q0F26
	 kuYuLiOkcfxl6CIsNz5C89jeWvlQpI3VLj4iU6lx/L+o0KYR6i9aRQzVN2jhiWGQam
	 93MuJDRZcYw+oWD+SFpoNS3FMBKRal0Uhn1D8iIA2S8G6WCrWvSrzdttZCcAn6pmUT
	 bdhkoBJEfw3iAfRcwaJ9mpaYRUGhJH3mXfJpbLowgrS4Vjy+FdB9libgHNwdC2+SC8
	 z6UgXblGT9IdZhKiz7SqH0lmLgwgmkQ9K8Tcv34G20+d69mXDOTr2XalOaFywXIrJz
	 9b7wf6Vv99KEQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4393744D7B;
	Mon, 26 Oct 2026 16:12:36 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 26 Oct 2026 11:12:33 -0500
Subject: [PATCH v16 01/12] scsi: ibmvfc: fix IRQ leak and guard deregister
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
Message-Id: <20261026-ibmvfc-fpin-support-v16-1-a900aa657ed5@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793031155; l=1764;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=sg9Lbgea4G1OveFwjkYaq90w+e+5hioGkpYGXVuzHdo=;
 b=XZfD35vk6f1v48C9oZxH3Bfuy0PBEgn8Yg8hr2GEXc02S24T6UaQ52slTslvsmUZGoPWXIR7L
 ilFNsVLTlhtDigTnWwDXGwCLcBGh14K58wvPeVLKrDkXaY0MZBPQVoY
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


