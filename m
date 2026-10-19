Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792448154;
	b=MoLHVuJ4lcJdZW1pIeU7+5AgfbqoJvC1cq3cyzeK1vJAYQrrbHj7E9CJ00J453jGFL1M
	 Xhgxhr/DIkm03jEL+G5C8M+hmVUmhbHrjuQtp/HXDJgRi6sU1e+thOvge26thYCqnna3I
	 JjGEwcs0VFj4NBQb7DBlW67gM2xqzsl7nCcDt2GeLgjSaP8ZFPryYDUVxblrnbhbuf8Ow
	 RI6l4NGMlr9cfSGOe6F7uIjF0PSPM8eRim1tPv77bPxpuI3Rkew0P6DEhj9rdPuSldzpx
	 URZuTFsvmYekTs71n72mFejeHEgiZW2AbV7/cdfhDmU0bxDDscosHAoiGaxvJJqW+4g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792448154;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=bTFd8OGkOEJ8Ouap3vp9tt8/FXePakiOpC2goVYeBYo=;
	b=KWROpPZudEf3VbOO0S20Ci046lxdVJekvd7vdoadAsb+00gwJYC/clH24EyV2b7UPc5C
	 tkxqGMoE8y7/OoOtW4H7Wb4FOBHLwET016DxtDKM+3UJItKdaXwFBHw82l229iG9US1sA
	 v/Cp2Mf4oOuAU7BdItei1Expqi8w9+EvS1Ha26ypiU52ehNO/1GVQI5KnmWr0SL/4tBfh
	 gPCipLKybERAuu0fDOTjxmmQ5bP6zqRb59XvUX2VntZTc7skwK7sf1emrfvm/cGSfC3KR
	 ABH8Bh0OXC9Xek64QPYdGloWHxyeJD4wZCQhm6Y1GTH7o0SM3QUdaw7V7eqImMcCuZA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="IeZGE/RS";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B594B60A2603;
	Mon, 19 Oct 2026 22:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IeZGE/RS
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792448153;
	b=C/os7R1O1QOHUOittRwqpIRFDtPZ9b+xHk/arb9WsXNIXAuaPo34RjK4xnVf0RvJB/RL
	 xSF6euapACzjCxc7QkTHclx+lVJyvd1rx1sO8lXiyb39HjCX29pMWyiLy2JaL4WxcV8sl
	 7njEKYp8LH4qF+Tf9ipewfkhJd1xSrTGOjgQbL7FOsNbR3yeUZeu+X7+UA4DRgc+btJ39
	 KnXnZTuOp/SqQqmqURhNhoitlr7ikzFjYUXtcZwo1vZbvPzRYzIy/sPTLStuZ6q8aQei2
	 rEg5Q17TUcnSKzp63Kq1EC7dwnfHA9Ax4b4Q/9X9Ah95bzJ7SAw3fxAD5INRx0FkXdg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792448153;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=bTFd8OGkOEJ8Ouap3vp9tt8/FXePakiOpC2goVYeBYo=;
	b=BhY4u0YWW3C1Z182Ja4iWx2X2eIGzJiMFflNZHA6VwWvsbOazNWVKhrKGc/eSO7agseK
	 SDnqY8aVCkl3XB5w8v+X7KGKn+MmvbRgW70eQD9mTrmhLYkwp2T6FwvX13/R20KFzfOfh
	 PRgx3bTWr5cb//xh+T0fkg4QQN7nnFmvpHfrk7574Y0XXrxo+EAJbPz8PZqbCNb3w3Flz
	 0UH+hcSkCumGGenfP6ZZuHu6ufTnhDAZpLZUt1Akcih2ezzWhOE+qeIy9p6V5bPMlm1y4
	 JeR1JOxa6mGwppUMHLrALfr5dUSvcuM5abQffYiWafJBe8piVYw2XjO1E6kyufNLOXQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E1FC01F000CA;
	Mon, 19 Oct 2026 22:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792448153;
	bh=bTFd8OGkOEJ8Ouap3vp9tt8/FXePakiOpC2goVYeBYo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=IeZGE/RSXUNVYeLP/mgrgh/YRNmiqZDU5Ozx/gOnro2V1lJ360Zywh0YorhegMfgA
	 wSWl8HUCmBwwxwe1vXhVvdRWxYk0QLldovKDo0HniiYjza5YpFiI+bm1pL/bjS2fmf
	 ZXpR16/AjaTYs6TcWZSXvlwlKOEgHhiMVNwV/cVoGGqetnkOpVherDkPNi0aP8XGBE
	 l8BkRXYD77l2stKrTjjJg6Fo/e9W4SfGdklPjlW4dTdbO1QlAorFbIlAmXG3ZFFhkK
	 8oCBb1jJhRQjMw4jgbTIhv7BfCUiBDIIVJqy3MebAe1JYB4gZu5CC58rmv87eENmQQ
	 K7SWXoqDRu8Iw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3BCA94066C;
	Mon, 19 Oct 2026 22:15:49 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 19 Oct 2026 17:15:51 -0500
