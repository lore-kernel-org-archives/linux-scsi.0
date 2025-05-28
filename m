Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA7E10E3;
	Wed, 28 May 2025 11:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748430392; cv=none; b=Yfy4KzOB02l0hXe9lYbXdkih+IkNp/5get1ybqPZprCwNWJl25zoP3tAtEtSTofF/p1oXWDJNv6th5EPwtkkI5xBJCrQXpQh0v+WWlVIOeO7kGFgjv6jdDSUybbVROQQ+BtKbKHcy3Xp6I1sxtqHRGMtF+6B5ak2+BkKz+lKkqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748430392; c=relaxed/simple;
	bh=S86bE+CZYJTIIzSvO1HLsPpFu3Cqqm2vVq94kkR9G3U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eMd/HyN61p6k+jEhGnSVMnMT/+K9+utEbxHxvyS0RdwYXYEDJ9+QuLa5tgJVvdvRu3OegahTuLS5mDz46KCVtI4UbUlf0v9scOPO7WqH+lKKAUkNLLXlmlzQnhez86M/qOmOlNJki7b3UArEAAn2I7AqXTbPdzaIPki8kcck/w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T7rEO6YK; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T7rEO6YK"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-23461842024so28878705ad.0;
        Wed, 28 May 2025 04:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748430390; x=1749035190; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/NfLLoYje6TeCIcPGwi+F34orXeuH9dIWtmc6GhXbAI=;
        b=T7rEO6YKpJTa+8esH16od9JMtTxC5EqTCQ1aTjNRD+A9qDybd9V8CIbV/NJkzKEiY4
         Ateagoi3T2xyY/dU8S+Uk7w+tNZaXVY8rEmGSeFHGnI0U8EzgNxcrScgyL6zzN/4S7jn
         M/YOD/iiC00rWcPesT5JP458vVxwsK/ZAWWqmlYOWm1xvdOwNghaYKBVvkMOwRYlEWeU
         ArypR8NiJQ0ax6PWpiLkumMYHgd/V/mFLHBoyM3Gy+1nJ4pxq+UfXvxs3UvK6fGQ3dY7
         TVZpoAs49565PN6+ETqPhVnM5JTUHq51+PwKm80GKPk9S3UF2OWKkr4gpAI1JX1mvyUO
         B2TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748430390; x=1749035190;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/NfLLoYje6TeCIcPGwi+F34orXeuH9dIWtmc6GhXbAI=;
        b=CzT8fyZ5jDf/xhg4xQoCdRikiD4yZrDsa0rNwWljqb2zWGST0GVkbDQ/yT111I8c7R
         yk6Ak6lYTFT0I4ttsPdDCF1T7jCq1Bu+bTWVotDdpuzn27djorHMWqoxEbmM8T8VBds4
         jIvtzdfqEpdTNxhmYdpbzks9FMXFWCwxVFfkXwNHLwEirdM33uOYcj67oai5AK75pMNr
         I5orQ9OPQwGRXgMVkWGd39CtnF5EXZJVK11l6pRNzmcBYrmRguv7ocE+Xj37cEKGGPg2
         aP9wpe5pN4PIHpf/c4CaeT/RHA6VNU/pJtfXWuRRMfE0eOrOWwjqYlyQEP9qQk6T5OP5
         enQA==
X-Forwarded-Encrypted: i=1; AJvYcCXEmB15if0YSF+bMTmUpNb0OsdJ5XRTdlm1zQDR8NnHsipdTNAwgqXYXFEIEEZBCfrUis7PKolieb/7X+A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxR2wCpk7sDieENSEpxhL7/qeKhLE+8MB1fSqnIpU8jcfAtGAN0
	hodQyKU5h2zWDnI1BL6xOk8lW09Y4U2EZ03NDpDMXaYMtU9SSYm1m0SU
