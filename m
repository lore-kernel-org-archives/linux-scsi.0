Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794233868;
	b=EANlP7uSHKkzIRNwIwcDAnchYqe9/ivciDMHTVVOfVamR2ZN+BeVtS0nfU6YQu8zooOG
	 JvZjQPUq6+CixKWRW8P2059zJe3Z+2nlJuR8RKa0ZEYekgHgAaCdF7VTFU2Jg5adRGM3C
	 vuT0AS8NDT+rOcxIyvprz2o2c9I2a7qYJ3lBNF36XtqmE6FftDeWmpeXlAtR/r/V3FuTj
	 XdG7WBQdwcG6n2OMDPbUD4zFWyWrVtGSHfuIOnROCPh6U7e2wknWDdgw8VXvIcVUt1/mM
	 AIe6arHPyjwTb4NcFNFF+W+l3T6XnPmfodCrM+AdCS6TyJFlKKQaglL1TMop9UvFHDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794233868;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=XR2x7H0QDMg9NEfvtp2YYokzFcl3lf1p7mfJHpawz4U=;
	b=pscLf/PNR0CctxpCTTxeR5/GhQIN5KDG0WLRjB0APpNWkJeA4a/22DXshHnuhFWk4sHk
	 UQDUB5NIfNqXNIactIqVQGHCUmxA6I53QLUjZFK30rKr+Q95FpAgh0QryZ1gC8N9vT5SI
	 rPa0tf1Sa60ZNcjjP0tHGNiVfZ5B1ogyMFQJLJ8vrcduiRs1vUhWKCVTaijW7DG4VDufm
	 iER1L9RnY+es5AKnobL464aNaMTe4Fizg+bPtpEtwPesBxNWkwtzm7wN72d9nwNJ1A9/U
	 ooZzKYaLt3JVM+tC+FDXNWGK2YdI5Kam7KpRyXoGYQRAJRZbEmQl/etT9HtR9Ngt7mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gum9HxiD;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7AF606A322
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 14:17:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C7AF606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gum9HxiD
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a215e64962so10784045e9.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Nov 2026 06:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794233866; x=1794838666; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XR2x7H0QDMg9NEfvtp2YYokzFcl3lf1p7mfJHpawz4U=;
        b=gum9HxiDEc4SHVuULNqRQVFj/LkYh75l5bdGaESip8ZtAyxcFdcDV3vL2Gdl3WeKie
         aB+3fKamh1hjGlq/C2JRb4vgAp8mDZzk7TgAuDwP54iz52lnCTdB67QP77cKMIgoi5wA
         7pTpzs04zXeLOF3fGiplWSskb+rJDPrR+2tHlEEsMS19fqQ42w4kie3HruB+vHdVQAiY
         wJJMkflMfr3tDNax2EnEQMvz8I8v6OGykqhLYxksijWnNp+QThTgU9WjsVVK4k2OAOef
         txTt4Z5XtpPKa6jSZWbsrF6GdnOtGtCbIzIBJkoyAasbcSTLbMWZTL33a6mC08n9Wczh
         6c2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794233866; x=1794838666;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XR2x7H0QDMg9NEfvtp2YYokzFcl3lf1p7mfJHpawz4U=;
        b=HWnl7c/6LVGrGdGxqpbYYurkJg6c30CxF0/OQ9XKiL9OpNbsNLJE+jTG4zOpzgdWlv
         yvtKns25WzMrtICyEhe3S/sQs7mD3OLtI92RipIymTEy/ygdIVh7argCO3aD9FFYo/w0
         fs6HWY6tkRczCj+zy9zIWgkN1aQlDLw6PPLL2qydxK0OVV1GcHHQrboyf1f8XtuHOyN9
         0VYmqS3Slg+qL+lDd4O0asUCl7ygfSLqoL7wWDqIReFuicWWO/+YhpVSBJNV7Ub36dP2
         IvQRhByPZrjPAMIHJugtqc7yQ4rHe006le7E0EjJmwIH1oiY9RxWydOxrG45kuptvqoh
         UdQQ==