Subject: [PATCH v15 06/11] scsi: ibmvfc: add FPIN extended flag and async
 sub-CRQ queue handle
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
Message-Id: <20261019-ibmvfc-fpin-support-v15-6-a858726e178a@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792448148; l=1878;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=eFM+z2bDgARR/YdCRp/MotZZJpzrNpdp7FfM06XduFI=;
 b=SZJ4UlQWT8AEwZ5OZpKKZwBZhlX0lUtVsMLYKWg1FoT0G5NuNyz2/1usJzey+bGKPZPps/17y
 CZbNwcYgu+ADRUlOkFAiCm366mDEzUm275hfNQ1auHEPSl/FQOqXaR5
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com
Content-Transfer-Encoding: 7bit

From: Dave Marquardt <davemarq@linux.ibm.com>

Add IBMVFC_ASYNC_IS_FPIN_EXT flag bit (0x02) to ibmvfc_async_sub_crq.flags
to distinguish extended FPIN events from standard ones.

Add async_scrqs field of type ibmvfc_channels to ibmvfc_host to hold the
channel set for the asynchronous sub-CRQ, alongside the existing scsi_scrqs
and nvme_scrqs channels. This uses the same ibmvfc_channels infrastructure
as the SCSI and NVMe channel queues.

Add IBMVFC_ASYNC_SUB_CRQ_FMT to enum ibmvfc_msg_fmt and a corresponding
async_scrq pointer to union ibmvfc_msgs to support the new async sub-CRQ
message format.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 3fffd2db8ef5..2ecd60138d58 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -773,6 +773,7 @@ struct ibmvfc_async_sub_crq {
 	volatile u8 valid;
 	u8 flags;
 #define IBMVFC_ASYNC_ID_IS_ASSOC_ID	0x01
+#define IBMVFC_ASYNC_IS_FPIN_EXT	0x02
 	u8 link_state;
 	u8 fpin_status;
 	__be16 event;
@@ -893,6 +894,7 @@ enum ibmvfc_msg_fmt {
 	IBMVFC_CRQ_FMT = 0,
 	IBMVFC_ASYNC_FMT,
 	IBMVFC_SUB_CRQ_FMT,
+	IBMVFC_ASYNC_SUB_CRQ_FMT,
 };
 
 union ibmvfc_msgs {
@@ -900,6 +902,7 @@ union ibmvfc_msgs {
 	struct ibmvfc_crq *crq;
 	struct ibmvfc_async_crq *async;
 	struct ibmvfc_sub_crq *scrq;
+	struct ibmvfc_async_sub_crq *async_scrq;
 };
 
 struct ibmvfc_queue {
@@ -992,6 +995,7 @@ struct ibmvfc_host {
 	struct ibmvfc_queue async_crq;
 	struct ibmvfc_channels scsi_scrqs;
 	struct ibmvfc_channels nvme_scrqs;
+	struct ibmvfc_channels async_scrqs;
 	struct ibmvfc_npiv_login login_info;
 	union ibmvfc_npiv_login_data *login_buf;
 	dma_addr_t login_buf_dma;

-- 
2.56.0


