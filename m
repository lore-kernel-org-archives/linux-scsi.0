Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793655533;
	b=HGBXCJ7LeIaocfs/SAgh+tA4tW0CckWRp4dO8iRYnU16eu1kE6WsFgnr9q1L8vnt1HuO
	 XzAiDFg51/IKmIsmfkJC/oPddzyAnSOX4ffuzZOSf62AcUYtqWN/8KFIhkMaM7LZ8x8o8
	 093v4IAiwzN1zYCySwTxvfntUFD3MMpufxtGKlhlnDGD2JEb0UqbxVJvLOUzxlGzkgUzx
	 7/tEp2Og/S7R9h6LCiXn2SephQ8Q4HBQ+p7ClUvHkd8xwNZSKMaav+ClejM/huwuueTWv
	 9MgylL0wEpljQYLTtJ91TIlrhU4jGAEnN9TJWBLxGa8wd6/ZvZKnWVqsFK16cFPqdcA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655533;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=6uMcoAQqwVWg4ZD2SLJD0mX50qt6CYwlXqXbX/bVuJM=;
	b=e7cZwayv6YrIJ46g1+HfGaIjcLmHsb201pJ8uqXWKziFbsXwvcwO3kQYD09xuWfOYx8f
	 cnVbQQ2+k+ZdAsXdI6wE0YS1zoqUtwUWXs8nkXOh2Wb4IKgBeJ499TgyWXfId6uotDfaB
	 5NwZWI8nSMwI4NMQyt3QCP24SOmZJ6yF9xvSqTdpzyOM8tnj0bOMZ79c9akPi0v8pvlyX
	 lPk+LZCnTMaYEIzMUOGKqW7SRf22v4k63SWmhXn3pwpRQo0rz2bwuLjEM+CBAO/UOULpi
	 /VZP/28qS+tViZiwc8G12D9qNZtrUr6NQJT4NavHMHU/Ed+OPr19fqNj6sCvgcqa/Gg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bHFgGTfI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9C7606A324;
	Mon,  2 Nov 2026 21:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bHFgGTfI
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793655532;
	b=bF/+sTjlNSeFYijOG+7FwInKyi0l5BBJXOEA8NAANRutEcLY0TWiUc2lEn2SN3twRGA1
	 ArA2/KErIR25CF6rPyFvRwuT8ni1Cc4evdo53O9KvsPR4CNCGH4n2amEU6vuvnjw/mfOC
	 KP69e07n0nIpdOVLFZkYc9v5kM/XGmXaTt4tVteHYA/8sbUWx/1LzaGOTwRTyHKb7nfuT
	 6e5wrryB8qHAdLVLuavE2p4XpJQyA9sMQLdIsv9Z6rSf6SOyOWtMufoYwBti98USqgQf/
	 nwhr0CtyUfZoXhaYNE/V1v7BcKCXV+tPSodct67+fIkI5iavYUplwePBtfCGXlrkKSg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793655532;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=6uMcoAQqwVWg4ZD2SLJD0mX50qt6CYwlXqXbX/bVuJM=;
	b=aVAzzDN3wKD5D+wmaqLeZwn/p2PMkJOCP5ozkVrYCzbGtay936POeHeugjO/mDlWzInQ
	 KClSgcNuUpWkFLaKEhRdWy9wL+n+gHCg+WJ/mkpH+3yFfNlUyAdMmXl7sS5TYi8QLDqdI
	 Msdk+UHZJMe987pFkPbVxJrcta5X5sEK0DEWI11/EnLl2J4DF0ZiNQPsJMICY5xkAoQaA
	 0YVDkoA6GjlSiIfVLnfBDA+lhC+1nf0cIa9V7zwy8lwjMyRCdozl9yFk6Dk0jWCjZURuj
	 1jknSpZFM+Tevup2fGmwT2xCy3D+KqAmFq3hn83vOwr4Ge7J8MLkEltS2i+ur/rnR0g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 04FE91F00A1A;
	Mon,  2 Nov 2026 21:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793655532;
	bh=6uMcoAQqwVWg4ZD2SLJD0mX50qt6CYwlXqXbX/bVuJM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=bHFgGTfIMzCVO0azWM5wgNzYlGa6t+4b/aK5qmJJPKqKaeSIl52PwRohA3NVDuQyR
	 aiNK3IcbG6pHh4eQlsuiH6q5q3OakDIgxJMPyV2C+VmjdvUhG4FgVGYBUMUBDwnmL6
	 Ck2MbbU0kHU9CjHRMNEAJzHElXq/NSyb90P8TnMIIGGqNd2AY/zT+53tZwg5QqJTx+
	 yq+fmb7ja6FcJboGwcaU18KrJGL9T0R2R5fcqHfl/Pw2uhAWTwuZGHXY55ADLMmH05
	 y3TnotKBfU7D1RgCUnWDhYgYSa8BKzAbawmU1Kk3yKs1+WhothiBrhjAYKYGtUpjSg
	 2Ow7nLRC9WWlQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 780D446696;
	Mon,  2 Nov 2026 21:38:51 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 02 Nov 2026 15:38:42 -0600
Subject: [PATCH v17 02/13] scsi: ibmvfc: fix potential clobbering of rc
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
Message-Id: <20261102-ibmvfc-fpin-support-v17-2-9ee5f195ac91@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793655530; l=1351;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=nvE9rGLbRD6+mhvHw9wBWLEiRdGSv55IfTVTSl/45g0=;
 b=Gn0J6Sj5c5wVSjj3vX2XD2tpw/TAGyKapYrc9nynV/VGQVXO8mbB5x4I7WFTOkJ2m8NF0KTK2
 J90PQvKrKKwDI/IPI+FgHxxzOo7uNp79X4aZnWvWO0EwSx/RN9uEgmA
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


