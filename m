Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793324778;
	b=WkB6RT4aaEPpfvjZVZyi339n3RoRnN/phBt12nxiDor9olmCraWFd7jk1k784icQO5NC
	 WgIHgHQd3fvCq+4WdCfhYwSEgrI8F7Kac/01QJGrNi5Lo0iydf5+FqyIkFGen5TME2MdK
	 sR+d+tkVi8H8FRgS5UdlGz0q4o/0lbO6YBHF9BsK+FIQ5fd8YelAQVZhdg1nt/fE9i3K9
	 nqrfQVcZ9+sceLsC3uAfeun+Pw4SqbD5rwQTfys7foj7B23rRDaN1P5jm+QWYudYaExrA
	 ObDAcjwz1JQ82Z4Fh9Wtcu0by3xB9MBuJdg143k9KC5JVnwBT7W72jUoZYang7EcL5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793324778;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KBjoHjefEpt6gXeu0uBAO7mx6fOzElk1Inu+2ky7I1c=;
	b=4i3lfuSGxp4BZvjuxEu+PAO9Ux9gWqiYobN8ed9CgjXAx7QuZYXRkY5sb33pnH15nyNM
	 hari/NQD0ZwCuoNFM6I2n+5HH3ie2QPNuSiRXK5bXCCXceHZQA4ifbarVRNT87rcf4U5i
	 8QjGzmZZu8abpTK3midZAWb0TaDkvMFOvWlbLihlYrLZQSbuGxCRbzk36uXn0JiM0BDbw
	 XfvS/2cSW8VIX3NVCj7SHu6Vl3Eafh5MihmGQ+0lQwVJZQSASKVEPVT210OoN6DnI6isE
	 MtKrLCL4grIH24Kg1CQ862/3/C+DWlITWsofn4AezDbj5DlNeS6mA4rnMT441EyLCTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QMZuKhWs;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8547606A31F
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 01:46:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8547606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QMZuKhWs
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-3645f0f3fcdso554615eec.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 18:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793324777; x=1793929577; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KBjoHjefEpt6gXeu0uBAO7mx6fOzElk1Inu+2ky7I1c=;
        b=QMZuKhWsa2erUSLf/IY0zFqF2nVXuVqGGow6hvJMlomv9revsAHZYtIipxTsntNl4t
         FQ7slvlyN4kPaRu/yminnBrxoZrysIIsJ6hGIY30J2/8Xbb44S3Ama35r1FCk/14kvLT
         JgtZgKfYW9MheOcj7q9UT5HlPOOWkaLnE5LvDN1lqddtxp74P9bzIk6XnRWxw/RRotau
         CjIsHFxy0GmMzeiHLRePiEBnnNa+IWyO3lPMGziXTaOWZ009vGpGbxKpLu2GRqT7ZMMd
         RhfBQ26czyEpfpIphKYWgg9cDNdHTpQoZLHZ+LFl88pj1WD4gZksSTTyojdHYii1csQQ
         20OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793324777; x=1793929577;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KBjoHjefEpt6gXeu0uBAO7mx6fOzElk1Inu+2ky7I1c=;
        b=HqS7DocRl2JTJXPDvUcfzywR4uxK73Ih4H72QskXrt6l/ZEUU0J/msegsVE/ExCt7w
         haloupFVXMNYBtbhTqPf1oOG47xujRFVYHhjVRnkOQ1HB3KPjHniCYBfM0nMLQ9cFyBo
         IZeDc/dNLpQZAGd0C8/SZOGYQXWAtl6p7Gu76ABL+Nx4qGPBxpb/+AUk6qP6ubnGnNI5
         JJ4LAzV52jaNtG47Kid9PuRvjj/oH1CHx/Z/Q7+B1ld6VjWaOkPEph8NnrnIM3j1ocxV
         UTWKPoQcFx5ZJdo5/DPN6gUL9DKDBqBG5FgJDuZ9YdefPLn+gwjRb15YehyxqYoAgAmy
         +4DQ==
X-Forwarded-Encrypted: i=1; AKwUvBzgfCQ0ehNjI+7jJAf1bH1w/uZtRXW6gcWcMjbblu6BgGyjP4ZIYG+7W/8JfVd24GoDIyrMPGSxNejI@vger.kernel.org
X-Gm-Message-State: AFq9FYLnu3pPsojPg7rpiWwLzd7WW8HUaSAh2ziJCSEVeplXCB82SpN+
	eyTkrUZFiaFWcUeED0o6rA1OOYmbtlvyYFM7QY1ykrycuPZdFfp44bA=
X-Gm-Gg: AYBFou17asFpI2gQirxJGQ7OeJ1XtwC9+sh4CvFE1LIrF4sfznF3rHTWSGX9jHtGQfV
	of3ID8TW6nFj4N6XSBvuPcsLSYzZyk2SwmTlW84/JShT7wPsUmyijPwJw4RT5N6gAM2zMPOF51V
	saCpzO2/cWFc7cIzo73n0O9eNncNmOMfZsA4ptI4f3l6q01mO2gTQeSBlML8sEhN4F1xp/Sdt2l
	WUVLF+2iZUAuzCTH4Kouxu5vl/1CLL0VyxOSaMqKUyxZHcDvJqLC64I8BUN/NDPju7ta6l0JoXU
	k5t3w3kUnrsZdovjuBtwVoiArDnitHV+hZfOSfdrRJSocsd6LqhzMmdmhVPY4vy5p0I2TF7wsXq
	3VvSGbfO+HKv/vzITzHRpfAop2/8iF2vQrIRoG/9QQyS+Qoq2KMMW6avT9R7WEyONlWsyGkG39H
	0o8Zx+VgP5KpxAs7zf7ZiCQV5LTPkGRazDhC2BsXNYjXnHPbcW8lsVaNYaM7CCJAHUH2qP9r8tb
	n3H/hhgBiYOGCjUlxzOCmqAADIsZONU4U4Hhv8oFxWZF/FThbIbzId2thAcq+RNJBUGAt/cmq4+
	T2gU0iFivglHRqrTYkrzkAGpyLXBqgjqUA0nBEPtu7UtSHLmySciVuXyGkuEQ0nIHfUquJ8Xf/k
	QI23Ch0nL+JIUpC8C
X-Received: by 2002:a05:693c:20d3:10b0:369:fa21:ba0b with SMTP id 5a478bee46e88-36a42451227mr1548074eec.33.1793324776753;
        Thu, 29 Oct 2026 18:46:16 -0700 (PDT)
Received: from anuj-MacBookPro.. ([2406:7400:63:75fd:f9a4:4062:7980:1324])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428fa380sm2209020eec.12.2026.10.29.18.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 18:46:16 -0700 (PDT)
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
Subject: [PATCH v3 4/5] block: map dma-buf iterators in blk_rq_map_user_iov()
Date: Fri, 30 Oct 2026 07:15:39 +0530
Message-ID: <20261030014540.3065403-5-anuj1072538@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261030014540.3065403-1-anuj1072538@gmail.com>
References: <20261030014540.3065403-1-anuj1072538@gmail.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-map.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 7369aba74771..a65b255b229c 100644
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

