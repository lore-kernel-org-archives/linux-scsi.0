Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24DA1C007E;
	Thu, 20 Jun 2024 17:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718906279; cv=none; b=rJXMwiavEGLrNR5XPWLrWxBMEQ4ck5iimJHiSTV9YKFstZeVorwltw+Dg0J6wW58OGP5eZOUJbzHIRNwNNVo8KUboioBCmcO6wwN6IJxjMPA8RofcyG5c1KkrA4Zj8hU4yDFcr3dY6DL49fKa4uy0dcjp8H0s3ScnFJ9HQoKabE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718906279; c=relaxed/simple;
	bh=FZM6CosxQTAEV5PQ+/KRibOjH9YQS1OMFOTTqUFKpt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3oiB6K01w4kVVpykEAqRvOK5xgqAF5+uoM55C06nGXFG41Kt/uSx2Sgn9yKRewHVGQD5danNOdfcGuX480051LhLxoQ7yA9geDJmhc0+jGJair1ehs66WKe1jPV7aX80CY5wYGpf95ZP0k5NdBberd/qNvUyJpGAhzPTiCMBHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c7UlnWPU; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c7UlnWPU"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7041e39a5beso983263b3a.3;
        Thu, 20 Jun 2024 10:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718906278; x=1719511078; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jBNHO7SGyRYGtIlT3hp756CkWMYdfL+ybrdFx5N+b+g=;
        b=c7UlnWPUUeUtVJwNjx5kaf5cEPYr8gJT/g6NqoxuM2c8u99lOEM7WG946Gmskbsixe
         ET3g/tjhaRsHUgUTXKZs9j/joP73X4itynY146LlhwPyg0+LSquleQy5t6PaLOxtJWej
         1kchOVnLY85P2W2EOiYOD9Uku3EvaDNtES7wQWoS7sSGn70Dl9Omk86BwdgIIe6pOT4T
         RxY8ywVw0F76TUrExceypvNASojCuWxPH2NYV9qzM3nrMZ810vAHWMrYqv+q1saNAJDG
         mKHw876SetKlhauXdG1+VfIyCKyNzV4KrqsOTrnGB3aScpVHnkhXjcufYy54ElKDH/DM
         9PpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718906278; x=1719511078;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jBNHO7SGyRYGtIlT3hp756CkWMYdfL+ybrdFx5N+b+g=;
        b=i2B7aQ2weAwynSUoCNN7YXTcMU5Ofn+hDZkh+J+zCRZzEY7sRCUq+OhANb/SzXxnOE
         y+G1TLWqfGaUr+Yfn6sJ+vIC852ENSjJm2tKgBPv7QyGCOmE6xlZ3OyjO450sXCGi6Tp
         RDZ/SbRgMdwiX1MPJwn5v6drEUwxTfnuaJ7zDQlCBSTzSoCxFU/rO3VIQNVrJTFLxxgY
         W3jHzR+cKCOvyQ/X5pAYni0BczdN7c/MPVsEgDS5t/4+q8+HpVdZ37fstrl6sP/NbeOj
         86gaIespaql+Mz8Y5fv9uh7FE+nfRvQUWBOauDIpbY9HQRVlaKvRx6R1rg7nukHRxxE5
         CW1A==
X-Forwarded-Encrypted: i=1; AJvYcCXzy5klCf48bSgj1DFSs9kihsjUnUfiPg8JS1P7HapQbvMJH0S5nBUrljyu1osodXcGgb4MN420V9DQfHMEI1IxFu7412E1k/pL5A==
X-Gm-Message-State: AOJu0YxnekfiQOsxHeLfImEok8UecXoWHD7Hmguo3XEiK95lVTgEBo2M
	u8k50saptDA/I6XVAwCQQZMODnKyjNnAYM330giPZDRyy2Gp+G/QvMeCB192gJI=
X-Google-Smtp-Source: AGHT+IEkRJptF+yJLHlQoKp30dUDbXDqMnSMJA9iS2RvxoRFsvlFT1i8S85A1astV7Xk0uWHBXz5XA==
X-Received: by 2002:a05:6a20:c120:b0:1b6:dffa:d6e4 with SMTP id adf61e73a8af0-1bcbb451678mr5750153637.4.1718906277953;
        Thu, 20 Jun 2024 10:57:57 -0700 (PDT)
Received: from localhost ([216.228.127.128])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ccb92c89sm12586864b3a.213.2024.06.20.10.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 10:57:57 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
To: linux-kernel@vger.kernel.org,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH v4 17/40] scsi: qedi: optimize qedi_get_task_idx() by using find_and_set_bit()
Date: Thu, 20 Jun 2024 10:56:40 -0700
Message-ID: <20240620175703.605111-18-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240620175703.605111-1-yury.norov@gmail.com>
References: <20240620175703.605111-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

qedi_get_task_idx() opencodes find_and_set_bit(). Simplify it and make the
whole function a simiple almost one-liner.

CC: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/scsi/qedi/qedi_main.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index cd0180b1f5b9..a6e63a6c25fe 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/find_atomic.h>
 #include <linux/pci.h>
 #include <linux/kernel.h>
 #include <linux/if_arp.h>
@@ -1824,20 +1825,13 @@ int qedi_get_task_idx(struct qedi_ctx *qedi)
 {
 	s16 tmp_idx;
 
-again:
-	tmp_idx = find_first_zero_bit(qedi->task_idx_map,
-				      MAX_ISCSI_TASK_ENTRIES);
+	tmp_idx = find_and_set_bit(qedi->task_idx_map, MAX_ISCSI_TASK_ENTRIES);
 
 	if (tmp_idx >= MAX_ISCSI_TASK_ENTRIES) {
 		QEDI_ERR(&qedi->dbg_ctx, "FW task context pool is full.\n");
 		tmp_idx = -1;
-		goto err_idx;
 	}
 
-	if (test_and_set_bit(tmp_idx, qedi->task_idx_map))
-		goto again;
-
-err_idx:
 	return tmp_idx;
 }
 
-- 
2.43.0

