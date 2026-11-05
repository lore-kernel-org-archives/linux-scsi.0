Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793881795;
	b=Yki+0kZw4YssTyPHHWSy5U5OjNmX6ES4wVwvDtbFLPxpzQcqcmkhtzyMAeKZqXkK09kl
	 57UIcvUajhEU7I21+Fu9dMA2V/TieGlCxj3YaFdfa494j4NHtqWGihzzSeSSJYSzGYm3W
	 EiOOxI4lpdmncp/uZnmqsswBZX2PajmoGjQm8KpfwCqYLl7MxgIaQXRamEQnQ97qBgiKy
	 eSBRoea9dRkcuEu2sE9Auo0ZSv7Jv48QvhKwQi7186W6E667cYJLDxWFMPMJ2hf5lbA3B
	 dMli/tj6kEw0TiGOxApMDNi3dn3nMPot86gOJ8+V3DXUtPFiVhRmR8yIsXpyUBRi/mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793881795;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=/UKcMNNWqDuqXMXW8ATBrRl5fb2pZBkn33rI/MXfTss=;
	b=cjyTSpCH5yrSZHesoqzrMxkAs0VkASKOE9w2oG7w27REJKXMGH8wP1+zUesK3kphBvAB
	 T1rAN6b90H9p8INEUtV0Eid7iQxKPqSBcapt7pKQ9yzq8FE95J6V/+GlHqqTEHqn9Smce
	 oG7DjT1UAz6hQIEJHRgWiJ9CrWaPU2rsvfP4mIuceHdwWpS9phv2JG8ommYlUHoZJ1vsw
	 +xUVACWe4wgXu2DBZCqqjPSh0Myiuwnvwia+k7U795fNMhtqzur+4Z6YG+U0lenTEBiX1
	 H1BPYvqCCAW515d9MVqhAdRCftxto+z8ppMHZ/ZWuHgWw9miTWj4NzfgpBBR2DLXFCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Fm9JXDkn;
	arc=none smtp.remote-ip=209.85.167.176
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610B6606A31B
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 12:29:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 610B6606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Fm9JXDkn
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-4f488ba6e90so716359b6e.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 04:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793881794; x=1794486594; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/UKcMNNWqDuqXMXW8ATBrRl5fb2pZBkn33rI/MXfTss=;
        b=Fm9JXDknaDxCxLS6wrV3RwSaRVQyUWNyTKmw5zMxq57j7qAaUBOCz2g0+vaC8PktZi
         Xl3mOLAdzrg7AipdBjCVXYFQNDHTtcX0Ap6rjhEOrUgUtxd82+8Ps8qO7zW60M8NM2DB
         7OPX5YLz89b9d3OF9x/ufbkSv8D0hUxaJIkNulN3mVQOrjP3k7yFfmqf4b2EkOsepEO9
         0JHBkx4TFPJoTSNWIDgMBvVxoUoGlGonurD6Qx3L2ywAIkZHePQ3v5/a979E7tOrhbt9
         7PU6KRLTjGtIvKtQdVPfrAwbxDfoT0ciak84WFQuHn1MpBYE3UKQUiSGCwcXpa91SbeB
         OPcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793881794; x=1794486594;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/UKcMNNWqDuqXMXW8ATBrRl5fb2pZBkn33rI/MXfTss=;
        b=u4SxplC9FElEX2jnR3VngRcY+iph8cP/b7OQVHCnRUUh08XTqbMgiEOu11l6Lsipgr
         gLD3ATGoUZm0Oc+aouptI/69MsklydueKq/meTiIV8NePpcFpQ/2bjeeBG4qV7JXCKqi
         SRpWajjc9ADUyrL4Ahqsv+bc1F0WoKJAYBkeabRrVqZonYfztWPlXIzHL5jjqPoyjVP3
         N2+F/udwsGuzsBFRZ+hNa4LeVJVFEKoEs2sDXD3ddPNIK3kX2+IeQEUZ4i8BoagBpmWU
         sGIKYyBr1azNTUS/zPy3l0XPWIfSNWsvqxRrfXIlDpdkw1nAFgySWYI7cTEa6br7lwQV
         WXAg==
