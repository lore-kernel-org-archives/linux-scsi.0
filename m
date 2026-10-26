Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793031158;
	b=Z+RUX4i9io2jomKvOnuRD3MLbXpQwCFFIqLgGPCWEx6/bEmPmX0K4apl1514sbQdMsDL
	 COVrNhJaRInXbTWEe/n0tn9cP3sKBqrmao44iPwMYp5pS0RRReHRC/KnrwpE8YghyU0A/
	 ZNkb8z5S8vsyQBrT/djI7/aAUIkViBop8sQ6YxEWGQudplpZVrMrWhrQ3VSkJ7B7SIxZp
	 cXQzT+SmUuqL7mWCUbdwmZnbU4+kwF5RTdSgUWgAvTYyfITW/hJYUJLRFJN2zQLma/wtq
	 lv8oKQiZLwTTChfaC+MhHq6oKxx3sd9f9xrlK6SSxTEZcJBylV5rH32ac9bcf2Xwp1w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031158;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=yIvHoAB3QiQTSr5VvmXbQfsjiNaMq0CJYAyB5/lpaDs=;
	b=Jay8c7O8Z9hsIkPYax7Dr3ssrRCFvDiun4TyE6p5FKlijjsDVy4ySZPDHz9/4/DJhpR4
	 movMeFDlDJA6Au8J/SufZ5hJDr0yAihRB8kch28NGwzfRGMP0YK/KTvC0iPs0og4wLDWo
	 Y8PUaP/+fwcABifbEr6EMKAINhteTEMoRQfgPY0g3ms2VR/4GUDDTwTX1jTG9+2UTx0Kd
	 2GNzWReBv73/5cDrWhJ59nyNgRgHK+Y21yFFRwFPkAdDykwwmTs/A3TJN4TIW2iVB5FaZ
	 pGqPxV1/aNHb9EYMgmacF7pKBHy+7+0yEPTVdyhJacSq7TIaTD8hOiHP9PYx4PXTpRg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kkf7UKe4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B51606A31D;
	Mon, 26 Oct 2026 16:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kkf7UKe4
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793031157;
	b=qsMvsBaXQxs3Ou2sR9Fu/mzpNy5mxVMR2H0Dk6dJOvoW9TWkX8liXvKS6B2Ny6Lqh+/q
	 xkG7jSFbB7rHFcpkaKXCbAV1tU5M9VuMSaQ0vds0pEz9ajo6AUypmeCq+xHAu8MBfJb1f
	 y3lSQC+11MTX/cRM53sb4EyUheT5z33KJudLK4R2bkbXPmPSPeKNxWr4F0AUftFGRMAhi
	 eIAJ0ixEGnL8t5lCSPr5PnNcq5XhfDEV4rLS+4O3ikck/YSlmFOP9XnW9djKPzQnf2rVK
	 3Fu4/4OXlAsF2Ybq451VJ1S4sruykSaAjKUgJTbUZN3yLeEDwjS/dDwNNr185MHVpqg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793031157;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=yIvHoAB3QiQTSr5VvmXbQfsjiNaMq0CJYAyB5/lpaDs=;
	b=k58cddvCm0lCTzEc2nu6V8D8q/LFjQS6t4HbGbQL2YQekyErdzUaRhlEDq6P0wI7U+Mt
	 7dXN0wPFf+EfNbW1pSfUWtSO8yFxz1D4506kcgHYQjjAwTax8jTi2xkk+kewz8wjP3Jea
	 x+up9vXhgWj1G28k9v1LFL3e3FyMahbNFom+PAcdtOw9CHBeOXoFwZ7vpeJ1Ru757S1W+
	 ucbfhycuhjEG9SDNfv8g0FDvs/nO+68lgv7KpmEz1N0TP8E2pe68sS047efDDKVS+NAEE
	 jycPN/N5Gmvdag9qh4VW+JQWR5i+rImVmkr+kyS0c5lktl14pl0ZJwVt0CDtC3A86Tw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D5EF51F031E1;
	Mon, 26 Oct 2026 16:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793031157;
	bh=yIvHoAB3QiQTSr5VvmXbQfsjiNaMq0CJYAyB5/lpaDs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=kkf7UKe4xq0KPj2ONxgS50xj5BHcvFVSjB09Cso6x+TdKY2Mu03c6fATz4oYGKpM1
	 14PLWgXrZiySjEv9we4iXYoiSMxGya/ei3iJgR5La18/Drn1Jin4tPDVeNlN7AwtPo
	 CW1J2pTq1SKVd5o5UyLqe9vkC1i5GZ95NLRULdgY/vMaPgKkEqa8VfB0GoAwOXrhFQ
	 oP73ycXA/TmqIxRotbmhsLS5QsBEDt3GIpmdrrGz/RTq1rgI1orANBRIDP/2jbo1RV
	 MnpoNArDERaxdcmkjByxTqJ6Tkv3Vns3dZRqIIVWywZsU7JGbfnsrKJTGobICbEQTT
	 AcsDxvyq/B58w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 5CFDF44D91;
	Mon, 26 Oct 2026 16:12:36 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 26 Oct 2026 11:12:36 -0500
Subject: [PATCH v16 04/12] scsi: ibmvfc: fix unguarded dma_unmap_single()
 in ibmvfc_free_queue()
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
Message-Id: <20261026-ibmvfc-fpin-support-v16-4-a900aa657ed5@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793031155; l=1500;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=K8OwCqpjIdXQs2e8AVALRObhwpPT1iTdETPfLazYtSc=;
 b=Dexqw2leNcpZewS1JC4j/KbcXR0M45KWWZfi/aW99Wip/kOL7bdhSIpZO0Bf//5EsxgwI6RiP
 4hRHTXobUPcDVvH5YQXhoNaq9KIdsqcNMovr0KY0raEpYZi5KJ10o5A
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com
Content-Transfer-Encoding: 7bit

From: Dave Marquardt <davemarq@linux.ibm.com>

ibmvfc_free_queue() unconditionally calls dma_unmap_single() before
freeing the queue page, but only guards free_page() behind a
queue->msgs.handle check. If ibmvfc_alloc_queue() fails before the
DMA mapping is established (e.g. get_zeroed_page() fails or
ibmvfc_init_event_pool() fails), msgs.handle and msg_token are both
zero/NULL. Calling dma_unmap_single() with address 0 is unsafe on
many architectures.

Guard dma_unmap_single() and free_page() together under the existing
msgs.handle check so ibmvfc_free_queue() is safe to call on a
partially or never-initialized queue.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index f0502d748210..b63b341efb07 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -913,9 +913,11 @@ static void ibmvfc_free_queue(struct ibmvfc_host *vhost,
 {
 	struct device *dev = vhost->dev;
 
-	dma_unmap_single(dev, queue->msg_token, PAGE_SIZE, DMA_BIDIRECTIONAL);
-	free_page((unsigned long)queue->msgs.handle);
-	queue->msgs.handle = NULL;
+	if (queue->msgs.handle) {
+		dma_unmap_single(dev, queue->msg_token, PAGE_SIZE, DMA_BIDIRECTIONAL);
+		free_page((unsigned long)queue->msgs.handle);
+		queue->msgs.handle = NULL;
+	}
 
 	ibmvfc_free_event_pool(vhost, queue);
 }

-- 
2.56.0


