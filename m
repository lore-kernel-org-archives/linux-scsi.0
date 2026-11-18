Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794975268;
	b=0CNpn/1/R2wJDZ6DVJ4GNNLrDetMGxues05gAOSNy72GN+1+AtBMnodRkFvbiwu03nLa
	 9RHABv+RoJwUlSv0bzpyH28OW/XzSKRlx5+WAswHg0i/390iM3BzwN+XXNJTvnpfZK+gf
	 yX7WQ+sFHGg5cknu9PC2P7/I4aWZVLsC71sZrZKOBhR0x9ztuS5VTvub2Nuvc2WcP7QB/
	 Yh5M9Ar9K7y8xygJTKCukjmGn9pBwROqNiO0FZaUDu6xMqY6KqrMeGhi+LEkthy9+UsQ5
	 xrEytRjKGujzb/S0SYxpCYuUwXCDA+vuPK5VklmVR+MPxe9b9edCgnKK/hlPWmudS1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794975268;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=S7V7zZ843cUu9IT4B0WCibyEP2k6ABel5P+47hk3Njc=;
	b=VbKb9qCXy9HAVs8HZlS9U/zw+pnqmBN2GXj2zmnUpixMDU3g0/GuZaNfFuRztFoGYR0O
	 V/hHDt98POkW5TTiMiKV9scSXDfF/DFNC7JeDXurqBy1TW6IrDO5dacVSEXIj07lDe5eC
	 elX7EZN5yZ1HYrKVxR+HQsS0D6KqqrT8rFcMaV9Ou0k7nUQiJFxj5us+ZCGUytBlyrqZv
	 AsU2rM4ov9cnKlfD6J+C+1QviM7R73Z6zte7nqdZd/CSVRGbR5Yp0niEeCte6btHJ7I96
	 LZR26C+1tIWQEFwAAHTDbwglpwaMfCJyHlNFh9Mdv2hfix0x1sPBnEBXWi9T4lV3TWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iMYVw0pn;
	arc=none smtp.remote-ip=209.85.214.174
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F72B606A880
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 04:14:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F72B606A880
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iMYVw0pn
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2eff92780daso1986365ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 20:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794975267; x=1795580067; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S7V7zZ843cUu9IT4B0WCibyEP2k6ABel5P+47hk3Njc=;
        b=iMYVw0pnpSGisBf9wt5mkp6dAmIfmEHqMVV3f2qKfO2D1MSkKjpCBpziCF7r7QU5dl
         R6IGkbU7HL3qgXhVAUilaShupESFUptektESp60qwiClRhPYZPoyu/cPs5/6gLnbOeRN
         lwCUrhXC2LAf4GSgyqUrdtJAT9spLBT15FupYCkmE9z6PAwK99T3qswWJjiWErHdeD+n
         IMCExIlvORPXX+IenIgKFlXQCnv0pBzncAXrcQu9RD8Jy7xScTWKmdviJ+IQy/5VEUkJ
         M2+UGv5eadFh7WZG/oWWg7XDQqgUKER5qu53eHzppuv9kMuHyKnH6yu6dao3SIHDApEr
         r3BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794975267; x=1795580067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=S7V7zZ843cUu9IT4B0WCibyEP2k6ABel5P+47hk3Njc=;
        b=WZQlDzYUYVgIcX8SYMR3jsRLG5VuhY54udS0n90BW7b07bRlbiebW7Y60jjnPVZeSd
         Rra9mUKBwohdYLD9Ad4hHVLzT0W1E+jHH/KixfnuyfOMjJfgcL6DA3L1b7GLWqOdUZI+
         Kksrhi0cA4UxKDenKIAw4y7z/XLb4g0I6HVAnN+fOSRlNgs/xV1TzaK1wXS9JJNvhbp7
         DhvUXYrLicGD7F0UH0vREqspG2jD+Iy40U6UhAqtJTcSrkCuKtslTNhwvtMQD5lTQjpv
         yRPXm5AKhtdQudmrFBG8tsTeM1vMUtAAgCaVKbS2UdvNP6nBW70mTxC1d6h+zis34va8
         ITzA==