X-Gm-Message-State: APuU4Z91VS0CqjJZp8vTqAav+SX/7qt3dvbMAtNmkWJ8utXrPAfyATBo
	zb0w+gVGazELqCEHJP5pC5XTokUXjIg1VYHM53rYXpPWrX/FWnALldAXbPoAquXq
X-Gm-Gg: AYBFou1w1nKnksmV2Xzofs9F4UPPN/QX+cL03wuKNaplSnzJ19UpeVNFMgLf9z1XWbO
	3T5xbMjvElrKhhU33v3rG/USUnbTvlF00chTupsnFJiUp7Al0+lWxORMjhy1NR+PNZRhj8qHHSK
	l2AXu9QE9Smwjb++4pjHgFJTUhNq1n76ZajXmXmR8Lq/VKekHvAldqBij6BUbfQBMKAdYCQeatk
	GSxBF5mK1QRi2Xj3C0X4lAIjyz59Gcr7dwmFc70ZtAfiRzEwNsmqCO/Akkf2Rw/k0g0A4Q7MHPR
	dpXqFpF8JAqM9wwRjo+aKJdUKxLsyIfGSlCzoJJy8ZjLdk+Id0lCR+YWKJ8a5J/iM1ioz/fBrcr
	pBONQO7JlOwlmFZfl1ZjQY0jtWy11KS+HzKproD0Q+5HrR2D1lSVzeEcFfrXI+5dMv7biLRcL2O
	TuMXjSi6WBQqcXXzMFZ/LQdry97FUrgMbPt7nH20vX5RWDZQGPf2w58OtqT1wP8WDX+5T7hi7nm
	h1iQ7Dzo1NjWNojdF1A6QNeEKy31Bm79c2soPEcaNyDROzYE+z3ODR2JxAUKrZaOtcCZMq1FFk2
	LyYdqZWjYxJwhPy4o1isYjX4gha41ZiHSRDbWzsdG4EolMFsAIYZh2kmYw1TkOCd43GK6dUV4ij
	4bbplhgp/l7CrY3fHjeAwGgoxnOKK3wGpI7oFGg==
X-Received: by 2002:a05:6808:3099:b0:551:eea6:9397 with SMTP id 5614622812f47-5640de26014mr15832813b6e.59.1793881794223;
        Thu, 05 Nov 2026 04:29:54 -0800 (PST)
Received: from cr-x-ubuntu2604-client-2.dev.fyre.ibm.com ([170.225.223.17])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-567a9f9115csm4244355b6e.11.2026.11.05.04.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 04:29:53 -0800 (PST)
From: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Subject: [PATCH] scsi: target: rd: Use memset_page() instead of kmap()
Date: Thu,  5 Nov 2026 04:29:47 -0800
Message-ID: <20261105122947.2727448-1-chelsyratnawat2001@gmail.com>
X-Mailer: git-send-email 2.53.0
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

The use of kmap() has been deprecated in favor of kmap_local_page() or
higher-level helpers.

In rd_allocate_sgl_table(), the mapping is short-lived and strictly
local to the current thread. Replace the open-coded kmap(), memset(),
and kunmap() sequence with memset_page() and remove the unused pointer
variable 'p'.

Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
---
 drivers/target/target_core_rd.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 092d9fe0d4e3..a8f214bd14ec 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -117,7 +117,6 @@ static int rd_allocate_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *
 				sizeof(struct scatterlist));
 	struct page *pg;
 	struct scatterlist *sg;
-	unsigned char *p;
 
 	while (total_sg_needed) {
 		unsigned int chain_entry = 0;
@@ -158,9 +157,7 @@ static int rd_allocate_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *
 			sg_assign_page(&sg[j], pg);
 			sg[j].length = PAGE_SIZE;
 
-			p = kmap(pg);
-			memset(p, init_payload, PAGE_SIZE);
-			kunmap(pg);
+			memset_page(pg, 0, init_payload, PAGE_SIZE);
 		}
 
 		page_offset += sg_per_table;
-- 
2.53.0

