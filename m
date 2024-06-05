Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A01190051;
	Wed,  5 Jun 2024 09:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717579075; cv=none; b=YfdOqzD594/nVRFkHC123QvNRIH1lqTAt37z8bhkfGVgWes+gism5ZGK1kEVe1l46mvUxd7xGazo3eNhdJmBqyUKDBwSNmGLv8iYVnJYo8W+2YpdhrDXMZCudlvLIYehjhUHVGGRT2p42LjmWzrA9b1V2b6A+HTfwf5H3tu4SsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717579075; c=relaxed/simple;
	bh=QU/idcVM4otdxk+iVm4L+rSCGwk9/9AmyQ9pVxLqVA0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UANh9IfGa6KYUHQGToucSY+5bjbYVxD4uvD2nHwXYeNPw3iIt9QuU+/oK8nP/mSZ+iQTJokWLxxMGgTTeP4IFc0m/2vhi74F2h9LMa6JopRiOVwevQCfvVfe0XAoGNabVm3to4c7yTZ4MD0Czwiq66hMVU5wrllPnkshvJ+yPQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PxFlksZA; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PxFlksZA"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-70260814b2dso617886b3a.1;
        Wed, 05 Jun 2024 02:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717579073; x=1718183873; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rb8TvlwBPqPDumdC3j6Umh6H2xQnXI3Qx2U5XQXVFps=;
        b=PxFlksZAOAHwhmd/a9xBq/n1VJ8pJErcMpBABopOKk/iXCmPCgUYjOAjV1lFNGHRlL
         KUe9PoCi9WNTAhf7Gn0uhnuId3HAKSbZ4P3O4L6Jt4u2PjDr0sPvugzFgpo/Ch/dXzLg
         B+sx5rgebWR/djdfs3lDTswUmQqMVdtM6JUxMmba9UnFckhY7WhGTEt/IIyRh4Ku+uQn
         8curO5h3gXTWq1B1y0Abz1HdMQa4OXRBkvRKEdq9pnB1AMuCKZIrOqdK2XcCvgj31Qog
         6r3Q2KXKF0YBbYUsbJeaGhHwHNiiuBH+tPeiOACRWL/C4uw/IbaX7axMoNX/tNB2K3mT
         Teug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717579073; x=1718183873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rb8TvlwBPqPDumdC3j6Umh6H2xQnXI3Qx2U5XQXVFps=;
        b=vDBgFt6e1bzv27lILafHibE5UV7jtKJDb+tqX6OVBAMfpWG6SJRMYfkQUh/3GkFVbo
         92nCmUgqWYk6ocK3TprEIIAhTYk2a+ImpIcCLdzLpAJdkD1Ij9EcaGY3oN6P/3hya6Dj
         y+VQOQZme5IpPlwURrM/EUOnqsNLTCQrqmv2l+M0XPchYP7tUj6MAoGg2ahpu0hLfFLC
         B2zYVPJkhvgR/e8Sk6IbzKVaOUDTuSvycZZoxKQjkm2m0b6oi8aCg/+4/hwKByK3N/ro
         o6cdi5Oj0xg6jzQN22QcDW6qJIJ3rF7dk1/dK7JSeX9yF5pPlfdjTV8GauSjqplIyeMl
         jzaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWOpHR+V7s36I+Pk1PRbRm2dFbb88xpQlvBWjYt0CwzmbMRStEnwj8JMVDW30BAph2exwHvaz/DrClTAAjY0rBuPAU7XTuyqbSXC6lcKr58QCXecMNZoCq9/jc4KokgtxLPKOVIhNaomw==
X-Gm-Message-State: AOJu0Yxu0+4BIzDo5LNwSKK942EAI7VNGIpLBTNne+smRmX0FQ0cBl6J
	jbju3jNfiq7P2qNdIwlNekTtaG5Dl8bHfGeV2XSzdG6iBe0PImcM
X-Google-Smtp-Source: AGHT+IEKs17Yc7zGzcdRhEdzekurmlGaDm9rgSC3O14gNe1ncYRplcpMtwzg/MR2bP+6nRJ8W1Hqpw==
X-Received: by 2002:a05:6a21:18e:b0:1b2:b183:69f6 with SMTP id adf61e73a8af0-1b2b6fd4d89mr3503703637.16.1717579073106;
        Wed, 05 Jun 2024 02:17:53 -0700 (PDT)
Received: from localhost (97.64.23.41.16clouds.com. [97.64.23.41])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-702423da888sm8265740b3a.60.2024.06.05.02.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 02:17:52 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Wenchao Hao <haowenchao22@gmail.com>
Subject: [PATCH v5 3/3] scsi: scsi_error: Fix device reset is not triggered
Date: Wed,  5 Jun 2024 17:17:31 +0800
Message-Id: <20240605091731.3111195-4-haowenchao22@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20240605091731.3111195-1-haowenchao22@gmail.com>
References: <20240605091731.3111195-1-haowenchao22@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

shost_for_each_device() would skip devices which is in progress of
removing, so scsi_try_bus_device_reset() for these devices would be
skipped in scsi_eh_bus_device_reset() with following order:

T1:					T2:scsi_error_handle
__scsi_remove_device
  scsi_device_set_state(sdev, SDEV_DEL)
					// would skip device with SDEV_DEL state
  					shost_for_each_device()
					  scsi_try_bus_device_reset
					flush all commands
 ...
 releasing and free scsi_device

Some drivers like smartpqi only implement eh_device_reset_handler,
if device reset is skipped, the commands which had been sent to
firmware or devices hardware are not cleared. The error handle
would flush all these commands in scsi_unjam_host().

When the commands are finished by hardware, use after free issue is
triggered.

Fix this issue by using shost_for_each_device_include_deleted()
to iterate devices in scsi_eh_bus_device_reset().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
---
 drivers/scsi/scsi_error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index a61fd8af3b1f..ab4a58f92838 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1571,7 +1571,7 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 	struct scsi_device *sdev;
 	enum scsi_disposition rtn;
 
-	shost_for_each_device(sdev, shost) {
+	shost_for_each_device_include_deleted(sdev, shost) {
 		if (scsi_host_eh_past_deadline(shost)) {
 			SCSI_LOG_ERROR_RECOVERY(3,
 				sdev_printk(KERN_INFO, sdev,
-- 
2.38.1

