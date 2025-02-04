Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D3825A634;
	Tue,  4 Feb 2025 02:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738637513; cv=none; b=MaXB7qux6oHxV5pnuek0nixymoUB5Fk4uN89qRzT4xzSAg2AgTXWRDISTMjkH0CEzmYEkzl0v41nwpShWcg5725sxBLFFYuhlUlrj9dUPDf1fK/eu+n8OVyKlNUeFAqwldrmYP2vhzxAUnN3gvjqHaorT5zUhBbrLL12qCp/EUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738637513; c=relaxed/simple;
	bh=oRGHy7fZ+dT6ByTKD/ip9ur3c/zbUc3s09NFJI7eQZs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ESD9gwBW0/8YqMwRq6GhXeV9vLVbU68OCEvrvd5aePDY0bjzrnqy8GVFfe2ZEV5MQy4BazYKczRdo+HLIywFhH6iRy6aHaudZJVo8ACG3MM8R+mznA6L5mIGIlMRiyODFD+/tmDDU9sfSauyi7XlOvPZMuF+fmPNzk8yVa1G1us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=htQkQhRA; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="htQkQhRA"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-46fcbb96ba9so55681291cf.0;
        Mon, 03 Feb 2025 18:51:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738637510; x=1739242310; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ivBchD4X6ys1FY2fq4DelynYFkRQTroONdIAdekump8=;
        b=htQkQhRAMSYZ1vY7vH2BznrnspPlVEe92lELPgwcOTPb3UM3y1KpsVYftQ/S7vcDCd
         r1g+/kXyGz/vajh+cVhEx2a/NnRr0Wia3PGxULrTcgAUNtoIOz2flHzN+80LgG7V2Bsv
         I41Xo8T5BE0n7CVCi7RBi0k0VkllcS9EVGztzeCwzZhPhq8NooVOl7BawWRhxfknU1FP
         2KGMppu5I97mJvFA04YMAAAreCPIGiPWA7NmGzsdRAq49Cu0PnquXtFQX7ssp8Ev496f
         yln/NRlGrpqBkK0Zqy0r7JEvIizol6Kbn9yeRoGIMe07UBcKraXZM1Mg90ebxPzl7Lww
         kGBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738637510; x=1739242310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ivBchD4X6ys1FY2fq4DelynYFkRQTroONdIAdekump8=;
        b=Gh3BL4hF/r7g/+CxnY58j26t0BrAefnCJtE+7uuzqppzodCCS6Nc+ECwKLcE8FxkuP
         n/zvT59MALInTYJjtIl39OxOfv/SItnZgdrQysCdW/hU22xKJjXThhlAdXd4N21Ixgpg
         RpDlI4JRFzU1Onje8rHq7jCVPKgNo2TqFtGxnQIUWfXw+ZfQMB9XZlA9NfjU1mUy7tHv
         qyk4Ic38iYU/tJXA4399JVBaCl0ivpXXA7+ifiNJsP1kAsvF32MvN6pWqkXKGCCWRLWI
         zn6nPc6B4uaGGiXFW7+mI7bt6/RZxNMK5AB2C9+AYVGG28GnSMg7MgLRVN9YXg9ndSTN
         fZsA==
X-Forwarded-Encrypted: i=1; AJvYcCVJnZ1nehlbPqO9SRBwKOLioRgA50AD0t11JHm7d8gqiVHqK173TqRBv/BbYl3qDaUWxcrrpB4gE0VXqg==@vger.kernel.org, AJvYcCVNBiTIwmCcTBefLDAOS0/n/NXTCV567xxfEo558WefoNEy0/cbDx2zKObcy4E1ouNvgHyW1R5q@vger.kernel.org, AJvYcCVXlmNQucb/2lPNbjx+MtD9tyzES3yRe57aH510tOgZ5I5X4nhuQIVEVVo/hGnHCxrPDLoTipnylrV8bok=@vger.kernel.org
X-Gm-Message-State: AOJu0YynKp6FDw93FNRPKKZAmUdX2F0X3zqeeqtbh3zTCwik/2ac48MD
	EokDaXbklrP87tDKIwm67vzD8QJ4Efu/WtIeiZzwRPX9Jz8KW6CZ
X-Gm-Gg: ASbGncv/4Eqc3XuWTCOqXKbVWg3/Lhn4IXiUMNpKJwMNTBaFUGMdgjuKjGKlOLjkQcl
	+FMHqD/arh2QYZp9r/4zqPWkqwAfK4EuHJWtIBTRgVLDYSuFvmkbqBrjW/Z+v4uqM9OqGQroxQL
	lVMSLA8FRAuU5UJKc+/ikjZuXGJng5CLQUsN37RaCKHQe8FDdQcayngYxRjdsh7wWZTXS11UQM4
	OHG8TSjNW4pIhCH/0kM0Gr10560wrVthwpq+srOubgScO/45xjUBBHc0pOpouH6A2oD+Xb5rSwm
	7xrm8IbzKk/T9ysnNzSXNeuWelFjR1NYMP0zsg==
X-Google-Smtp-Source: AGHT+IGN0szxqTdm3WnPbWp0o+SHy3jhsfaiy60dqRbcz6GBU/UP123wd6a9/NBF1RSfOo1Ql/AdYg==
X-Received: by 2002:a05:622a:11cc:b0:461:313e:8865 with SMTP id d75a77b69052e-46fd0accad8mr362847121cf.21.1738637510281;
        Mon, 03 Feb 2025 18:51:50 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46fdf0c83dbsm54222661cf.30.2025.02.03.18.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2025 18:51:49 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: markus.elfring@web.de
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
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
Subject: [PATCH v3] scsi: qedf: Replace kmalloc_array() with kcalloc()
Date: Tue,  4 Feb 2025 02:51:47 +0000
Message-Id: <20250204025147.14836-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <6221018a-873d-4fd5-bfaa-5c83d09ea2ac@web.de>
References: <6221018a-873d-4fd5-bfaa-5c83d09ea2ac@web.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace kmalloc_array() with kcalloc() to avoid old (dirty) data being
used/freed.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Cc: <stable@vger.kernel.org> # v4.11+
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
Changelog:

v2 -> v3:

1. Remove the check for bdt_info.

v1 -> v2:

1. Replace kzalloc() with kcalloc().
---
 drivers/scsi/qedf/qedf_io.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index fcfc3bed02c6..d52057b97a4f 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -254,9 +254,7 @@ struct qedf_cmd_mgr *qedf_cmd_mgr_alloc(struct qedf_ctx *qedf)
 	}
 
 	/* Allocate pool of io_bdts - one for each qedf_ioreq */
-	cmgr->io_bdt_pool = kmalloc_array(num_ios, sizeof(struct io_bdt *),
-	    GFP_KERNEL);
-
+	cmgr->io_bdt_pool = kcalloc(num_ios, sizeof(*cmgr->io_bdt_pool), GFP_KERNEL);
 	if (!cmgr->io_bdt_pool) {
 		QEDF_WARN(&(qedf->dbg_ctx), "Failed to alloc io_bdt_pool.\n");
 		goto mem_err;
-- 
2.25.1

