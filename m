Received: from mail-qk1-f194.google.com (mail-qk1-f194.google.com [209.85.222.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F40A191F62;
	Sat, 19 Oct 2024 21:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729372684; cv=none; b=tHBxeYFj0XxmtHkKd+5tPb2X6Vl2yhm4kNV9j49XOGmkSVvTnN/E9E/qjsUpoGB8NKWNAdQATnaVyZ/yYK692Kyluvr0rzA/D52uxFPuay+RhZvR1kSuphuwhLPq9mTkRgq4ywFUFGNm0YqW+YxoS5tjUbf0poXrbqy7Kg/rQoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729372684; c=relaxed/simple;
	bh=dTdREiTC3lSMXuTuhpGwejQ68yQ2Oe9QosYNulNZI4w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VdysUoe3bTThUGfD6loM7pL+92p/Ov+ONR5E3JyfBqli5glh1rMs70msFTfgEr7a9/nmVi4vtZcoec7wPP8AjGPX1CzRFKsKjHvbgKD72fFmffSuGpwrD7ASkCzOuo9s2nF+foJs+DVvVeiDIa49KWzxsrbJz5uMmBGJSf3tVus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PVk+hH3T; arc=none smtp.client-ip=209.85.222.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PVk+hH3T"
Received: by mail-qk1-f194.google.com with SMTP id af79cd13be357-7b14554468fso262127385a.1;
        Sat, 19 Oct 2024 14:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729372681; x=1729977481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cREe+0t46PCd+30ohydq9s8xqKcE0qk+msu4UHvCf98=;
        b=PVk+hH3Tgw9YEtAUsIf5DbZnm1Avec84nsmlDbFCIuIzh9ms1V1LigP0hfoZVmYXIF
         LFAnxdJMBkAvJn8/OIm4u0hPvKpkg5PFQb1F9t5YIZNwCogsanBY48IOQlD1EL6n5PzS
         IYS4VG86jdP/PDtDDlV52ayd92cajXMGTV84GA7Ar+5zky1uNf1xPPGJAeT0kjlcmqUS
         jYUemiqvdThx4/OB3BQ9yRHgudFU+gScp915SXTGlB41nA8IXJm7F2tunRnz6F2TQ8hO
         I3td/QFBNrxTOCVID8ZtrzreaXd4/S2qm4oMuersBf/5B1xaV/hhvjbT52YZXbRgsk3z
         pMzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729372681; x=1729977481;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cREe+0t46PCd+30ohydq9s8xqKcE0qk+msu4UHvCf98=;
        b=WMQLpW6sTIbHMYBeuXtprqRiXKvFE+W3EYRAOFDnDVmam6amwx5cmS/lWh/4nNpxDh
         BIXxV/HrxlmmHzxS8evbONhMQqPZQyBO2mbIZ2mytc48gqF87AcIEHoccwd4NUdLA9MZ
         T2XTyC2efi+iQX4LrRrWuimTbxP9gn6bYPQhkfCTV1uH3bUUYYA57RxM0LJViVc60k7R
         kdcUR0Upwo9sKJe6dHnofF9TUqT0bhTF9W1f5uVswD+3T/+Czo0pE8ehjxYZkqbMyZ7w
         BUwvj3UPivglko8mhz0rkET0jsXjC7224R1xfsdkNQV4LhLiEBl8LKsc8Ke9Hc6tFkHX
         gcqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXK1RBsV2fqp8QMdDhWAubPBq4W4YArRHumn4kHCKCh9ZU8Y3rY5LLaiAriq3Fle7aS22J11MLD3N1o0WA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzemo6rD9czWohLWdDrFsUYofNpQeBYC7Lc2tMqyjD5VKqe8na5
	u1LXUL/5aDjeCz5FYVmprN5iqVje0PQMP5p0QofAQNmSHfjAdR1p
X-Google-Smtp-Source: AGHT+IGTyEVz8aI3jODN1tJE9vSC9Oy1azzEoFDBCx+AQpQ1VkvvuFtZiIPPtvvgieKMaHKoDMvIlQ==
X-Received: by 2002:a05:620a:45a2:b0:7ae:64a2:be61 with SMTP id af79cd13be357-7b157b7ee40mr1037834485a.36.1729372680963;
        Sat, 19 Oct 2024 14:18:00 -0700 (PDT)
Received: from localhost.localdomain (mobile-130-126-255-54.near.illinois.edu. [130.126.255.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b1659fd65fsm15510985a.53.2024.10.19.14.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2024 14:18:00 -0700 (PDT)
From: Gax-c <zichenxie0106@gmail.com>
To: james.smart@broadcom.com,
	ram.vegesna@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	fthain@linux-m68k.org,
	quic_jjohnson@quicinc.com,
	dwagner@suse.de,
	hare@suse.de
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	zzjas98@gmail.com,
	chenyuan0y@gmail.com,
	Zichen Xie <zichenxie0106@gmail.com>
Subject: [PATCH] scsi: elx: efct: Prevent potential integer overflow in efct_efclib_config()
Date: Sat, 19 Oct 2024 16:16:38 -0500
Message-Id: <20241019211637.5533-1-zichenxie0106@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zichen Xie <zichenxie0106@gmail.com>

This was found by a static analyzer.
There may be a potential integer overflow issue in
efct_efclib_config(). efc->max_xfer_size is defined
as "efc->max_xfer_size" while sli->sge_supported_length
and sli_get_max_sgl(&efct->hw.sli) are all "u32".
The result of the calculation will be limited to
"u32" without correct casting.
We recommend adding an extra cast to prevent
potential integer overflow.

Fixes: 4df84e846624 ("scsi: elx: efct: Driver initialization routines")
Signed-off-by: Zichen Xie <zichenxie0106@gmail.com>
---
 drivers/scsi/elx/efct/efct_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/efct/efct_driver.c b/drivers/scsi/elx/efct/efct_driver.c
index 55d2301bfd7d..7fe180037c2d 100644
--- a/drivers/scsi/elx/efct/efct_driver.c
+++ b/drivers/scsi/elx/efct/efct_driver.c
@@ -109,7 +109,7 @@ efct_efclib_config(struct efct *efct, struct libefc_function_template *tt)
 	efc->log_level = EFC_LOG_LIB;
 
 	sli = &efct->hw.sli;
-	efc->max_xfer_size = sli->sge_supported_length *
+	efc->max_xfer_size = (u64)sli->sge_supported_length *
 			     sli_get_max_sgl(&efct->hw.sli);
 	efc->sli = sli;
 	efc->fcfi = efct->hw.fcf_indicator;
-- 
2.34.1

