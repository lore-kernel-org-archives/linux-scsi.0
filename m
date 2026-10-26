Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031159;
	b=BDVAJQjCxsf72B5tSOuHtU32ShRkuSZImVyyBDsxTX7062/QIIcLfhbWAZ0nZ1Bl059S
	 k9YI1Tj3jRD1iB3AjizqYDkrVuVoyOjNRrJDU1Drr2zVmn14HcsTOo5jm0AaTGoFSOMMh
	 PCvbDFUQF2gAAzNQC0JJyHe0WXxcWXTYTBgc2lr9dfx4rNRIJjanVKMk/hvEMU+Wweuid
	 94xMSDxgg/PgXSkROX3S82ZPNpAkPX8l1MhXnNbkMOg4r2cDc/Xff35m3Wi4LgbGvxRcF
	 MYpBp2tjiv1b7x/8JE73i0gPbr+cGbNYaNO12Cc6eQ9CSEwQvKWQTRoaaorlQdx/FLg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031159;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=bTFd8OGkOEJ8Ouap3vp9tt8/FXePakiOpC2goVYeBYo=;
	b=R3+SWw/tMKsIHHkQFgXoaka2dD4aGvHhkZjj/0ef67Zbd1irPnNs7dvn8jTmeU4GM8qX
	 kf2Fu7bVlkjFdeZE/qhWDlV5FZNVnNZY/f7gzzyxaPGLRA3+i7fUAZQV5dYM5w8cDRLw2
	 S1EVJkLXGrbfiv4VPZBQhYsU0G3gTWU2Zz4U0NNOKrrGRFi3u1H+Gg9JwQ6rzsrPLeqyB
	 m1OL1f84OCiJ8ZjIleM2MvVywU0zKPULgrLrOXc3CBecffbnvaT1xUWXVTaR967A9M82v
	 9uSntxhXsKnnsTRhJSPlC3DdCkl0WZ3YrxXknwB/xIl6FqTL8g6F5x7hLPKhJ05/jvQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BdSwOjJw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EB4606A33E;
	Mon, 26 Oct 2026 16:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BdSwOjJw
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793031159;
	b=DRfzbQhHzUMpvx6mbPw6CGjGAwF8i8TxUexBfi8dZQ7bCdnBOCoCqkn4RYp9wT/WpeO4
	 slir4nV794f1NugoFb/B3NTnx2S8MtLTXYAnQbe3eQ5PTGjeerf3+eJpnJu1IGjSbIuHT
	 0LzksDfuE4joBrj1v54zhSkw0ll5siRHrzxMLlm2WjGa3tMSTl66XiE+nQpyHdBFyRjFO
	 TEIY01a09aYGo5eZr/ahzqc4cFKV/UNLUt/gJyKr1ab55tyxGGSNN7Dp8/l1c3tWemdqw
	 /CYKS7dHCDcgWg/4GZx6BzJ34Sun6d4Z4exhvQJhHCsHmQSf+G/40JQtqtc8HHgzpbA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793031159;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=bTFd8OGkOEJ8Ouap3vp9tt8/FXePakiOpC2goVYeBYo=;
	b=kxm+yWFLUM946GPwz/Q2t5vxQAqjVC+iCHcWyB1mFhBtI1k4n0ZOZtPsC5Ag9WNlFfie
	 LggXiNbFt0vwSyeUt78pCX2FI+FcaZt5Z5mccdROuGlNoDR09v0vNQ8IxvVwkXc5H8NBL
	 2e5jFg93Nbg0KA8PFO4qu1sY1QQWg99P06p1x40tHWSbeUQxgrIrpTFGlVZq0JGE7OWMx
	 855hPdWvAujL6yV9K1B1miXiiqC1K2ZnFmYWSqAHdZxzW2VE1Ubnle642HaoRoYyQmATv
	 gvfwxNiwbY2J1QKvXGNxNLciB3Mt/g6+T2twS1Cua+G4culRNz+xaKxguXBcukIot1A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 74B0F1F01825;
	Mon, 26 Oct 2026 16:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793031159;
	bh=bTFd8OGkOEJ8Ouap3vp9tt8/FXePakiOpC2goVYeBYo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=BdSwOjJwaIlkCd1asQWKB3Jn2xLtBe4ybI1wkXnaiyq78F+6vzfQVlxgYi17KHpEe
	 SoSops65Mz8x+Y5etlehj5M5dpAO0S+JlMcbY8piTzKCz27y8QlZxlddRcaO5nbB7Y
	 UZ3zE7pRF0NNHhvVhcp/0fqRCcELzTnYJg+t+q3+fLb64DSuzYDvr3JabZYNmDBYGa
	 o03sFkpiStje9743P6iQF0Nu+2sRSPQkQB7IX+hgvOtiA3TTWdNgTzmNNbdVQnZXck
	 Y5l5LOfvO4fe2hfTNCf/w9rptX58jOIfByLecM+zamTgIIfdktTrT8Oa+/Lbg4mPO2
	 FUjjyWT0x9N4A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 785FD44D9D;
	Mon, 26 Oct 2026 16:12:36 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 26 Oct 2026 11:12:39 -0500
Subject: [PATCH v16 07/12] scsi: ibmvfc: add FPIN extended flag and async
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
Message-Id: <20261026-ibmvfc-fpin-support-v16-7-a900aa657ed5@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793031155; l=1878;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=eFM+z2bDgARR/YdCRp/MotZZJpzrNpdp7FfM06XduFI=;
 b=h7Qbag+SBe9EB3gEeeuZ/cjnm0dh2nu1Ckg3bgomtjrPl/uVs8NmXv7KAiXbfYR2wtOivP4C+
 Zt0SSyD48+TBpp08vNzbLmE/Gj/BwvG/WvE/QaJ2LzTc/HTgjcOqEQ1
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