X-Forwarded-Encrypted: i=1; AL+hErFc0g/aGSqNRjnokqK+pFvebDFLzJJjRhC3ktIWpO3/FzDrzbs3kDjQ/s2JjqEJUrjJI5ASxaZ8+pcu@vger.kernel.org
X-Gm-Message-State: APuU4Z9FYsVDnI2vIczsh60aFx6llkixjjNkjQSRi1XjgqtX68FsjqgO
	OzVGXtQrxfmL0v4aOBK+ZvKrtR1vOJDtOYE3PJnoEhoesPADeftC6cv5
X-Gm-Gg: AYBFou1hONWgBgwqfA7uzURX4kJAERj9VUs8FYRTbCujAsCIGRZGEwHTAjk3Qlwtbfa
	ENNOR7KOvXz4Q1tjVxNp4NpOjQ0BPlOhYhsOFGo1e4vGSsSLiU1Iji5UrdRFG3GR6SMsD09xSAd
	Xs9JG7rnCDqO9Ox3w4EJiFhypB7f2n5eyVixM87s2phV11UdH2Qby8yj7rQDgQcneVqD2vwYGVd
	ADvPBaVuJu/45msXo9EhEcRXxctrr8NVCjRBzw9OiQ/ujzYryNhFpBohxLgccn1ugyCuJhF7iOT
	MxDnr/CeGOXSKxDMpG0HiVrkKiblawdlE9OaZxEQcT7pfMO2PSy3BZZ7nXTbWjTmxOGCa2eaww5
	6xL2SPRMGlDuvyR0ewGdjt/UvPn0XeT3CDDkbBvRq1pU6KKjcD1BjTZfNlVohIziImpu9L8gRUC
	j66p07Atyl5n+TfjIef7YlizVF7H6nxZ0M0SVGZvkII0fRcuHgu5xlRmhnT5chDqIrXlrcSoaV3
	LoF67w+TqqGRfdIS5z/xY/fn1G/j1Y/WhPuEZ46qB+eWDjiCuPopvrWNAbHpJaPV5oqCLbB7kk7
	txEBxytOqRfyzUNnSTKQF5e9WIZL2IZlXnp6DZyF3Q==
X-Received: by 2002:a05:600c:3b0e:b0:4aa:15b1:d4fa with SMTP id 5b1f17b1804b1-4b963c75e37mr80638945e9.5.1794233866115;
        Mon, 09 Nov 2026 06:17:46 -0800 (PST)
