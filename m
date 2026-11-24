Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795537011;
	b=X0G/EW3LXy2qcyv7VGvoNVnLIK7KJ98wQsiuRooSaL3eR5659eUhyw+OwjlehcQMspPB
	 AdqXTnG7XQVQ0MjZNQfRxxTZ5/wvaDdgMzNImpIzCbB/bhKTlRy9tfH9hFmMhQA9LLprB
	 4Lmfqb8/ljkxCtnLmzHEne0deZnc0FlbiO5yxf9GmX8lHA/EEJdvSbmSKKfeZC8xO5JBr
	 qpfMqsn3BfgAsmbNSRRUCc28KsA3kOXOC/BIi/kSp3gig2hhBzD4if36hq/0cj5hTdlvb
	 G3+O2TbNDCJq58EmAOxuO64CNSDvQ0lqDQaooLqBR9a370GN6DrrT7q/G+fSaZPWIYA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795537011;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=gmO8WK/XYAGFz3EaR4NrkEaqBQyrDCkQ7hDGo7QdChI=;
	b=Nhrt/gEP4gpxWgDdUGUqOSOX5oV5pKDOsFTpBGcehjcQpxILXz78rFIDE4GgqgnljvCX
	 DlEHy2S7HmdoghO0rz7o6Gh8Zi8xLUlkAaua1OH5WyFOl5o7oPaXA3cVgE2unzI7UTeBm
	 6aFT+C86pygfg6ZPVjTh2ihnYyN/kke9OpFgmhe86mjhduOfBv1rXv41X/A7ufh1cJxWR
	 PaVR+GG+wFo173Sxb3Io5gTFAwk26JJNqXEDZkxFgH281e5JsndPefQbvYh3Snj15DlVF
	 xgb9wwb2b+ytKsjI6oPoQd1Xle+yI1pLFPAExA9OUiqZ8YMeTRa2ggP1xRo66Con9Jw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nP+bcFsF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC87606A331;
	Tue, 24 Nov 2026 16:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nP+bcFsF
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795537011;
	b=FMFTGezFGd5xkKWlM8Z1QALlGL0TyPLbAk1makGFZ0OhWN7cBtn2p03qNQeqs1DrNaa+
	 Rm4kPjzxdm+kLSJuIjLhxwPmR/vF9rJ2Xq9z2FZJ6HzvYmPNlVNdKv727PAKnCa/Sz9Xo
	 akHBz1tvaZYC4HQaLY/N0oRV5GNgEYT9n9mtleeBwR89YQPLCqIMSbPejuKeC0t2+lkNI
	 xqvJ6ehSZs8G3QAcYxBeiAXbvc9NuJydyFW0DQ3rWKv2/rHwx/0ykzJgqYWR63VVNFeyZ
	 sXhvsVqzBS1fSM4RmY6FUb+C7Fju7hgj7ONNTtJa5F8yAlzYugUWaynuOk98sEQ9AOg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795537011;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=gmO8WK/XYAGFz3EaR4NrkEaqBQyrDCkQ7hDGo7QdChI=;
	b=AMoKAsI9KKqgxNNpRCGiqt6SWEDh4UCW0BF2lpPA/c5V9sCeUNElzzw5+pDZ04LBHRe2
	 kYLn/CMHLBj9lSYNqtwRyBdHIQh9O1ANL7s/Y7OwDYjxUiP4jBTLyA8oyZnGpqgPl6inZ
	 4sW79dx2DcQRYRvmY32Azs9f2Ao1O2ZIGa8ncV5rN42UPH+1mTvzSdaWaRTvuEHkE3Ai3
	 bA6xnPd+cXW6vmLxXiCoPSgRRN8oPSa3lHobVo/PUaHMsf3zWhUZqzc5r1xV7BF5IWW8X
	 CLSUrL7pn1yBPPdjpIdywWe6zo5CpfSQYcfcSPZBVhV8/rN8TFXLdlCI/D5DTi4G1oA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2001B1F000C6;
	Tue, 24 Nov 2026 16:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795537011;
	bh=gmO8WK/XYAGFz3EaR4NrkEaqBQyrDCkQ7hDGo7QdChI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=nP+bcFsFkkbxOKDpXy0+Uvo9Vt2gqCGYySGEGgkkWHWDyJ1ZenUcsD+Ju167WcZJR
	 Uo7WxtC6U9J+jDR9pZBJCU6Yh4goO5lPJb59PaBNb2XE7qG/Ht1vQtnNzNumEoJ3KE
	 W1Hot+pHLZvnIezTdn5s39XNY1UVnRLQQ2sr/T7bCrDkhNbxMZCHH2iswgEzGrdW9v
	 hDW8X/FIJDgfq4yRZvwd4UKkAuRwP+/7lKsZFOyN9mWj7/exgaa9FzfgH1KbyPlVUP
	 oYwhKXTGN5haaJhzLE6qTrv4JadCZdByjhGvILbaF2Ay4zyBgG1VamzWRhm2gBQuyt
	 EBsquaHOk7QfA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A55E34CAC0;
	Tue, 24 Nov 2026 16:16:46 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Tue, 24 Nov 2026 10:16:43 -0600
Subject: [PATCH v19 02/13] scsi: ibmvfc: fix potential clobbering of rc
 after failed irq setup
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
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-ibmvfc-fpin-support-v19-2-2aaffe5fe7d2@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795537005; l=1351;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=B2oTXqd2z+xsBH3KJ9um6J4W5WfCu3b/JIH5kj/iEbo=;
 b=4k7QnReDZKjqkEOwFGxtpXE0DUSi8VPXfwXO8qC7ktKgpa80rlMxg8rCKwjG+wDRVHdhpujj0
 YJZo8AXan7jBmVB81D+iIw99owT6lgrxNmI3zoV37hTHkGaoZXd8Z6w
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com

From: Tyrel Datwyler <tyreld@linux.ibm.com>

Fix a variable-shadowing bug in ibmvfc_register_channel() where the
irq_failed cleanup loop reused rc for the H_FREE_SUB_CRQ hcall result,
clobbering the error code returned to the caller.

Introduce hcall_rc for the cleanup loop instead.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 7818838669ae..145d559041f1 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -6391,6 +6391,7 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 	struct vio_dev *vdev = to_vio_dev(dev);
 	struct ibmvfc_queue *scrq = &channels->scrqs[index];
 	int rc = -ENOMEM;
+	int hcall_rc;
 
 	ENTER;
 
@@ -6446,8 +6447,8 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 
 irq_failed:
 	do {
-		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
-	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
+		hcall_rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
+	} while (hcall_rc == H_BUSY || H_IS_LONG_BUSY(hcall_rc));
 reg_failed:
 	LEAVE;
 	return rc;

-- 
2.56.1


