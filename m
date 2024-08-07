Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456601C7B77;
	Wed,  7 Aug 2024 09:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723024636; cv=none; b=MJU9ls3oBNCBeWdd7To3toN5/XeZPdH4xLosCMqzfUQgxYVSo1/7ZmEUiP2t8W9PFJceL785CbXZsfH6iblmJ2ch1G9VaGlPBDxdwuroG7x8zic39JTAkzUnu6pzHJSc8fpd2qyqxK3Aeud5cP7wTvHkuyEYiw8wffpnJXROVDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723024636; c=relaxed/simple;
	bh=96WuyfzzyLD+R027jH2PJhXFxJivRH/jcY8hc9P8ND0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rzdjrS8vcdR0fzNSTyEv78U54yp3aRnQcs1X2XWqa/24PPtkLgBR2ZjTpdF/6na1kMO/6mmRy7qYCdDKJJPj2IJBqo8f4LLuEuhzDTO2x+Mzm2fPYVh4P15TISOYFM7inzD2leDLN+l0yxxOPBafKExatd5otmWnn37hSogVJws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MGbIt/ul; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MGbIt/ul"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-428141be2ddso10893095e9.2;
        Wed, 07 Aug 2024 02:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723024633; x=1723629433; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=q4g/+zEZpt7QyDQzWWd/2UMhzLGf1On5rXbf1/dsqPs=;
        b=MGbIt/ulXa66zGOhy2AHetHZxwG8WbRvEzfldzeerDHm+UjRI1TT4rrI6gM12HoFjo
         5cNvde5LS38gynS8v9FpL51LsUuNxTfVi1ocem5SplT73GkuPdODzZYROqsnsT0dd3L5
         ik7fpzoWtCIlb68CFyy9SDXLoR7RNTQKIHRg94VV4H6OxgXSZZ/NdfmC5L2YmMv6BSH3
         Q5ioahcbjoEEig/IKwonITScsqEE/Qf85OiTu7Bt3rm+KKiwT8QX3HUUbIfv52nkK42k
         hrtJk6q+YyihYKVLyxUvlMA0jvoxZa25VuKGmDI5adDOOG/ptKGSkht/G0nNYKALv5Jc
         M78A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723024633; x=1723629433;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q4g/+zEZpt7QyDQzWWd/2UMhzLGf1On5rXbf1/dsqPs=;
        b=s8ngqfXHnEYK4Goh/0/E1LH3MIzCySNCE+Ipqn8ihzNaC4Cwyc/TE7U5P6/uqvr9/M
         0QrrZAY6HWnW0pU1+QHBnFP/M+oDS0c/gXjEmTbI5WDA+DqGVsl8y0BiXoLLCYdMUezd
         nmgysBr8Fzuy042rnAjcfLz21fcPt5T84KHVg9tdZOtsyA0Uslx1r2hLMAF9sou6SI4H
         nQANFgfd8aQbk7k0yx8ZAcRWxgZycz3IgeZFC8eLVGXHLcEB4MDTnrUullsQMyDFfyiB
         4PLYPTlfVUH2nRxFTI/WdmTvNutoiLzpAN7WAEZ3Jctk3LFMyx+uekzoTjLaFI7c3O6W
         L4tA==
X-Forwarded-Encrypted: i=1; AJvYcCWg82H/NHyyklddVdMWDUT7ejuYB7iBi3S/IjvUnI+mLJ9hEasTDZmM6mH+hsmt9fkZl+Fq91zeL5VJ9tIqvrUnXzl1iU+Py3Q+h2jT
X-Gm-Message-State: AOJu0YwTAenoVI9D2MxnX+wNRPIogbl9ePEzGbYFxiKRh4I56CP/z3tC
	0LUfc6bSM6svqY65jRJDpxTFHOWeqxurxT5cGcMKfoH36Fy7AG0g
X-Google-Smtp-Source: AGHT+IHLRLMclhaInxpNmrjMjn+7xXrnbU+y0mmiFJnfIL/5eydpaHzeawANYEQCmI1N9RGZ4vCuMg==
X-Received: by 2002:adf:eb12:0:b0:368:31c7:19d3 with SMTP id ffacd0b85a97d-36bbc0c2750mr11130906f8f.9.1723024633371;
        Wed, 07 Aug 2024 02:57:13 -0700 (PDT)
Received: from PC-PEDRO-ARCH.lan ([2001:818:e92f:6400:96b:aa92:afc0:2d3d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36bbd06fbfdsm15265557f8f.106.2024.08.07.02.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 02:57:12 -0700 (PDT)
From: Pedro Falcato <pedro.falcato@gmail.com>
To: Karan Tilak Kumar <kartilak@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pedro Falcato <pedro.falcato@gmail.com>
Subject: [PATCH] scsi: snic: Avoid creating two slab caches with the same name
Date: Wed,  7 Aug 2024 10:57:09 +0100
Message-ID: <20240807095709.2200728-1-pedro.falcato@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the spirit of [1], fix the copy-paste typo and use unique names for
both caches.

[1]: https://lore.kernel.org/all/20240807090746.2146479-1-pedro.falcato@gmail.com/
Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
---
 drivers/scsi/snic/snic_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
index cc824dcfe7d..abc78320c66 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -873,7 +873,7 @@ snic_global_data_init(void)
 	snic_glob->req_cache[SNIC_REQ_CACHE_MAX_SGL] = cachep;
 
 	len = sizeof(struct snic_host_req);
-	cachep = kmem_cache_create("snic_req_maxsgl", len, SNIC_SG_DESC_ALIGN,
+	cachep = kmem_cache_create("snic_req_tm", len, SNIC_SG_DESC_ALIGN,
 				   SLAB_HWCACHE_ALIGN, NULL);
 	if (!cachep) {
 		SNIC_ERR("Failed to create snic tm req slab\n");
-- 
2.46.0