Received: from ADRIAN-PC.lan ([171.22.87.31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b7efb134ccsm218255955e9.10.2026.11.09.06.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 06:17:45 -0800 (PST)
From: =?UTF-8?q?Adri=C3=A1n=20Garc=C3=ADa=20Casado?= <adriangarciacasado42@gmail.com>
To: Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: GR-ETH-Storage-Upstream@marvell.com,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Adri=C3=A1n=20Garc=C3=ADa=20Casado?= <adriangarciacasado42@gmail.com>
Subject: [PATCH] scsi: qedi: Add __printf to debug helpers and fix format strings
Date: Mon,  9 Nov 2026 15:17:38 +0100
Message-Id: <20261109141738.1624579-1-adriangarciacasado42@gmail.com>
X-Mailer: git-send-email 2.39.5
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

qedi_dbg_err(), qedi_dbg_warn(), qedi_dbg_notice(), and qedi_dbg_info()
format their variadic arguments via struct va_format and %pV, but unlike
their counterparts in qedf_dbg.h, they lack __printf() attributes in
qedi_dbg.h.

Add the missing __printf(4, 5) and __printf(5, 6) annotations to
qedi_dbg.h and fix the resulting -Wformat warnings exposed across
qedi_fw.c and qedi_main.c:

 - Use 0x%x instead of 0x%p for cqe->rqe_opaque (u16).
 - Use 0x%x instead of 0x%llx for pbl->address.hi and lo (__le32).
 - Use 0x%lx instead of 0x%x for qedi->qedi_err_flags (unsigned long).

Signed-off-by: Adrián García Casado <adriangarciacasado42@gmail.com>
---
 drivers/scsi/qedi/qedi_dbg.h  | 4 ++++
 drivers/scsi/qedi/qedi_fw.c   | 4 ++--
 drivers/scsi/qedi/qedi_main.c | 4 ++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_dbg.h b/drivers/scsi/qedi/qedi_dbg.h
index 8649518658691..70acb55847f4f 100644
--- a/drivers/scsi/qedi/qedi_dbg.h
+++ b/drivers/scsi/qedi/qedi_dbg.h
@@ -78,12 +78,16 @@ struct qedi_dbg_ctx {
 		qedi_dbg_info(pdev, __func__, __LINE__, level, fmt,	\
 			      ## __VA_ARGS__)
 
+__printf(4, 5)
 void qedi_dbg_err(struct qedi_dbg_ctx *qedi, const char *func, u32 line,
 		  const char *fmt, ...);
+__printf(4, 5)
 void qedi_dbg_warn(struct qedi_dbg_ctx *qedi, const char *func, u32 line,
 		   const char *fmt, ...);
+__printf(4, 5)
 void qedi_dbg_notice(struct qedi_dbg_ctx *qedi, const char *func, u32 line,
 		     const char *fmt, ...);
+__printf(5, 6)
 void qedi_dbg_info(struct qedi_dbg_ctx *qedi, const char *func, u32 line,
 		   u32 info, const char *fmt, ...);
 
diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index c8af10c326532..18df8b0138ef5 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -339,7 +339,7 @@ static void qedi_get_rq_bdq_buf(struct qedi_ctx *qedi,
 	}
 
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_CONN,
-		  "rqe_opaque [0x%p], idx [%d]\n", cqe->rqe_opaque, idx);
+		  "rqe_opaque [0x%x], idx [%d]\n", cqe->rqe_opaque, idx);
 
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_CONN,
 		  "unsol_cqe_type = %d\n", cqe->unsol_cqe_type);
@@ -378,7 +378,7 @@ static void qedi_put_rq_bdq_buf(struct qedi_ctx *qedi,
 	pbl->address.hi = cpu_to_le32(QEDI_U64_HI(qedi->bdq[idx].buf_dma));
 	pbl->address.lo = cpu_to_le32(QEDI_U64_LO(qedi->bdq[idx].buf_dma));
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_CONN,
-		  "pbl [0x%p] pbl->address hi [0x%llx] lo [0x%llx] idx [%d]\n",
+		  "pbl [0x%p] pbl->address hi [0x%x] lo [0x%x] idx [%d]\n",
 		  pbl, pbl->address.hi, pbl->address.lo, idx);
 	pbl->opaque.iscsi_opaque.reserved_zero[0] = 0;
 	pbl->opaque.iscsi_opaque.reserved_zero[1] = 0;
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index f394fcbb97e7e..278dcea9f05e9 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1128,7 +1128,7 @@ void qedi_schedule_hw_err_handler(void *dev,
 		qedi->qedi_err_flags = qedi_flags_override;
 
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
-		  "HW error handler scheduled, err=%d err_flags=0x%x\n",
+		  "HW error handler scheduled, err=%d err_flags=0x%lx\n",
 		  err_type, qedi->qedi_err_flags);
 
 	switch (err_type) {
@@ -1581,7 +1581,7 @@ static int qedi_alloc_bdq(struct qedi_ctx *qedi)
 		pbl->address.lo =
 				cpu_to_le32(QEDI_U64_LO(qedi->bdq[i].buf_dma));
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_CONN,
-			  "pbl [0x%p] pbl->address hi [0x%llx] lo [0x%llx], idx [%d]\n",
+			  "pbl [0x%p] pbl->address hi [0x%x] lo [0x%x], idx [%d]\n",
 			  pbl, pbl->address.hi, pbl->address.lo, i);
 		pbl->opaque.iscsi_opaque.reserved_zero[0] = 0;
 		pbl->opaque.iscsi_opaque.reserved_zero[1] = 0;
-- 
2.39.5