X-Gm-Message-State: APuU4Z9L7wyq35H21xYsreXnBCKKsiKY6dF8Ls5FrXN6WDHBwX9uWZ1L
	OEN3b75hpRcw1oivMrb2E/q7ugZzjvA+twcvAoLo/cY2gjbw2f09AXt3
X-Gm-Gg: AZFdTZfxoJfrRusC4F00ZrR92X+X781Hm2COH7sCOFiMhjoQKiO1W84x/P4q4Pj1NhY
	Tx9qm6k6/9iilSEG3Lx+RN3PEHtoed1mB2WcH+dfhwp6DFDkil7GR4a6wilR2EnaIOQw2W7LlIb
	u7ZF1ijE+JjY525QouydMYhmYWldYoeadaADV44whzU4BAP+h80n+aKh6s4Wa6lJCgI+dd+1asM
	1jEDxCxh2WuZvGni2Mh1/+CYUWF2F3/uqIDp5qzzoOsLfWaMw2aXE6VaeY6P3oDxdYDRkNglDSQ
	3zRGighC+7u0J3ohQdMjErlbYRUyWJqhHYXEEeGu9iylpUDSMGu1EdX3QF/R3bd6Z6E13H09rLr
	o/qLyStI9jkjfIUTgvCxLGhUVMsskfqR/wj1X3hfnmdi81pfI9qNVtHFVGDfGZTS6VxlutNOVU4
	5FjH/28bU+uhMIUR9or/CvsTupxFZgsbcVQvT8d/Wp8XJbiRpXRPX8Sc+iZ620T2QgblCtYfhA5
	70dlkGZdyWHxcMB0sbVjnEj1XZfRyeTpeW+NR0A7o9zyNhdKTA2tQpnRXjunIOo0xvi/wqB8u6F
	pnIS5tE9Eqo5uz/pnpLop5lo8JrJPRu0KXpyplimbsc=
X-Received: by 2002:a17:902:c952:b0:2e8:1c7b:3b6e with SMTP id d9443c01a7336-2eff7403b8dmr13500835ad.26.1794975267252;
        Tue, 17 Nov 2026 20:14:27 -0800 (PST)
Received: from gmail.com ([2407:cdc0:d002:0:188:253:12:32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff6214f4dsm5728685ad.43.2026.11.17.20.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:14:26 -0800 (PST)
From: Jia Jia <physicalmtea@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>,
	Jan Engelhardt <jengelh@inai.de>,
	Hannes Reinecke <hare@suse.de>,
	James Bottomley <James.Bottomley@suse.de>,
	Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jia Jia <physicalmtea@gmail.com>
Subject: [PATCH v2 8/8] scsi: target: advance past escaped DIF blocks across data sgs
Date: Wed, 18 Nov 2026 12:13:11 +0800
Message-Id: <20261118041311.19011-9-physicalmtea@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261118041311.19011-1-physicalmtea@gmail.com>
References: <20261118041311.19011-1-physicalmtea@gmail.com>
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

An escaped protection tuple advances dsg_off by one logical block.
sbc_dif_verify() adjusts the cursor across only one data sg on the next
iteration. When the skipped block spans several short entries, the
offset can still exceed the next sg's length and the following CRC
reads beyond that entry.

Advance through data sgs until the offset is within the current entry
before checking the next block.

KASAN reports:

  BUG: KASAN: use-after-free in crc_t10dif_update+0x91/0xf0
  Read of size 1

  crc_t10dif_update
  sbc_dif_verify
  target_execute_cmd
  vhost_scsi_write_pending
  transport_generic_new_cmd

Fixes: 18213afbd8ce ("target: handle odd SG mapping for data transfer memory")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
---
 drivers/target/target_core_sbc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index e752b23b1bef7..671427d9ae74a 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1553,7 +1553,7 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 			return TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
 		}
 
-		if (dsg_off >= dsg->length) {
+		while (dsg_off >= dsg->length) {
 			dsg_off -= dsg->length;
 			kunmap_atomic(daddr - dsg->offset);
 			dsg = sg_next(dsg);
