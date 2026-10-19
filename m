Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792448151;
	b=1mFdc+pNrI/fh8adb7nZnETizO3cy6wNJAv3Kvl/1OSEC2CTi+MkESXgrn92cBgNBPAF
	 IKZLndH4TrF921cIltHbPrkc3kBQo3o4uZ9n4/MTS632nXpMlx41KknahneMKsgc9erZW
	 gs9tpARdJaH1h3pYmryXTJ8928pH6X6G4/l4xjSQpAERB1zbaTTVMrXi5nT5J27z/ySFk
	 rAhnW8X3h6fYKMGBgXl/03HlKQe8l+R+yRRpvA8sqNdtj5h5klU5bbBM1yxft+KfQP5q0
	 6i8XRFE5FLnSlVXm9/UF7iHZapdwgVscK74CJRqWlgy2OYPKqgxCi2jHHBUsHr0u3GA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792448151;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=6uMcoAQqwVWg4ZD2SLJD0mX50qt6CYwlXqXbX/bVuJM=;
	b=HSFS1hfRH7/GIh3mOzpgv6S1zUIfpwNOHkdw8qSW9pcscqRwiOUDFVNo2PwxWK+scvq3
	 XKIeESirJUlc4d24ZrpiLjUvIm2ADU36PDFAtgbMQbfc/wNSAEWCR4GMBDvdZuj93l+rX
	 RPWpthh78uSs0l76LN9bbDpF9HOQRFFkAZmc9gU3nhtaWeKCvL91iqRw9xvv3e/NrWlWd
	 /yfqoGwPIzrR9UnJXGyg+FAYItiTWmBkpS7XzVbhjAqaLanjCS+j8FK34YtrxwwTYuJqq
	 7OFKy7byQZrKzXk9n3nDmOe7yWXaYrfV58foMSnxWoWpHnwJmT3sP8WinVOKq/aQKFg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GSnGLLDw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1D3606A31A;
	Mon, 19 Oct 2026 22:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GSnGLLDw
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792448150;
	b=Ao+Ok/icZFn1UylAL+xqvHF3yolmErdBjLr/NoDmXVuA5YV5YlAyBSZR+av7u2p19kUI
	 m929qr0jKh9Wq7gDmXWT9fiCwWa0mU2lTk6rfILNGrKYM6yu9Ct123JPQmq2M3KgE0g1e
	 hqDRPBimgVIrJ9X6eZR6PoGv1APNHRQZdb0Hy7jMWQQaBbJHTs4GISNgfw9wNdvp/vzsV
	 5/NbXmxLTeGLloj2GncY6rrKEMgbjAbRcTf1cbdODpinAAytAS+KeSc1xauApi52FXLR2
	 AC6Ri7Vtxj7WdSawmWTxm1WOCxlKa+3N8Gu+uTuraKLdsTZsDyjzurUP5NDEp+l36Yg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792448150;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=6uMcoAQqwVWg4ZD2SLJD0mX50qt6CYwlXqXbX/bVuJM=;
	b=hOFMoUAbAdtY9oBqN7CzlYyGvAJtZvhVnffUvktkgxRaNt/s/sCmaGxE7U8UDqwCys8p
	 bdOoWyH1sXtNQRnuoCovpAKSxJ/6llDwQI0u//h+q0aV7l/hXxvJ2jPsw0cFaitFt2LZX
	 i5bv97Lk5QxIy/fCpvNtZErGsChzZZ/wp+bLCzbsW203y32VEiObFKKsVcfrayUsjShI9
	 hDK+LCaGDOrBdSI3B1b2X0Skd1Rkp4/EbItd/ST5bbKqCXpCsJ0yHZaFRFZWrjuutGgOq
	 Sfb6WEoqeIoq5pkXqyKHJDpM91cdjaoSoWUAFqPTvpbL6yzTN3wROMW4fRRE1rsryZA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BCC371F000C6;
	Mon, 19 Oct 2026 22:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792448150;
	bh=6uMcoAQqwVWg4ZD2SLJD0mX50qt6CYwlXqXbX/bVuJM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=GSnGLLDwUph2o4XVsYEia1Eoo6LE8IUbIq5DujL7XrQPF1yqIUzf5vkn0jO2jFx1Q
	 TVxLWqK+xDvK3uKWS1LXZ+StFMKQcZ+wvyyG+KVEjPgQITlekjqMW6rHaTCVG3JjxD
	 dnCsnaIMDseGgMXXl66/Z1Kt4QGpq2PI6yK6TxJBU6TduF+QYhi3CPja4bxCOdxhNM
	 kVTXfDNqODoA9GLzAaeBt+uVRpl9iLnNMjP4xSOlQsq3A/ZwspxcRVK+jic7GBvF0P
	 GASLslKjrMfBv614OUvWgsVqrTM/pjx5xQwe0yYUrKSUNITJ0IvysBq9ZXavUf9UpA
	 jx4ldiqqjZVUQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 249D040655;
	Mon, 19 Oct 2026 22:15:49 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 19 Oct 2026 17:15:47 -0500
Subject: [PATCH v15 02/11] scsi: ibmvfc: fix potential clobbering of rc
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
Message-Id: <20261019-ibmvfc-fpin-support-v15-2-a858726e178a@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792448148; l=1351;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=nvE9rGLbRD6+mhvHw9wBWLEiRdGSv55IfTVTSl/45g0=;
 b=UXwllF4KNBbvbF1qYV1ZWDQsmIndMDHIp5NjLU1edJi2Qgu2LPJSjUc3VS5Q0k9umZ8cuW2HQ
 D/XEIoWzj/dDIvjsuaB+8rLHdt/TH9XpSgfsoZNc2d+07NdV8hp7khC
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


