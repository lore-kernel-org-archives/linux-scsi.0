Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB03B19EEC7;
	Mon, 24 Jun 2024 17:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719250348; cv=none; b=SVFHpThHga6OGr6c+uBi3PidXdaqNhqaOSzM+kmxqTFvxZEONLNXZupmEJBvg7E6N8+MPhtTYR9tvap2KTOpIXasyuQq4GJR76EV/HR2lPJwX6/2Yd5OAbRSU1jrFn+z2MRcB20mbTYPqLzOgu8z/bkLlvg5cki+0fpaeZlcf3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719250348; c=relaxed/simple;
	bh=iX6goktvzhT6WdoBaNOIXv4P9HAOaQqywclZHILktE4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=arEoTBLZxDpyVfw8S+WogzT2DnS68qenOULJdw6bzmrJd1N0juN6OAxkAbLxKqT+8OolDSrAyfIS67TE6WmQc9pyFa1F0vzTBZPPwsEgo2ilgN8Gy27HV72NvH9F161wJTusvzwDk/alM19dMT6r67SN8aQdIuFRo51i3lcSxwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W4Cd2kx2; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W4Cd2kx2"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1f9aeb96b93so32952455ad.3;
        Mon, 24 Jun 2024 10:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719250346; x=1719855146; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oVqJqicmnRX8AxcmWbCX9tVc3ExkfG/CAJGav43R6Fs=;
        b=W4Cd2kx2rZTez1JnCInHcoXNaabw3j1PaeLq0MOMFEfRElfXQEmq9Efnn4jWZVMLsC
         OKHxRC9zl4+5a7YQNg+1B/u5Iiob6bLsLH8kAwRjdEoMtFBpcCSYb4oOK1SfYlpjUNuJ
         9Uh+0mpDdj4Meq3bzMZmbV48B2X2TroibXdwjedv+jNoBaA1rqpDhbdXmoONTN+upo2K
         aRGs1Hx/vCSiuvQAg/jkyaig2Q6bJU18LbA9xwpEQtOdSTyVcAlgD8lLtXhh9PUuQKq8
         co/EShfooh2t/bKa9eAhXFqSa9RaKZyNCsqko9uoatS8ItcWkrVD9j7UAV0IXXbxzsx4
         uhFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719250346; x=1719855146;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oVqJqicmnRX8AxcmWbCX9tVc3ExkfG/CAJGav43R6Fs=;
        b=fkVKKoLgAqBQAx0ftCd5FRvv2c6eudrndlqWMtZyO+z7i6GGn9uP9h0XaD9kJ4PH9u
         Hl4YpOTD3X9zm32134Ll35cg1K3SSpd6RoIgIz+7EamOx/H+4rWSWsKnttDf0YanDXve
         Id6xxVKAiLQFaicRSuCbfmgt54l/a79bC5KVqWZ7Bdt/Q/kqnoSMUwsk7Lk7Z6bcInCm
         1UElgORZ0OdFI4O828zS5Kdzvdihcy7lDLXE3uhm1GJ42eUGZWFXqfFpFPZhbZ3ZhC/5
         LMGY6JbTD++sHfOxNqZCp7GvaVOoSIhwASz6TxC0lhiNSDrDu4b2NJ647HF21ZpTETjm
         SrWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzGigLxU0Jc2zrvGZVrALFyXmtWk/oU/QgP11wR8GUwH2YxAJ6bejQuK2ZEXSP3Ns8XLDO19u6FmkT8JGXXKqbx5sykPWlq8JEDiW5
X-Gm-Message-State: AOJu0YyekciDeVOnEDwIJXs3L0S/zcHW4/lV/rzAtPz32MPUzuRcJbq9
	PkaBDldX5evlUjgmESrBC56ukMXLJRFmmpcClYy4jGyVnppkS0o/cpanAH9a
X-Google-Smtp-Source: AGHT+IHvkgQK4JMUUiNz6TVhuk05X7MKpmzxgHlYVQ7JLiUPt3X8lWAmLQyx9a/07ICRC4kEJrRznw==
X-Received: by 2002:a17:902:da84:b0:1f9:d6bf:a67e with SMTP id d9443c01a7336-1fa23f149b7mr61693755ad.69.1719250345887;
        Mon, 24 Jun 2024 10:32:25 -0700 (PDT)
Received: from localhost.localdomain.oslab.amer.dell.com ([139.167.223.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb3c6027sm65244305ad.133.2024.06.24.10.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jun 2024 10:32:25 -0700 (PDT)
From: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
To: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: prabhakar.pujeri@gmail.com
Subject: [PATCH] scsi:Replace printk and WARN_ON with WARN macro
Date: Mon, 24 Jun 2024 13:32:05 -0400
Message-ID: <20240624173205.1227297-1-prabhakar.pujeri@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch modifies the error handling in the SCSI library and Initio SCSI driver by replacing the combination of printk and WARN_ON macros with the WARN macro for better consistency and readability.

Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
---
 drivers/scsi/initio.c   | 3 +--
 drivers/scsi/scsi_lib.c | 5 +++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 625fd547ee60..39273457f5bd 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2737,8 +2737,7 @@ static void i91uSCBPost(u8 * host_mem, u8 * cblk_mem)
 	host = (struct initio_host *) host_mem;
 	cblk = (struct scsi_ctrl_blk *) cblk_mem;
 	if ((cmnd = cblk->srb) == NULL) {
-		printk(KERN_ERR "i91uSCBPost: SRB pointer is empty\n");
-		WARN_ON(1);
+		WARN(1,KERN_ERR "i91uSCBPost: SRB pointer is empty\n");
 		initio_release_scb(host, cblk);	/* Release SCB for current channel */
 		return;
 	}
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ec39acc986d6..54a4122c93f0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3117,10 +3117,11 @@ void *scsi_kmap_atomic_sg(struct scatterlist *sgl, int sg_count,
 	}
 
 	if (unlikely(i == sg_count)) {
-		printk(KERN_ERR "%s: Bytes in sg: %zu, requested offset %zu, "
+		WARN(1,
+
+			KERN_ERR "%s: Bytes in sg: %zu, requested offset %zu, "
 			"elements %d\n",
 		       __func__, sg_len, *offset, sg_count);
-		WARN_ON(1);
 		return NULL;
 	}
 
-- 
2.45.2

