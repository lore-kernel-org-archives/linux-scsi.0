Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792680369;
	b=v43ka9/jlQYd28Z0/c0S9peHOnc8kCA5bxjeOEfcSkbpqqbBK4hNd3QO7ScOeWVjhyz/
	 nrzT5F6XoPaC3RxVyaCJv/C3eYnV8WYSyn6lHlH0mqXdl/luERPqSv1uflg1daQdHvk1s
	 VKfmq4J8wXdmXELPaueY1nv8o/A/0trMMgZBi9WdFMtNteeUgvQ4VRUA5XxqHVof/1I92
	 HroK0yGbkz7obXcxjwf60JpjiqjoV137prDhjRFiSieYRZRAmZ/ZzFXnbJX1vIACiKJOf
	 NfEUhe7BRQnASPsEHL/rpswGm/yrW4mubOYvAioFBmG+InAwDbZs89T4ht71wV2rPxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792680369;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PrklBKkcVwO3V8O9sw0CVF0qG6S9AFzj2KttEqdFQnA=;
	b=3d3IcaZo4wn91oY0t8BDEX9NFvuqG0L/tUPaD1joc+EXJBQnexoi377hBep6EeBO4Ep/
	 BErc+Hf3vqN4QpHQLLLDJdnjmZ6cV6PzH5DLjEqANsDDp6cIZv00ADmE4RqmrGSqongFu
	 EzHBiplPlbBDOxpO6M5ZF1GQWyWMru+2P8pFN2+yLkPsuWQw1JSVCFusSRXrI68rw6xO5
	 Ycn4E/ZnnaI8IrxJR1oOY5fj3g7zuiQpRVyRUoliVwQu9kmoXpgEq9yoMyLlpTIJAguVi
	 MrTrrdlmZdoC6nL5o3pM8V0vwgbvzp5G+0AvoJYE/eNOYTMPV7L4nm0wzkzIvzEegVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=IBNXlLqR;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E53606A320
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 14:46:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79E53606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=IBNXlLqR
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-35f1f76ea84so2786685eec.1
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 07:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792680369; x=1793285169; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PrklBKkcVwO3V8O9sw0CVF0qG6S9AFzj2KttEqdFQnA=;
        b=IBNXlLqRHyQGCpmfqrAk1ZBu2PX1oPbKF1Bzom9GXmhEu8LizS/ke1Fvza7ZyQfshg
         QJfTtjwJbSJisBpGdbuCV6LR3sIULH/hhUEfl13j/0rDedXrLHtF48OC0dRRoG2j+K+Q
         ybkLcWhu9uHq5h4b1MyTK4m0g7V6XM4zv1/UjXnaC4KWAh8xZiIPQduDV/7gfJe0Fzg0
         oaWWwrioxkk5QqRpIwqyfO8xzv47hgaYrgoHaNZbwvEOHEoy7nQMOc12C4mOIuuBu1f3
         3SbnjV39pX/g9v6ptoltyPbXYq1fdsMg6l0b7AYcOBHEbfA3oq58WUIh4Ilh2iG0UV9Q
         aDgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792680369; x=1793285169;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PrklBKkcVwO3V8O9sw0CVF0qG6S9AFzj2KttEqdFQnA=;
        b=cW1zgdEzAMSe1tWVaFo+hsLmT8ySmyHkgSqrcqn52flspcKm/rZvYlqpMlwERrwqWM
         WJgsVS3MJS9PqldXUQlG9i+L4FNYQdLr4EMTLeJvcTE3njWT2zVAtw6lNUsK6H7nC9oS
         muKq9mKXytZ9rukr+9/Q0YmbA7JoADGxGH0FYWvv7SMoBh2dXbU+hcM1dw5Q0LEYjcTM
         4XijUELci0R1BNLhNGU3Azr7CsDN6xiO27r3a8DDomStvp1NBZ5Y5XhM8ByPEdfmC79r
         5tsBGMMqNfalaIHB2pB+2zDueFE9QP0c9ZBMEsGnmRQgPfBuZUvzxy0FzkK3TKeikVKD
         zFOQ==
X-Forwarded-Encrypted: i=1; AKwUvBze8QHCP5LeFOg7HpNGY5i+9EHjPXq4bfpVYtiPR/gCcJ1CPQj8oHOc9ZvGc8jgoJaFjD6ApxDc8Uei@vger.kernel.org
X-Gm-Message-State: AFq9FYI8YTYHuY9Gu8mPR/I9yPSW+Q4y/FVqCYp+Y7d8AmnQTBz5nS/Y
	ozUdIPT9m40fGgRaWhEt3oDqgoJ5vM6ut+G6QR+uPHrtxPyQPE5C/t8=
