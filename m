Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031158;
	b=xeX6SbqHW/8Xhez6bSKw+GJ6uMywgW2Y7zOycsD0dJPPxU+bTD3kXBWqv7gfoY6WTmLS
	 AtkNjTZoeDM++h7wbq6UGOjVq1UqPSIjrBmut/xL4A5Qo4vgHTbH4EfOqD3eMDw2sQzrF
	 QRakbhPsAaEAUsFDjJMAhSNmYNnZbE8LjYsr4SIHuMaLBLCHEZXgfJJQA10MFs9fu7fHL
	 ggk98YnIzcDUKWxGgB9KHSChoEjfC0nxbGr7SKUv4OXFDkVQbuY6rjexe/rvE0PVBwK9A
	 decQBSvcWkIiw3cueO5V88YlW4tuAP4Vuil2Odf5HSB7Sh49lnH+HaFhIKum9QUgUqg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031158;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=6uMcoAQqwVWg4ZD2SLJD0mX50qt6CYwlXqXbX/bVuJM=;
	b=uRFsOsVS8Pgk0mJ3uGHupyOQhcBH+TGkWFtvhl+1waQ7f2EAekRJdvylGfDdJqcg7wb5
	 G3vAiaZlQs9JsHHaTl33nSFhuEQ8/Q1FrlbzP7b1inaLuT5oY+HyMFOJHJQ924KTfVx6E
	 uiSgzzKAwARSfe2djxTKm9CTHHahvZX/5ZzGT+mvKLP5aKkl5Hbfv8Tl0SnVecstXuH4H
	 trOuKXOJK/QAE0gz2SL705HENuox861hLGlVPGYAKDFuxc4HStD4jhgQReMMZ8kH7GKhV
	 mtIfo8t3LJtbs9kLcX3yhkaspkJ5U0XUKeQZQDG2s7MtRZf670/yQiq7iWs62wK3LlQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="X/9EQ19p";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA27606A31E;
	Mon, 26 Oct 2026 16:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X/9EQ19p
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793031157;
	b=ncboZK0vgKOsq3RCRpKDZub6YXgrj+GyVWjgs4ENiZnqf/bAY5MYwFv970Bkyujd96hu
	 LTx7oapD/lL5fgc4mzQSMTZvkmid2EHBNJnVxyCFJwcm8l0DWjiVpcT2sA/XMTQYtFBBO
	 bbHc014HYoVAOFyubARufhPhVaJvJ01+HC+bShee1vh87mP2123xKyx7z9CF+y10BZhdr
	 rjtVQT410aEDZFaRa9hqbkitYJ+kb46plXngCsMbxxrEOU0rVxTxfkUb0fXKGaOI7uwlm
	 XVPrILUpGKROw2ReOl2TGHSbTDAfgeW73ECfjfCmAOXh1MY/KncGug534JnE1SwoKKg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793031157;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=6uMcoAQqwVWg4ZD2SLJD0mX50qt6CYwlXqXbX/bVuJM=;
	b=brJBazGgNdA0NDKnRgrAvjoZkYZ28zc8/NS+NgxmvIFusmkWp7e6YOQ4V1nOAxEHAyPn
	 LmvLsUvPpaxzYMXkeVE/TQU+Y2mg3wpoaEdqviLhEeFhL5AkNqr5VZ/ILGFuBlbtyZomY
	 /5uw+lXsAIl9q7agQUXbyP4WUb5Hv0yapm4eAxR9s4wSlmxMvJPFtMzPgm3icv8gjCwWV
	 TUQfMMpk3w2zkM0K1mcbBntTIJt+ev0UCnl1l+0PKYpyUtM90DwMPgaOvlj0YrfzCTUTK
	 hdR7a5cxocG12eogmK7pUfdD40z1ANAyyTsyWSaM9zkIEr3M077M8ASh16MzFRvfYeQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D5D381F01829;
	Mon, 26 Oct 2026 16:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793031157;
	bh=6uMcoAQqwVWg4ZD2SLJD0mX50qt6CYwlXqXbX/bVuJM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=X/9EQ19pCfF6ha+LfKjJLeqHt94hbjVOKDlWPdOUNkz2gxKZ3n9F5RN2G2SN+lZ8k
	 OiHqxgSyDrKBHdvOchcrHFRsxVuI350klfpLKJDAsXWGAESYDkTdPPpjWAH32WBvRn
	 l7xPPxGT/CP8WOlBtXnAMr2V+07hopDkyWGDOvjnTnCM70oDyo7mBdOtAh8rw2VPRw
	 j1AAALZYCAcFyf/yLiVYszv8Aj7WCdEs+vaR3Giae72lg7ivIlYCRD3+TO4/KII3OU
	 8NTQZ+1iBTZXe4kVIqOdN76e/emLLEZ4KVZRponVDuZwZFfnlOai+qubNcu1xePOTe
	 FtiPDvLWgmANw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4B73044D89;
	Mon, 26 Oct 2026 16:12:36 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 26 Oct 2026 11:12:34 -0500
Subject: [PATCH v16 02/12] scsi: ibmvfc: fix potential clobbering of rc
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
Message-Id: <20261026-ibmvfc-fpin-support-v16-2-a900aa657ed5@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793031155; l=1351;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=nvE9rGLbRD6+mhvHw9wBWLEiRdGSv55IfTVTSl/45g0=;
 b=Hjm7diUp5Mo5hKh2f5/03Lb2FOe/gXl9qe3oHiM0UoorYWtmloijaLbSe9SN02JSBWzMxPoq+
 7yVtrbeusSBADhnh9BziKIt3x0F6amH2s3R43fe0yCVFhtgC1FJDdUU
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
2.56.0


