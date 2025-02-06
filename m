Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1D92236EA;
	Thu,  6 Feb 2025 05:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738819532; cv=none; b=pSX+la3FWZ6siTGULhBa+Bb8K9DPuEOyU2VoaDvqf1C+y0OXyq4APlo+ZtKDnr5XvXR6kbd4Zz3uXhnwHUQsiKyWt/oW14MpLDTtHSiL/9CQHwRuC+AgUfJciq4WN+PrtSNKjBvx8IT2mHdY79BCVY4dIDy0AYWrBCINiRqo3Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738819532; c=relaxed/simple;
	bh=yscMsWzfkzopW96PRaCtPZTeX4V4y1diGdjPcfZn2AE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Tex0sYVixSPZrQkREUmWGfJKlWDXG+3VdLwvOAglDu4Tfzy7OMueDPO761bHghu3Ur/ZJjEQX/j6nNGhGAjl9BsEqNZ0Sp3rEF/hmHGwARmYtI2N/TyNjmIpvBUW9hn9/7nHjEUk0hMcO1vuQV7j+yjRLCGnAilQ8jWbJJNPxB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PNY8DJW7; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PNY8DJW7"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-467a3f1e667so3511891cf.0;
        Wed, 05 Feb 2025 21:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738819530; x=1739424330; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KMabT1Ta13vCJP6B4o9w34eBIEtr/6ciaUwn2z4+CII=;
        b=PNY8DJW7iuxPWOofpsExwnRrgiZ27E2Z8e54NvxH6a9Q5DpdaBBezBZi0mA40MjrJh
         ITWzSFu9679Vw8xfYyEMtHlX6zn3ZGK1eGkG+VGNCr5LbPT91mBrj1ShOmZ4l6v7v+Uq
         +dnZM3EYdSkYF7KSa1tcmFOrAvVPlUPLihrBZemLDXcRNo39lhYWtmr7pUzYuCW/BGdc
         YLipDSkMStEXlneQrqDpRg8ZymB6jHN6w+64PtsumsZLF0rm3XWceq7+i88YK/dMp0yH
         7HmXfVO+paILBM1EhDaIYwRV7uHgCeXzgSM+9kR/m65G9KtrhmzVZZo6/ZVqB0gsJXSd
         bg9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738819530; x=1739424330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KMabT1Ta13vCJP6B4o9w34eBIEtr/6ciaUwn2z4+CII=;
        b=AKuTg2HfFW7weO5UHtDCfgBgeBXCfR8PKcFgACo33Fv9NVqrkEKB+T8SJsaE62UG9z
         5mJG67PUvNfJNJ4ksACvZltEX2UDuOBfmluUo5FvYL3JOlyrZoLfpya/GqIzt4MN3zpQ
         vGFpS2iScWdHyugfOSDzlN7MssXFOFSjI9iW7SOJC9RnE12dsylP0SdPWwGJswpr4Hvn
         /vGnzuwhdR+RyDhC3dXOwJkifdk/9g3k4p7iLlsVUej/O9tC80DWcSVNvVysmxK2xsTp
         c/UqjqKw0tlnYXtsLvIAWc2K3y9DAsZK/M5g3J6blbK3HS8Mfx9e1nE/s7sR5dVkWpAw
         hi2Q==
X-Forwarded-Encrypted: i=1; AJvYcCVb0oZlG1Cpu8FC1nRXQxULfy/kyylpolaey5z9q7z14FF06UAEEJ8EVNQ/qDjVahij03+vn1X7gq/6Ug==@vger.kernel.org, AJvYcCXl9/mvGCvMlc/W7qcyN1yHsKxQa5rnKqONHsYtTsbLvsYiN418wUjbe2m3rGpYI8WeYGFtucof@vger.kernel.org, AJvYcCXwg6ijq/+V3r0++C071ZonyQkTVSRA0BwMn0weHKVZYWghtIJ2B2q2ucS5JAPAOEA3HVrhudL975WoVgg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJ+ou6jPLFfJruaMoymUJbbKqGdG8g0DsgxFHNRFDlWQHemoCR
	mXDCJ4Q6eRgh/UzvBbITTEqsc7o4XPC1ihoGdCw5R3Kmz1kFFfKy
X-Gm-Gg: ASbGncsCsjzDKnM5cENvrWICITP7/ml/WIQy7i6YAB7SfD/Htrav65jgYb9iKR1KCEt
	K1s3PIy8DIu2GVxiYHwJE9NhbnT7+PrC179E4KVMOsKnKvSqZoaSFy7W3MDsdl75IxKolL4Xhg+
	mu3Yq/uYmeyzU6ABuXMlHA56mlJrYTkVhRpnoee1K25Ib2fXujbp/XNw7yfgEhlniQEJASXt9TM
	Iq5lIgjD3DKviJeLh6EL8PrgDXrtsICHpsrDv2PbJWVefo2gPiEQgMUgAc5NtMCkfhhx+9vCjhI
	+zxtZGEfOU5EXzZyoL6P9Tlx4U5phjGBr290+A==
X-Google-Smtp-Source: AGHT+IEWq5+7ZoZwnv+WdtFXifSVArxRU5PQLq0SbB1amt80hBnhup7gdch5vKCzkk4/d3JgfFtDGA==
X-Received: by 2002:a05:622a:134b:b0:467:60ba:b6c with SMTP id d75a77b69052e-470281878d2mr76153171cf.17.1738819530115;
        Wed, 05 Feb 2025 21:25:30 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-47153beaacasm2285571cf.67.2025.02.05.21.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 21:25:29 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: markus.elfring@web.de
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@hansenpartnership.com,
	arun.easi@cavium.com,
	bvanassche@acm.org,
	jhasan@marvell.com,
	jiashengjiangcool@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	manish.rangankar@cavium.com,
	martin.petersen@oracle.com,
	nilesh.javali@cavium.com,
	skashyap@marvell.com,
	stable@vger.kernel.org
Subject: [PATCH 2/2] scsi: qedf: Add check for bdt_info
Date: Thu,  6 Feb 2025 05:25:23 +0000
Message-Id: <20250206052523.16683-3-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250206052523.16683-1-jiashengjiangcool@gmail.com>
References: <d4db5506-6ace-4585-972e-6b7a6fc882a4@web.de>
 <20250206052523.16683-1-jiashengjiangcool@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a check for "bdt_info". Otherwise, if one of the allocations
for "cmgr->io_bdt_pool[i]" fails, "bdt_info->bd_tbl" will cause a NULL
pointer dereference.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
 drivers/scsi/qedf/qedf_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index d52057b97a4f..1ed0ee4f8dde 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -125,7 +125,7 @@ void qedf_cmd_mgr_free(struct qedf_cmd_mgr *cmgr)
 	bd_tbl_sz = QEDF_MAX_BDS_PER_CMD * sizeof(struct scsi_sge);
 	for (i = 0; i < num_ios; i++) {
 		bdt_info = cmgr->io_bdt_pool[i];
-		if (bdt_info->bd_tbl) {
+		if (bdt_info && bdt_info->bd_tbl) {
 			dma_free_coherent(&qedf->pdev->dev, bd_tbl_sz,
 			    bdt_info->bd_tbl, bdt_info->bd_tbl_dma);
 			bdt_info->bd_tbl = NULL;
-- 
2.25.1