X-Gm-Gg: AYBFou0bFSLENpD2jqrf9EHIoFJPTE6FAwY7yfssKpt0GkPkxdTqWmqJKwTwTuZmCVc
	IRJW+a5lRudgU436r8AsIacb1trbEsi0oCUFNrjXuAFYm4EJCvv07QMbicPoQE+2ukwekrvNddG
	4BUEzVxsS4TS/YqNHCaJbtqruaX5fLy/PQ3nqrI1zLlcjYW3UaMjVaqtEF9Imv5hjZ6dLP9G73W
	6cX3CZor0yC7okibbb1JkkZoNmVqoqleEZV6JvZp3KmiHBNO2XBg0AjkfHM51DNfvrLLStchV1B
	8+ImH/x7gq9AxGm+U+ziVXu5l6PyMFAsLFGeoTAkStLvR6qcNsvp80GR1EBYmYFvZo0ngTePsvx
	3MtVQ7QFVGVkP2q14G78ZJQ2g4pF3yhwdybUpap3qCpi6l88hUb0DpAwd1Dz3rAr24T+r2zaU9g
	hUmqSUjn9WX3+BzstWKGCfOyeQyRPRa5lu1/OlPYvMLagMfoKetaAJoRBe4ZTIJlv69Ru5cBna9
	HSygZRcYxySRGXc6eNZyiP7xxPGhvE6cvapBtcV4zk4aR6Wj6y3P7YVwzHah3dT8efWVNt4iB7U
	UNsJhKr/32AzXm72BSBK9gppak0ofrRKbjviwNqGkt0=
X-Received: by 2002:a05:701b:270c:b0:190:d9bb:281f with SMTP id a92af1059eb24-190d9bb28b2mr6570477c88.18.1792680368388;
        Thu, 22 Oct 2026 07:46:08 -0700 (PDT)
Received: from anuj-MacBookPro.. ([2406:7400:63:e55a:5016:92c7:7a35:f3ff])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903a275026sm23625880c88.5.2026.10.22.07.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:46:07 -0700 (PDT)
From: Anuj Gupta <anuj1072538@gmail.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com,
	kbusch@kernel.org,
	hch@lst.de,
	sagi@grimberg.me,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	bernd@bsbernd.com,
	joannelkoong@gmail.com,
	miklos@szeredi.hu
Cc: io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	joshi.k@samsung.com,
	anuj20.g@samsung.com
Subject: [PATCH v2 4/5] block: map dma-buf iterators in blk_rq_map_user_iov()
Date: Thu, 22 Oct 2026 20:14:55 +0530
Message-ID: <20261022144501.2478417-5-anuj1072538@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261022144501.2478417-1-anuj1072538@gmail.com>
References: <20261022144501.2478417-1-anuj1072538@gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Anuj Gupta <anuj20.g@samsung.com>

A dma-buf iterator can't fall back to a bounce copy, so map it directly
with blk_rq_map_user_bvec(), which already handles it through
bio_iov_iter_set(). Fail with -EINVAL where a copy would otherwise be
needed, and update the blk_rq_map_user_bvec() comment to match.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 block/blk-map.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 9cb9605d1f62..d1e096fdb03d 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -459,7 +459,7 @@ int blk_rq_append_bio(struct request *rq, struct bio *bio)
 }
 EXPORT_SYMBOL(blk_rq_append_bio);
 
-/* Prepare bio for passthrough IO given ITER_BVEC iter */
+/* Prepare a bio for passthrough I/O from a directly mapped iterator. */
 static int blk_rq_map_user_bvec(struct request *rq, const struct iov_iter *iter)
 {
 	unsigned int max_bytes = rq->q->limits.max_hw_sectors << SECTOR_SHIFT;
@@ -506,6 +506,19 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 	struct iov_iter i;
 	int ret = -EINVAL;
 
+	if (iov_iter_is_dmabuf_map(iter)) {
+		if (map_data || (iov_iter_alignment(iter) & align))
+			return -EINVAL;
+		ret = blk_rq_map_user_bvec(rq, iter);
+		/*
+		 * -EREMOTEIO asks the caller to fall back to a bounce copy,
+		 * which a dma-buf can't do.
+		 */
+		if (ret == -EREMOTEIO)
+			ret = -EINVAL;
+		return ret;
+	}
+
 	if (map_data)
 		copy = true;
 	else if (iov_iter_alignment(iter) & align)
-- 
2.43.0

