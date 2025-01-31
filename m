Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2741F7594;
	Fri, 31 Jan 2025 21:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738359323; cv=none; b=e3Lqztq1GzaE9eqIjy1m1NHuW9KEn9tb9jLapMyiqJUQxJpVPR3jDG/6yWyg0xnjwb6+cAaWNKLJpooJuy0NhCgtgcIRi9fSz+VdlV/YngOri4V/e7ZZGk1rTWs/4jSltsKQ4KiuQe6s3XTkpmrG6WkmyhIZ346cYfV3UE1sZ8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738359323; c=relaxed/simple;
	bh=bBVz2mktd/H+nNKPXLFsYEno0//0+sbpRYPnwuawf2E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PtXO5HWDDT8d2V/zzmzEsJ2GYIjLAaqEIB7/f+56b5Zfup+yTI6kyY5eSEsdA5M6Y7LwK1SGvkv8Z8aDGDTQ5HlaBKDCKzaswtRsigQ/kNkNwKzOb91SpB8IsGRAfExU+P11re0mwRB2o1uUVnxbHMZkoxVgXkeSAc7wR/X7qtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kWTxKp95; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kWTxKp95"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-46fd4bf03cbso30614781cf.0;
        Fri, 31 Jan 2025 13:35:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738359320; x=1738964120; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5uuVHoPqFmkx0KevPB8pPAUb/ZM3PgLpFoEI3AGjNYM=;
        b=kWTxKp95ubSS5kOzCLIXrmD5ErVM1qoejXkY5y0aD9IAtawqw4JfW2wlbGSnnXJlt4
         zhMZH40AnmGmPR2Q+3h7Pb8m1d7FNjMnjrlJFFdfUfuWu7sXX+ZyMDpiucxzg+TPc80C
         QvVvISyDm9UM/+d25l+nWMtlshp2szfTHQfPr7FdPJVlnEKz7XAWeFvEiGQw9mgDVNCL
         3HsrliabmJw5dKwveygn4iQlY/+Ud2REZPbuMV/duOs6XuL5qUA2uzzCrZ5fjAUjQfsr
         kfEm6dzjznHmkuA7w2NzTFqIjHW2zJlnow1tFlhWEDtaLXY/eblMlqOPJFWgoDr8LNwG
         GlOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738359320; x=1738964120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5uuVHoPqFmkx0KevPB8pPAUb/ZM3PgLpFoEI3AGjNYM=;
        b=hETgcOWSKzacm2i4SWUDTPDc9p2NR6WTm2lh+m2XwyF5MwuKkT2GLTQckfqgcJ92fg
         7t/ckXe6EVgMEQw8pBIO2soV1nRg1iBcXzAiDFj31xZNfme55hR2fwN0Jymkh8kfJNOr
         x5nj/waH8xDzm5jEVuAyXTd1d2pB591fnHTMqoXzSDXNlBrdX6ScU3/lJPHsIjQ29a/o
         TRp+dOipmk67CXe0ZmqMmSNlTQtCNgCZd3S4Ke+tIBxCvS9VCBkX9G20XNBBwQkpUR2G
         /iUi6tAEo3vvThdawxgqgFTnLFxFbh0OkdMedyYhW82TOJTavZ1Wdfo/G9+lObvUDr0g
         gatg==
X-Forwarded-Encrypted: i=1; AJvYcCVl4tB08K83Fgmdppoizv4aRiHnyAEM8yAeZkH4VFvE8dvTZ2XjYiBOUn+1X1B1ckqzXme7GKHeRevnXg==@vger.kernel.org, AJvYcCWehzAGGiE7rM0BXb4jQGzzPVy1HfxI4r7DjryJ6tnTCA2OVKU+GHBX5O/uS/1hzNXOg8Uv1ZM40x1GQPA=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywgygl5mb53d7Hnxofky8+cLLersYKXTyndqZr8PGoyUw/WqNol
	parrc+G6AZiLkvHyZZ5tH6ecZ6I+AAEUnOF/vgSSJpKoY4TiTpv2
X-Gm-Gg: ASbGncvOOppgkkPBHbvzCChv3DkSzBfWdw8QI/zfxTus26KHka5XV4zIue0Jr1nIDKG
	nsTIlEodibURno7fLdpwNNmfIZYoivdb4PVBptCcU2lJKpuC4IVvJXqrg9Ll+LL/1Ya88GGl6Yf
	qGS9noDXHICl/YU8XRKqhWQDzlOzgjQ6NihUEZ54Xac+qahUcR2R2/ZjAGdNGXar0DSA7Cusz8I
	Xu3ikDGy1/XzzsO/Pf5ix2lnGf1vOV9jerUJ+v+i4NUAnVRDegBey6c3Q44By2LwppRe/GJRWEA
	rirLkNC10DXCTKSJQkF2HEaRt9K3OP+WrHKYVw==
X-Google-Smtp-Source: AGHT+IEM5W0MiRs5YeYu26Tq0JVAkQ11twu8HO+Q9A6XlstEg1MAZEMGweuygiIxa6ecAoAhFv2dxQ==
X-Received: by 2002:ac8:7fc8:0:b0:46c:7646:4a1e with SMTP id d75a77b69052e-46fd0a77c67mr240582791cf.13.1738359320155;
        Fri, 31 Jan 2025 13:35:20 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46fdf17409csm21547211cf.53.2025.01.31.13.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 13:35:19 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: bvanassche@acm.org
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	arun.easi@cavium.com,
	jhasan@marvell.com,
	jiashengjiangcool@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	manish.rangankar@cavium.com,
	martin.petersen@oracle.com,
	nilesh.javali@cavium.com,
	skashyap@marvell.com
Subject: [PATCH v2] scsi: qedf: Use kcalloc() and add check for bdt_info
Date: Fri, 31 Jan 2025 21:35:16 +0000
Message-Id: <20250131213516.7750-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <bbb46821-25dc-4f5d-a6bf-cbef34024afd@acm.org>
References: <bbb46821-25dc-4f5d-a6bf-cbef34024afd@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace kmalloc_array() with kcalloc() to avoid old (dirty) data being
used/freed.
Moreover, add a check for "bdt_info". Otherwise, if one of the allocations
for cmgr->io_bdt_pool[i] fails, "bdt_info->bd_tbl" will cause a NULL
pointer dereference.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
Changelog:

v1 -> v2:

1. Replace kzalloc() with kcalloc().
---
 drivers/scsi/qedf/qedf_io.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index fcfc3bed02c6..abb459e87a86 100644
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
@@ -254,9 +254,7 @@ struct qedf_cmd_mgr *qedf_cmd_mgr_alloc(struct qedf_ctx *qedf)
 	}
 
 	/* Allocate pool of io_bdts - one for each qedf_ioreq */
-	cmgr->io_bdt_pool = kmalloc_array(num_ios, sizeof(struct io_bdt *),
-	    GFP_KERNEL);
-
+	cmgr->io_bdt_pool = kcalloc(num_ios, sizeof(struct io_bdt *), GFP_KERNEL);
 	if (!cmgr->io_bdt_pool) {
 		QEDF_WARN(&(qedf->dbg_ctx), "Failed to alloc io_bdt_pool.\n");
 		goto mem_err;
-- 
2.25.1

