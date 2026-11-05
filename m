Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793899380;
	b=Irys9l2LX5+AHY0jcyJ05WHoQ5yaWAl+yRuG+5pd3ARfwoW6usnzD3na/fgv5QcruQbQ
	 DPpUIPDY8Vy7uI/36XYljBEw2cRqTyT064kLymXei1TwJlXyIrjFjK0CPuSdqImyTY455
	 S+iezrIki8+OYRn54oinu9+oAo6dADnpNGgPVv7g9JU23Wm+7w5cfau5reSLrCNLXKzWM
	 lj9gg0cv6xprc25ElLl/mmjIYdzDw1+QI9871YAMZAKrbmrJPOh+NWOohIcLwYSCyV71W
	 0SnQ4pR/3hYXqpaXQa80h4qw2gxRGMbYrWv7GBu4038bfsU6Clh0OY+VFnauNoC9OCg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899380;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=C8U2KCtW2gkZ7Clqkc7+4hsRlGxw+1f7tFdd8uYfw3c=;
	b=KJPPYR2/RFR8dugXBgcj4pbXwHRAIhkzWgA1Q//yx8aytXPRW2/+Zpbxp45C6p42Y4i4
	 ukWadFhrdqXT4l3Gqvl9dNHcipBdz9GEpK1Sy2LOyvccimlSc5gxdkJHRYYLIgQXvYEWr
	 rnZj6hyEaGskRHihOisZAhj9SqGKD/6RYZb2EnJArTYcLUZn2/Rxp4uhtVrbk4Ob/iPFw
	 b1EZ5mz0k4s+3EIcs/j4B66MV1KEUq8C9FhYoplYFGnyN7fG43IxwgXzebEfXvjQ3PZIV
	 ucT1ylPbPhyU0cNDBIMbOdFb0Q0pEIes52bqRPbn8E+RlE8FfGQVatMORSPRpGF49fQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="UfSZA/29";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5578606A32F;
	Thu,  5 Nov 2026 17:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UfSZA/29
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793899379;
	b=bBMG8mML/pn/b1n1iHLgsdHG/9yWFeM3bt0hXRp1Ba7BxPkrLscTkeiNQ5LRKWXnXTiO
	 S+MAgAkoL/BsP74yOMLqAXDQQX/Tl2rLAvIhfIuNlBk7oVkK9U8bZajMa/czgvZD60h8G
	 okt29yDtifN5hfLJ///slXRKwrQbSVkRFhf8JXxtHGhTNHq2nbv6dp/inFTlVmS5UYlF1
	 VsNIfnKS5SY+1eJXhHLp8kVwl944kWsnG9m3nbuCFwZM45sht0xV+D5mCcqfwpDnHUW+O
	 mYwbh7Ca657NW0x7D9IzXpFBp201omdD80WOshBY3epSXtP8ddQZhsFM3cfDx+TpjdQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793899379;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=C8U2KCtW2gkZ7Clqkc7+4hsRlGxw+1f7tFdd8uYfw3c=;
	b=Tw2kslxDOlut8xXlm/dEbIe4qvznlHl3LWYs9BF3e+dnCjPYQpjYfUwXLaPqAmI1beDJ
	 9Q1aw2CvEgIpTVhScHZGmG1Xepf71KVZqvWAZZ5UZcJexk1P6CYSgKMOQpISvnoAV2oSE
	 ecLfbwVc/KQMfp2uxNn9EUITqcMylT7B/+YaUX3MPHWlzaOu2ZBAtxS8R/X6uhExdvguW
	 43x9V4kDXke/P4pFiX5fXm+cGRjp9+et35a5Ax6kRnLqmY0sSMIMffCG4PeReSPEeZq8t
	 puLp7KkTP/XqkBJvRiYPAT5dvXglumhtYmHOITDi1R7hO90boEjy6jkAK5j+iAorwww==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C35561F0093A;
	Thu,  5 Nov 2026 17:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793899379;
	bh=C8U2KCtW2gkZ7Clqkc7+4hsRlGxw+1f7tFdd8uYfw3c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=UfSZA/29xF14R8B8joRstOhluBmewgMURYPXh4t/uOucWeLq9FTEy2yDy5YOkjDu2
	 VowqcGy64gGpGLe3BnNFekZeUZdifN/w86iAZ8uNH4YjxkPHOHe1eRd0FA6iJAqsZv
	 zLhBEAqs5nPwF1XHtqHk7KICW6Il6H1k9vqT/OAdLZZ+eEI7nBMTDLgCf/lxI4vZKP
	 xma8M1BOlk5NgChje/mSNskc2wg6teiHgbNpE6HAXP4a+uahdWuDDcpwq8JlbMSH01
	 CtBaZDJKJ0MRvzS6QUj7NC70+/NhbO25gCeMie8dsA2J/RJmvS02Lt2LanjTM9w2Xs
	 ws5Uf1FUw4bJg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 388B04736A;
	Thu,  5 Nov 2026 17:22:58 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Thu, 05 Nov 2026 11:22:54 -0600
Subject: [PATCH v18 01/13] scsi: ibmvfc: fix IRQ leak and guard deregister
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
Message-Id: <20261105-ibmvfc-fpin-support-v18-1-d683b74736a3@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793899377; l=1764;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=sg9Lbgea4G1OveFwjkYaq90w+e+5hioGkpYGXVuzHdo=;
 b=kzuAwRrzj/87SL7IW2LrsUJeY7mTiiLjjYCxMzcXZtnXPbJ2NEoooUbnDtO9YpLq63MeSpNs4
 qaR8MBXoE5+D2x+vr+7JRpswGlK/bLECQYZtvxYOiUKxIlBAFX7ssX4
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


