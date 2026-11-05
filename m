Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793899382;
	b=ZDcL6x4EVKe+413h2GHCeLX4NZztylG9qXFAWib8Zsgg9+NpGKt/bqRz19/V+w2LvXcv
	 K3+X0ik16AgY8wCSThKr746Og6teYDosFxHLGq27PAx7tcUwagk49oU4ZHZIAMLZIO5pe
	 +QI/VrdH3QzOg7VPDD/ASEiTTtorhI7TwxmaqUn9bycZVjI6mlqUK+T3t0L3IYOMnP9wG
	 lTLlj2UU0y9RvKMIe5JRK/mPgj9T+X3wF1LkvghSuSk4gTggCZrqfo0xyQTRO1uuOCkAJ
	 wyIbEA/7bOsQQ8tFZV/8uN2Gr3U57j43AR7m5RzrGwC13AOzpK5xvzqGmfU+b/7gXZQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899382;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=bTFd8OGkOEJ8Ouap3vp9tt8/FXePakiOpC2goVYeBYo=;
	b=sdSJAkZ6OUWQSwWAimsiv4kcIeD7C0ZxGmEy1L7L76uJLyzmiokMhx5Ba6hsrWJmZotA
	 6rxXHY1X9NDCLT6VvqX/5oYJf9UhhwNJE5wef6HcvY2UKwKBVuXoVQluXNh7e8NYfpo2n
	 P7lAVRKJuSMHje0HMXArE3bKeFE0PcoxknLXGOwgudA2nokIJymsRHFaQfZ0p5YYaex9z
	 hM1BOcRk3gPcX82G88I/rsDK9cOVAXoqBf0wCnLxAVrKNXAs2bdJ/sUo99WX0S/iIM3hS
	 j9Ef+enBxpUkaPpqEJGls49UvbYvHWR+j6HqXHhchZxlvWWR7AsMkbxf0B7356MTo/g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M66zh3t0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AD8606EE86;
	Thu,  5 Nov 2026 17:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M66zh3t0
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793899381;
	b=gqaEr14cTpJ2pLvtfvaMu0A7f3YVT8fH0iCSlXuCllJdkVpmZVNp2PpzznwEvZ1z6CvN
	 iRZpGVcGkhiUWgdQ0JgBXcJ6qxuXFNemkEtyfCw6BV+M2JEZgMVCJgt00CtiOgjnSwrTW
	 XrNYeqXTs2ThuzuyK/rBezc7Y/8V5EfvCouHGHUYQ8ve5QpFdlQCXhXgK8nhBl4XL2rVw
	 CJTQ3CJ61+mJR65iFky+sq+toqBGUE2xXXB7ShiAu8SfUiZmpFp1CAekRN62DuCNnWMSw
	 uM+/7Wkw2q02j20eyBheW2r8PWva3XpGY+HQ0gu5D6/2AGKqkcjpGjVSeVcSjjC6cTg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793899381;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=bTFd8OGkOEJ8Ouap3vp9tt8/FXePakiOpC2goVYeBYo=;
	b=gTJtTIAMeaSoyTz7rb9Gl8+youDdRDnFB1mEpL5Wb/2Bxmzbp9fnu9B6GKczJU5VW6AB
	 hxmuTTxS6AFwQ6ic6vdBc59CoktGGND1asDAjDvSHnORrVmtfCe//YW5ij2tEXnAzV/Yr
	 7mxnFSnVhj8jHXePitFhGqOhIbmaJXfpE07f1E5zvAbmk3FCGvXx8QWW2YqRNJc3OxSz0
	 5iSPEqp3fnUvCZpPO8ynzjash+NSuAP115UCdmuPsl3c04TVZc77CuJzPOKIrDVna9dLt
	 mwhldsHQeRIO0rRKQ9an0Cc6Cq7OVA1LBK30zZdo9nC/TbtRuF9sbMAdjp46oH777Nw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8DF8B1F00A1C;
	Thu,  5 Nov 2026 17:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793899381;
	bh=bTFd8OGkOEJ8Ouap3vp9tt8/FXePakiOpC2goVYeBYo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=M66zh3t0runKu9aY6uPqFX0ZqGjrnv2oPdXYp6XTUnE6Hgm1Q810J6YQtqjGwDnDs
	 x5LubcqA+2HHhKFchW4FKwvawaYLYFI/vhDqa0I6l3HG6F6Tpt7JvnnmIqhUEBEXq4
	 iQYjmNm8asPSm8+a4NXx7JV9RRtQY+lTw9s16xvpfd2BpdQ2018g4LO1YyG/QXTOo+
	 eHm+U45aAvDdRjcEe3dsMED6pAUUJiiwbliRxYxP1MKtX8cnOKWEtqJPj0ikYtJiDA
	 903ljZkbZ6J3PczDM5vaNf62u33AKQXn+NJhQd/4EhGwHZLG4H8NHwTfAE2EQx80LG
	 Pb6xq+VkmWcuA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A53334738A;
	Thu,  5 Nov 2026 17:22:58 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Thu, 05 Nov 2026 11:23:01 -0600
Subject: [PATCH v18 08/13] scsi: ibmvfc: add FPIN extended flag and async
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
Message-Id: <20261105-ibmvfc-fpin-support-v18-8-d683b74736a3@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793899377; l=1878;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=eFM+z2bDgARR/YdCRp/MotZZJpzrNpdp7FfM06XduFI=;
 b=KOxmuR3dGvoGh4qxvvT1jrRtHZOqaJo1/nmkIBjgxNO2TwolQWkqsvt3TSQi93O7oOK0MNzDQ
 SBbkwJQV5D9AdONqfiyvBircSsleiH/XVElw3jDdqy35AXbmO6AhUq1
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