X-Gm-Gg: ASbGncv8EfSuSfBYp1dtqSSIIC74VQH59NGNwUjxFsJ7yXdgR5NcDSGvbW5xjxN1HtE
	vu+ZD/3dYTWqYk5BS1cbpDoVx+ujfe6q5sLD36gLElp2tr2dCMstTYwpL1abZaKX68RwVSxKP0q
	3fKMB1xjjP6ndbadhztSpfH6qnyDO02wjL28Ivp5U0NMavvbMfiFKD2Nvnt7Ka7CVv+0f/EALtC
	kOdNDmV2qOhA1+kDCv5tyFJQtp+5/nOEmN6kfJ2pwKL9M8TpSQN8N3y6EYdQPKx2gJ7t8Na4amS
	s1OaTbowXRyIvh9CadftVIqp0MNEgCM157hLoGj/OVRMi2AYk5xF0tjVCQlhCiLHOs1uZIJvSjC
	Rk76wdeBSg5y6
X-Google-Smtp-Source: AGHT+IGTK80Ujl5mFbyh6fHb0a2u+czeM3dYkdjcOoJJNc8pHcZ4yIsnmweMPJY00Emj4rNdFl0f4w==
X-Received: by 2002:a17:902:c941:b0:234:dd3f:80fd with SMTP id d9443c01a7336-234dd3f82edmr17101225ad.2.1748430389678;
        Wed, 28 May 2025 04:06:29 -0700 (PDT)
Received: from ankitchauhan-Legion-5-15ITH6.. ([2405:201:4042:d128:6251:cca6:7161:9079])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-234d2fe186asm9556375ad.59.2025.05.28.04.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 May 2025 04:06:29 -0700 (PDT)
From: Ankit Chauhan <ankitchauhan2065@gmail.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ankit Chauhan <ankitchauhan2065@gmail.com>
Subject: [PATCH] scsi: mvsas: fix typos in per-phy comments and SAS cmd port registers
Date: Wed, 28 May 2025 16:36:04 +0530
Message-Id: <20250528110604.59528-1-ankitchauhan2065@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Spelling fixes:
Deocder --> Decoder
Memroy --> Memory

This is a non-functional change aimed at improving code clarity.

Signed-off-by: Ankit Chauhan <ankitchauhan2065@gmail.com>
---
 drivers/scsi/mvsas/mv_defs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_defs.h b/drivers/scsi/mvsas/mv_defs.h
index 8ef174cd4d37..3e4124177b2a 100644
--- a/drivers/scsi/mvsas/mv_defs.h
+++ b/drivers/scsi/mvsas/mv_defs.h
@@ -215,7 +215,7 @@ enum hw_register_bits {
 
 	/* MVS_Px_INT_STAT, MVS_Px_INT_MASK (per-phy events) */
 	PHYEV_DEC_ERR		= (1U << 24),	/* Phy Decoding Error */
-	PHYEV_DCDR_ERR		= (1U << 23),	/* STP Deocder Error */
+	PHYEV_DCDR_ERR		= (1U << 23),	/* STP Decoder Error */
 	PHYEV_CRC_ERR		= (1U << 22),	/* STP CRC Error */
 	PHYEV_UNASSOC_FIS	= (1U << 19),	/* unassociated FIS rx'd */
 	PHYEV_AN		= (1U << 18),	/* SATA async notification */
@@ -347,7 +347,7 @@ enum sas_cmd_port_registers {
 	CMD_SATA_PORT_MEM_CTL0	= 0x158, /* SATA Port Memory Control 0 */
 	CMD_SATA_PORT_MEM_CTL1	= 0x15c, /* SATA Port Memory Control 1 */
 	CMD_XOR_MEM_BIST_CTL	= 0x160, /* XOR Memory BIST Control */
-	CMD_XOR_MEM_BIST_STAT	= 0x164, /* XOR Memroy BIST Status */
+	CMD_XOR_MEM_BIST_STAT	= 0x164, /* XOR Memory BIST Status */
 	CMD_DMA_MEM_BIST_CTL	= 0x168, /* DMA Memory BIST Control */
 	CMD_DMA_MEM_BIST_STAT	= 0x16c, /* DMA Memory BIST Status */
 	CMD_PORT_MEM_BIST_CTL	= 0x170, /* Port Memory BIST Control */
-- 
2.34.1

