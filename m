Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CED1CB32D;
	Wed,  7 Aug 2024 09:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723023617; cv=none; b=DbTi7IiLvFsmaRn39Ty5X2H6Qccp0hfWGR1G+lGcH072gV7vmPz72XkE1PicY0BLW3MneXxsAstDbIAo3jIOZx+g3x5H+8YDlO3pu+BwZK4Pl/hftNE+v/VxrxpJ0RYlPGT2KhOhtES55ogVxzuE+lF+7iKzYexZXeHKtootyJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723023617; c=relaxed/simple;
	bh=tsLd12Q21S0XxO69H0s5LApGcYUZEie2HvPNE2IhMuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T4byC2Q4orhxPH7ILSzCxgYh6pgWWKd+PuyFTNMzVi+Es1L+HaJQ05H3X7cOAzTkrDP3lI77uXt6xnLlcavBb2TEd8fgBTRR9iLJd8JpK0fC4nkGBk4zOwZ0U4v/MTf2d001ZgQKU4tIA4TpMo00+oTLQmwpEeMEp3ik/I+Wvds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5ba43b433beso1804962a12.1;
        Wed, 07 Aug 2024 02:40:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723023614; x=1723628414;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XIJe01rMNUiVH87w2wFawTwUkJYekoCY1EChG0NNQhM=;
        b=UshJQSp6Cxt05nHiu5RHH/H72iSiVf/VcpTFb5XpKgfSX7JK9tU5V7hKTFlczGyf2p
         EDket7INpvhKKS3prg3iWFtMu0J/aKghd+UOjJZsWquJe8mBwSTCNnBLijpsNS5uY8p+
         Z+9qEZqms1VBARfUDlsisGM4YSPhAG0TZF3EC4hM26XfSXuwjDW1WGP6SbC+IaiwSmOd
         Pb1FGwnoly6qU7HqV3U0TIvKC1uw7+XMt7AdrCOCqAJKGYT3wKx71/uSgu7gHQF//TP2
         6jlA6CJmvG27AvQwymjgisuk+oAyhNpdcJAKU51PIB+EYYIz4HGGT9MHp7qKJosDokdn
         4ybQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFOQrQLRcCpE7z6XuTn72k8lWepgwqvBvhpLwdxkt6Nq99OmyExF1spJ/PJhmg7vo/u3GKE5geqn1IMbgxTq/aSMmCbEFm4u+Ry6ctdV/Nta9DhvMN3EnS5lBc1H7VykbjCZ0cHvArIw==
X-Gm-Message-State: AOJu0YwuFcHlvb38f04O9+EjzeBtxLr6OrUSXt9YrY4a9ATEHUqGkVTy
	xGXH0bAiY7QAkRpoIPiWkH+3RgdVRxzbMaJfYlQcv8TdBhYzQ4nL
X-Google-Smtp-Source: AGHT+IFGFXyzPJyU+3ZO6aR/vJvOsoR7CD4nWairtbEuBiPfLL88RNN6LQscDwHMcXSf7Gb4A8ObyA==
X-Received: by 2002:a17:907:724b:b0:a7a:c083:8575 with SMTP id a640c23a62f3a-a7dc4ae31afmr1377036266b.0.1723023613413;
        Wed, 07 Aug 2024 02:40:13 -0700 (PDT)
Received: from localhost (fwdproxy-lla-004.fbsv.net. [2a03:2880:30ff:4::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9c0cb9esm622404366b.78.2024.08.07.02.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 02:40:13 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: martin.petersen@oracle.com,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: leit@meta.com,
	MPT-FusionLinux.pdl@broadcom.com (open list:LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)),
	linux-scsi@vger.kernel.org (open list:LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] scsi: message: fusion: Remove unused variable
Date: Wed,  7 Aug 2024 02:39:59 -0700
Message-ID: <20240807094000.398857-1-leitao@debian.org>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are two unused variable in mptsas, and the compiler complains
about it. Let's get them removed.

	drivers/message/fusion/mptsas.c:4234:6: warning: variable 'rc' set but not used [-Wunused-but-set-variable]
	 4234 |         int rc;
	drivers/message/fusion/mptsas.c:4793:17: warning: variable 'timeleft' set but not used [-Wunused-but-set-variable]
	 4793 |         unsigned long    timeleft;

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/message/fusion/mptsas.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index a0bcb0864ecd..cd920faff16a 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -4231,10 +4231,8 @@ mptsas_find_phyinfo_by_phys_disk_num(MPT_ADAPTER *ioc, u8 phys_disk_num,
 static void
 mptsas_reprobe_lun(struct scsi_device *sdev, void *data)
 {
-	int rc;
-
 	sdev->no_uld_attach = data ? 1 : 0;
-	rc = scsi_device_reprobe(sdev);
+	scsi_device_reprobe(sdev);
 }
 
 static void
@@ -4790,7 +4788,6 @@ mptsas_issue_tm(MPT_ADAPTER *ioc, u8 type, u8 channel, u8 id, u64 lun,
 	MPT_FRAME_HDR	*mf;
 	SCSITaskMgmt_t	*pScsiTm;
 	int		 retval;
-	unsigned long	 timeleft;
 
 	*issue_reset = 0;
 	mf = mpt_get_msg_frame(mptsasDeviceResetCtx, ioc);
@@ -4826,8 +4823,7 @@ mptsas_issue_tm(MPT_ADAPTER *ioc, u8 type, u8 channel, u8 id, u64 lun,
 	mpt_put_msg_frame_hi_pri(mptsasDeviceResetCtx, ioc, mf);
 
 	/* Now wait for the command to complete */
-	timeleft = wait_for_completion_timeout(&ioc->taskmgmt_cmds.done,
-	    timeout*HZ);
+	wait_for_completion_timeout(&ioc->taskmgmt_cmds.done, timeout * HZ);
 	if (!(ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
 		retval = -1; /* return failure */
 		dtmprintk(ioc, printk(MYIOC_s_ERR_FMT
-- 
2.43.5

