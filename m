Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B93E18E25;
	Fri, 31 Jan 2025 19:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738353284; cv=none; b=TOZ3wI8HxxX4zsmsBB3qEiLiEZxtN09VpzbyaUm6CFTpQlWvu+GGD9WEvM6kgsXzxOmIyWFciUtcHg1sakUfQe/4rtvr+5Dp3AlwD8GfwFaBGIaoxyVbOG8jXCyELfdrVV75vCcVMSy38y1CknQRLJR0lhlJlgQB9eZvkuTnVcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738353284; c=relaxed/simple;
	bh=yRgg57v8l6Bf6W7iDdpaDqKUC+hTrmYP1cTKHibmrZk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VMrQhs+1pyt9wEIhxilKaLNaJl7YsdoY0UVKHJivvieH2+bkPgaIGbR+ahU/pPkP1qJPQCQsLmh0IsNqzV1KFugVEezG6TMNKqDHgn/wS9655WUnDr72ABxNfPmYCsjKXozdlRJBH0k0yOG6fmPJ0EY0EsPJc4k/RP0Xn4jcBck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ivoWdRjr; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ivoWdRjr"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7be49f6b331so223460185a.1;
        Fri, 31 Jan 2025 11:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738353281; x=1738958081; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wQBsWorX0cIsExRPNC9YIpNNziNST6PMZ9AVDEQARfI=;
        b=ivoWdRjrD+OaUtvDXdUE6rWAAOEnC1zxILU3I280+yDr5ETiHhapHUAL3wBiDFB9g7
         11jPLbgM8yKI2nuactmYeLxxWXX6n/Y4sSzec8IoRLSSxDQbt4X6vu7/MdAvvAJk3gZS
         wthsfWn4wsOk0BX2G4UwnMwSf89TbcS/0iyW0lxVupCUwEi39BZxmdOMGj79zZuQol9h
         b/glhJlsYQtbNFpeqSsTZJmbLIeQL2l9PcLrdjZRVXhoMAWOqtuXvOByD91IsybnTG8Y
         nZcH9dMk+7B1vTfMEko/VbXiGogl+FygN4ha0C2vCOuIzTj02Izmg01TR+V5SalirYsp
         H0Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738353281; x=1738958081;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wQBsWorX0cIsExRPNC9YIpNNziNST6PMZ9AVDEQARfI=;
        b=GPmos+YtRm3uzC6BlWxMEVhhqAnI+nXxFTIW2WdSYGAGmdVjRjPxywzMqN5FJ+QYbn
         EV1xkvd1kKGSHzkUwDthgWDWuAVMpaUPkwxQ8upRHiutxWL1w/4KRfEhMsR4XCxLUp2N
         ODSO52yMs2EZAFYLu+EZOwrKf8iiD3ZCLauUtZZQKTfqrG/7+HYssCDTGR6JJDBJzxfF
         IUdOUT3p3zOI8+K/a4CxGkhVthDYSVmnFcm34OQ6RzvFklcH0cy0L0uyEOEMLiZlcp9q
         WgVUotVeWE4Q5iyP2FsV1Ne0yMa+TBWe4Zm88VLPyrt2VHPEf2nkVVczjkwuQZGhHECQ
         o7IQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwQcsLVW6hYVg9Bz7lb03kAS+X6tK9aIeP4+CSMdKfCLetEzfNuLYPru6eZlh3S74bj32GGfUa2e3A+LY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyqzL2XxNf5gHSecbIS6SWYyEd1mpeAnB6moQMp7gZ/4GN9CC4
	ev6WPQONhNfeFwShS/hQIzWWskeEJFYPRGKM+D9/1xQAA6pPb4kC9P3xFw==
X-Gm-Gg: ASbGncvwxDjpjU4SpZ/VV5h+KtsMbGLYYM6ZbwEDi9s2ke6m+HRw/6uxMYAcAk7Q4gQ
	1GVhPs38mV/H0+0crYGztXbhRMRnP6UZppLkySj3xthIbly61PgKwLW6joRHwwhlLc6FMuY3t55
	EnyYk7fvhjR4b0GKuhFzEoeeijW5HE6zx5B7wKvWlomabrIgCjud05hFQWmwEfa4IeuFZHV43a/
	rRqmoNZRSgEkiInK9qk/OQBYbJ/A4n95dZVQeAJrEWv5B0hEyP9EqXrWxXB0GO76dtK3rkUvRw2
	Ps2f3IxVskM+zwWrkR8jV/2u5p9YKbUR2Ly+ww==
X-Google-Smtp-Source: AGHT+IGFOZXEoHEo/HtWdhJv1TBReYdVOEpsyJUisgm/UkZu+7swupwpa9xpt1Fqbtj/zToH1/Sldw==
X-Received: by 2002:a05:620a:2694:b0:7bc:db11:495c with SMTP id af79cd13be357-7bffcd9d416mr1908112085a.51.1738353281334;
        Fri, 31 Jan 2025 11:54:41 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c00a8bb957sm224423785a.14.2025.01.31.11.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 11:54:41 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: skashyap@marvell.com,
	jhasan@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	manish.rangankar@cavium.com,
	nilesh.javali@cavium.com,
	arun.easi@cavium.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>
Subject: [PATCH] scsi: qedf: Use kzalloc() and add check for bdt_info
Date: Fri, 31 Jan 2025 19:54:38 +0000
Message-Id: <20250131195438.44964-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace kmalloc_array() with kzalloc() to avoid old (dirty) data being
used/freed.
Moreover, add a check for "bdt_info". Otherwise, if one of the allocations
for cmgr->io_bdt_pool[i] fails, "bdt_info->bd_tbl" will cause a NULL
pointer dereference.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
 drivers/scsi/qedf/qedf_io.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index fcfc3bed02c6..a5970fee6851 100644
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
@@ -254,8 +254,7 @@ struct qedf_cmd_mgr *qedf_cmd_mgr_alloc(struct qedf_ctx *qedf)
 	}
 
 	/* Allocate pool of io_bdts - one for each qedf_ioreq */
-	cmgr->io_bdt_pool = kmalloc_array(num_ios, sizeof(struct io_bdt *),
-	    GFP_KERNEL);
+	cmgr->io_bdt_pool = kzalloc(num_ios * sizeof(struct io_bdt *), GFP_KERNEL);
 
 	if (!cmgr->io_bdt_pool) {
 		QEDF_WARN(&(qedf->dbg_ctx), "Failed to alloc io_bdt_pool.\n");
-- 
2.25.1

