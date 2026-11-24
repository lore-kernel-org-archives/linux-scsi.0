Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795537028;
	b=d+L/I7pu/sU+rjY49dtZF1K97i5lCvmTQkcAs+iRwEYnLx0lHBtHBKLjKP0crVn7JbC1
	 CVsC7BrQghReDbrhmsvBq/Dho+5ElDx4/e9sUzg6k/c7aMnOZAV5z/0URWBydL+fj9ei6
	 LNdC4kqc50l2Tmfvg1YuH8Npip7OoFGSq138heTmHq1qod4IFB0rLh3yOokjU/owxz4sP
	 7a2WFBTAKK2SNThmvKMn1mJDm3jKT6bISGkWirndd/koQxCcaJLwrvegEmRbm8yr9yuSf
	 qCJJwm7CZHzUHDnV7ohbxHh1rXRVIbAIa4KOhQSMlJWMLrJhHkxDq/S3hsXZ7Ua9KNQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795537028;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=tVNJOytWifN6I1+y0Luo515A/FqN5Ih9GKjanGVd58c=;
	b=go/f3YDadMEbCRhi5bgbLHw24XMhGEQk+71I+3jEK5kuV9M81Gs/ZUFAzVqtkJA15+yl
	 pdDJBTGlxwFvY/CTY7NEksQL6nb/RoyeYjJBSdFdY0kkG863QnwJFHn4VqOQrXuW9hYy6
	 xWlRTGQWYg64F+h7ZIJYTedihGwH3yv0yRZHFFsXckyEJO8ROZ8BQ8NpPgodbmBcJqD2y
	 uMEJrEY0hT/17nKDzkI/UEDPgaFO0yDl+vd9vRnQCY6LKsxhyeRomG5rkqoYGCWwI17Lf
	 ALLfr7BUDfstIJXm7SWFoy/7JrP+IFfD33hiO9/gTb1qWsFArqz3t7JHRpb6J3IFZtQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OwY0JKE0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA13E606A332;
	Tue, 24 Nov 2026 16:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OwY0JKE0
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795537028;
	b=e94Zzh+DXX9YxiYlJtQ57ljEXKjgyvDbR/i9oiHGIffulx2eB2VOpRUj2xpEvJoeno6z
	 Y+L3fL9fltg7pExLnEnvmDp5JiYXmG9BZeJFd/P7TIKUWnjHsAPcustyjknyULoiS3JJo
	 MXchrZ07MfC158hdbFic8nHFfGExGEzhWVC/yZZpZ+YQFtsdgh9/cU8AT/89xMCjSU1UK
	 jOcnPj7lQgNb3HPMnoj4gZdH5vLVvPU6mdgMvGQ8/wWyfsPwxuKkBDMCRN7UvMC7fulkn
	 NU8OwfKBbv46H8RYLU33flqJ8TvoEfoQ8psjNhUrZK0S3lK3C3zrhcmSyAKFQSez9oQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795537028;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=tVNJOytWifN6I1+y0Luo515A/FqN5Ih9GKjanGVd58c=;
	b=pSl/f2Dj72JWnsuvHHm0UvX5hUV8Z1qFSxN8bbhdNscD0dhwy8j4QX1JAWgged65jvpG
	 O+4iaZpTMue+w5R+PYFsZG5jUx/gM9hXeskleQKBGWF+qTjs79f0UTaGMQ8+sud7QLRbM
	 SDVTki7PLdkxsg4bQ+YWqkbc+KjX6hiqYaw1gG5wXoJSRdB/a+MtArz2kEj4sf+U24qCV
	 xrtDodvUsQkNLG3y+TXxAL9SdT1X7mYp4DrjrXbbiQG20vo72OeivD7RLGi0xkwV9G856
	 tuaKHWwfA1X5beKBxAsNk2xU61wUut8xjH2ZxWv9oEkqwhuS8FFiyl/gZDyfmfW+UpQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 44F571F00ACF;
	Tue, 24 Nov 2026 16:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795537028;
	bh=tVNJOytWifN6I1+y0Luo515A/FqN5Ih9GKjanGVd58c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=OwY0JKE0xEavZSXJh9jda+IPLqT1l3D5sqhfqIDoVa3ReiCCEA5BbW5pMnhh0AfA4
	 cn19vEBk4iors70Nbq484TizNX8gFqXZfxH0Tgf/pBa3bVSBFeX4hbHnPqiy8TCMtn
	 qF38kM0akYifpqGjLfEqxLOKYSrjwWaHuIXvvC5UjUMvbYNsSl5Hs9gHM4oEhUlqWo
	 YQJLVHzdEp/KRm57j0CBKNIFMHYLWd6at1oIpftCHRn8E+92Kw4soDDWyQfn6TzOuk
	 lKtO/R8H68DsZgmcAkQvJC1dasr1lsDYpxjMB8AaboeJ95U/pKcvVB88Bwsv+uyk8y
	 /PDfXQocTXhjg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 55FF64CAD8;
	Tue, 24 Nov 2026 16:16:47 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Tue, 24 Nov 2026 10:16:49 -0600
Subject: [PATCH v19 08/13] scsi: ibmvfc: add FPIN extended flag and async
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
Message-Id: <20261124-ibmvfc-fpin-support-v19-8-2aaffe5fe7d2@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795537005; l=1878;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=ExqixlvvA86lyXEcBnXxlhcM+a5JReZNm1VDambrNMU=;
 b=t6eN80gfJST/4gQcDH5O41OGnmJOLnUjbBwfkASWZHsjN23URVjImdHpcY43rkRNrQrXyKJXg
 YHeebK0eW/qAKL0rbwmrZk4AFt2CviSVG4QxrBGas8tPH1CtGK+h3FP
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
2.56.1


