Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793655535;
	b=kWYhPYqcKywoGtJCCWUDYzL75qBoMDIx/0bjUIMbm3cOzcms6qu9dG+TWN8YDF5u48WW
	 8ldcaOrpHaUM1bpgqwC7BS/sHEcMAyYby+lJ3QTyjOrrVx3gBmIkRwMGCyhL2llb5qoye
	 uGNGBYNi1nFvGre/qISvS81ae5seJfzuB93MoYXZlJlHrh/XSX1k/5NYBA6voBjmBjENf
	 IS4lhz+1ln54QdBMlu9VyOhiWsQ0UxlktC+pQyeJ9v9fsmo6UesEUiqrw7CgXG70y8y91
	 Pz0fxbkr9OaeHAtUhaFU9mBdEXMX+UhSuXa7PbUCqYkGzHL2VoIIN4BHMPMXjG/F1iA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655535;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=bTFd8OGkOEJ8Ouap3vp9tt8/FXePakiOpC2goVYeBYo=;
	b=VSEqCgHVl9GKl9xUMybBSOM7VceSYjBw5QZQGCx4nNVjP0jn8Su7/zS0YLV2qrIwbTlZ
	 yTCa0fAA0tzfAd9AVGnoLEluhK/Giv+t9sVmLJkz/YKCEx2BYnZNwfB0SNwB1MV+spLJX
	 r3GVF30DsqT0/FsBT+yCWyvsqdxDwGo2tyTFw/6LjUv4KjXQ1pGQlpIi7AUtarw2DYalM
	 A1Lvz8MKGx/AiVkhryfXc+Xx5VDxd31K/PxNijyHNoB2cUFCwgfJZs64Dbn++IyiFcjSc
	 cKO62rfDOgJb382/tAzbgU1TL9OLSudYD7jFyXMbuJ7ZAEhA3Z2SFhLtl1DBAAJgUIA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="c7///kZC";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9234A606D80A;
	Mon,  2 Nov 2026 21:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c7///kZC
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793655535;
	b=qyYumAWJdiVGiF/lsi1iiJlIBayE/z604TBpEcv8UgrzSEKh/OSf5Ee5iHawYLcw/INd
	 EQN1LIS+Rkzf/dLV5JNcV5xspYu9cUlJ2IOnEuoRjm4zMx6m/bAcGZVkn7Fh6Y/EPEPNi
	 N8GKvwkOI54rOhbCrSF0d2BP/FBTwXG1m0JW+zr7eOrr3YJZ/gatvNrUDaee2BxTr3rv7
	 EWS5LATGs9Bo9iCmhw6kBpB38BuhxjRtNrIyBidLOEKl5foR0BJyhvHkNfjD+MjS4asVC
	 grPCsnOBJGVSQEWI43mLwHFRLwArhjHHl3s/s4aJE6/kdgQqAhnpmzPWJgimg9oQqEw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793655535;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=bTFd8OGkOEJ8Ouap3vp9tt8/FXePakiOpC2goVYeBYo=;
	b=W5JiITyAVhx6O9Q4d8uK3EF8SP26L9bxoX9uKOEAtWXITHirPP1Fw7JLfGUD5rBjobKY
	 y7+obkdhzOCZzuefB43H+XXNpScKQg16dhj8BYiI5UEYgPyVCipN6/crWuMQby+/ddhUH
	 MVWUlhAwoKNvPRGtFR+nz1th1QnHrA8yBJsQRTblcJnjmRw8uOjjEgjedFlfbNgKgkLqv
	 Wky0tKuL0VELyIKgMp/xIqGLPbbN7xJSlBv3Uk4HVYpTKXOkzpfuH3UmViJ9yBiBE9HO2
	 MY4B9EZEDVZe2vo7mqwphWJ4QI4aSiATpZo8e4u4pzCcT7Hvg+TTvk1ZzVix0WDTenw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7F5C21F00A1E;
	Mon,  2 Nov 2026 21:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793655535;
	bh=bTFd8OGkOEJ8Ouap3vp9tt8/FXePakiOpC2goVYeBYo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=c7///kZCPMjBG1pdYqyuK7BxBexKr+wENc+oNp1LvfSLUCm1NQcMX/V1rngNOihtD
	 /TA/yOk1eDEn4mSRpjKt7hy6r8UvWxZ7FGXN2w3VF25aBwKX6NQNaxLUUygMank9IE
	 p71/JqW0YACdjORpYKSVTv4YX4ar0pkmJ0vyMbq+NUTAWRuDCJr0wia0P0GsMhB7tG
	 hA8b2tKXjDK2AuqUOQcxhCMsFCUWF+WJHM5MsdMHBPQsMvfBa8R8hJGOlpev75VUrQ
	 Zs7jskIJfFc59MBPqr2PiGskrFeMSZvhQx5XHpaiRj+tLhJk5HV3IOnv/ewYhaVKhX
	 ekTZOJ1S0BEUA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id C7273466AE;
	Mon,  2 Nov 2026 21:38:51 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 02 Nov 2026 15:38:48 -0600
Subject: [PATCH v17 08/13] scsi: ibmvfc: add FPIN extended flag and async
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
Message-Id: <20261102-ibmvfc-fpin-support-v17-8-9ee5f195ac91@linux.ibm.com>
References: <20261102-ibmvfc-fpin-support-v17-0-9ee5f195ac91@linux.ibm.com>
In-Reply-To: <20261102-ibmvfc-fpin-support-v17-0-9ee5f195ac91@linux.ibm.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, Dave Marquardt <davemarq@linux.ibm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793655530; l=1878;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=eFM+z2bDgARR/YdCRp/MotZZJpzrNpdp7FfM06XduFI=;
 b=/TCDaR1JsX0KwcKv9w6aegIVj1AaZ2KiZqhl2w3PdN941PZwOeT2igVNzucii2wap7ja/pZGm
 mcmQ4j6eckbAu0H2nqCjTxtGpah6fP93IeFQPr3c673EKFOc2PRKs4k
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


