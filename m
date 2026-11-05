Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793899380;
	b=uySgFlH75MBegxphUY5NSJcPS/7VCldalZE30TlF5QDyOeQw/27CokMxSAaMaIiesXjB
	 txJiebgVNVKQw9qkSNrOiY/d53IvkmgXuOVJVYVvN4N0gTHs8VuxyzthiwONNDMtBtLqn
	 n//5NRnYCgTqAlj959iNQpO7DubMCEeRjjK1HGREBHtdCthdLB8tWHc3vZLdXsLZLdHK1
	 w6V0a+XFAuYqvIh8Sxm3vfQ/+xMsmgdX7ZILYtPPv7qx3TpfHhsH81WqouhHWp5BBP6p+
	 4064Pl6+kJjWxkZ6Oqztt3CWD4sTolNuH0TXCgnBHBNJbVB0AQ+QXGhKMLhFU+Bbjhg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899380;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=DbkrQequ7AF6sVYRJT9J5w5lL5iEEJOND8Z1gQX388Y=;
	b=AMNvp2aivfsUI6PNn77QbQi0UhlthvVBt38S9b0fJVrVBGTimUg2u7eXVUWRFhgA25QZ
	 I0aQD4vBX9aOw3m8ACRDnX9Jaz6IYwHuo/S+m79vy4wpbtcIGcCXALxmfofPThs4DsvVo
	 mQznfCi7QKxwz+BplUeyIe1DTe0kMNYG3WzGU72HUiNVyV7AaL9RMXsUcF+qtHTrD9Yld
	 j0jvd0+OKdcGyExrQKvSz7DaXwrRzPkdPugzYi7z/1VKc/XKSitI0jVOlca12S3iPPoNe
	 9iDWDHFUifZ2gKCT8POvwwtfYTLceHOKlzbNA/R50UkvoNTXNf6m+xpTnZ9UH9YFSww==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZMYJ1Vm4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E603606A334;
	Thu,  5 Nov 2026 17:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZMYJ1Vm4
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793899380;
	b=rnDESjUoD9Zo0mbMgdFNu1FE//cSAD9E66pNjQS2rqaXY+xmmsrlZPJjn0UbPEMp5CZZ
	 vWJ5vJbdhC7j0TaWTS8fHTF6F2V1ifp1OVKbYb75Or4luzW3T9DKmq8ZZ8xQqG1kppajx
	 GSwO/CBdHb+zoKS2QQehi7G0t2qTCgHd79WF4V3JOaOh6ckT+ewO7qvS5LGpITEod/QH9
	 dsrHPU21fkXZ06+L2fagEN1vf6PMDSjFwytvs2+tge6y81VmwdFlGt2VyCK4P7ox394k3
	 v7k1SFaYNqo4hzD/vMruvZiWr7qPzeyWackTIGqzvVwkyWmUVAd8BojTi0+b+XeYusg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793899380;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=DbkrQequ7AF6sVYRJT9J5w5lL5iEEJOND8Z1gQX388Y=;
	b=qLKFbK8GTU+OQrpbsnEO9s+UdwEct0QnNbtOrlgphlLR93T8PtErcB3ykKgBAyl/brlL
	 7lVrn3c6BBQCOIIUkhEC34FRufqWiiqor9SKWm0/Wwo4Yk0NY+EyUN4diCmivO0oI2ngI
	 +57J+FKF5r82scV32CLMthnwiXy5XbeMplhx9rmY0nd5MjeRDbzC1qllLpVRi8Yk1+Afd
	 Y1MloaVSXKTbzHBB0MrEsVPfGLFxYBJJiXtzLaIRmvU9YtsyWWZ1h6T6GBfqf/1xSJutK
	 xi0NHkxQSmg4xWWQKb2EDBfoshNDiGirC9LS7vN02FIdDkEbRy4qQ3A5VC4M5jgiLKA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D74341F00A15;
	Thu,  5 Nov 2026 17:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793899379;
	bh=DbkrQequ7AF6sVYRJT9J5w5lL5iEEJOND8Z1gQX388Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ZMYJ1Vm4J9RlcrzegVYnko1XQsb6OdKR0ktr/aNJFtMOEHC4zH5RqfHBuQLF3Xf1n
	 C3BdHPsMv5qH62tEAVamC4cvvGFlqN7O8FFwYAVwtklN+ed686lA4Q0pwaldPxTdC7
	 QVpLcHSEZAShETAsNHhu6gxkrEBlKJWTdNNfVsp9KC0SWhnc8Xslv4gJ0E3wa0c3Ct
	 2JKLJZmttmxqL5PmhQ7VOPZNapcwGrqSXuz5rqnAFQoiejfSFhZ7WCTT8uLBMrUFXY
	 rqt8tAij6+SZ/seMobhD/9i9yv3jEamzde2IhzxxNW6LzI7+4Ta7zpga2UAG8tpTpk
	 JjHEZBWuDZYcw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 658984737A;
	Thu,  5 Nov 2026 17:22:58 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Thu, 05 Nov 2026 11:22:57 -0600
Subject: [PATCH v18 04/13] scsi: ibmvfc: fix stale rc and IRQ mapping leak
 in ibmvfc_register_channel()
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
Message-Id: <20261105-ibmvfc-fpin-support-v18-4-d683b74736a3@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793899377; l=1891;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=/Cbr+Mc/ALiDF3jQHtDNe+BbKVW2N2r2WvK/BWAfFYc=;
 b=tVml67lLM6wXTRTbvn+JLgoV/vd4gtFUfxD9UpPokHEUWFEFZXQzhjo4JZfCBUe69tw2xSAsb
 DnqgxOTxIN/BjSOyQuvufPgZZg/li0M7JV3bkzqPRy7aBhjPdlW4sMl
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com
Content-Transfer-Encoding: 7bit

From: Dave Marquardt <davemarq@linux.ibm.com>

The default: case of the protocol switch in ibmvfc_register_channel()
jumps to irq_failed without setting rc, leaving a stale value from
h_reg_sub_crq() (0 or H_CLOSED) that the caller sees as success even
though the sub-CRQ was just freed. The mapping created by
irq_create_mapping() is also never disposed, leaving scrq->irq non-zero.

Set rc = -EINVAL in the default: case. Introduce an irq_mapping_failed:
label that calls irq_dispose_mapping() and clears scrq->irq before
falling through to irq_failed, and jump to it from both the default:
case and the request_irq() failure path, eliminating the duplicate
inline dispose/clear in the latter.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 65829c3d2eea..77c685f6f959 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -6429,16 +6429,15 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 	default:
 		dev_err(dev, "Unknown channel protocol (%d)\n",
 			channels->protocol);
-		goto irq_failed;
+		rc = -EINVAL;
+		goto irq_mapping_failed;
 	}
 
 	rc = request_irq(scrq->irq, scrq->handler, 0, scrq->name, scrq);
 
 	if (rc) {
 		dev_err(dev, "Couldn't register sub-crq[%d] irq\n", index);
-		irq_dispose_mapping(scrq->irq);
-		scrq->irq = 0;
-		goto irq_failed;
+		goto irq_mapping_failed;
 	}
 
 	scrq->hwq_id = index;
@@ -6446,6 +6445,9 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 	LEAVE;
 	return 0;
 
+irq_mapping_failed:
+	irq_dispose_mapping(scrq->irq);
+	scrq->irq = 0;
 irq_failed:
 	do {
 		hcall_rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);

-- 
2.56.0


