Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48E613B2B2;
	Tue, 13 Aug 2024 08:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723538642; cv=none; b=bPXerhfnoflNmCAlu29M1X0Q6VL0Lg6LY+sJ1J9OimhuHib6rkbMx/GAOTkhJ6OGf83KDNReoxaNZ864FLnQ4yM4uHrI4CmtV4jaTxfjNewA7b3epyuk+6Fofg1rqafcW2lbS6YOmLXBWR4ORAuumQ/dGMOsI1M8ziDhmYyEYUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723538642; c=relaxed/simple;
	bh=/gM131dPh0P0yoxt1nxBVMIws7k0WEoZtkn1AChzN4w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bNskXivOMiUPTDHrLJarL0vxJOwDwviqVcucLkJQzlvSNH9wrADPx3gMhgtsvYVC8UDSAWCUBmTHD/lS0t3eUXsNmyO/2NdZwK6ooCJpTUjItU9JTXgsk4Do7vi8DiX5pF6ofvh5Ehd5h2O7knety5Rk2Cs1ZJWRpn8g09SIFgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a7aa212c1c9so626855766b.2;
        Tue, 13 Aug 2024 01:44:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723538639; x=1724143439;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cC2PyexXPDW7ka4IjjgZPFfLFHP6Q3fx9e5k3osnd28=;
        b=JKlmFQOgdr9C/GfH7zMVbfSqrha7fFre2+q4tZNhrhZz4Ob0VQDRGtMb+b6EsOMmQV
         Go+hcVvQK4bhKCZMsFtwc0zjX5+JBFGTcgwvF7JCVthF3TvoFxTL7IM369+041fsL1co
         cfB07ig9nPlBbMWs3ym3n1NQs+//ZpOaAo2Vd+5XhTi+/wzG0M2I2zzbfiW2zKCf9b5u
         G8SxXbebPHBlMrBN8Rqzv+zkLiB+e5kDKcpNAkDn9dnJU08awwFKizGA+77SDWaC0cnQ
         FqNff4Jv7LxTjTg+cc0j7bV+0b5MqLiPd726zg7ouQVK6IGQtidrbEXP4QoQ97DFQI4D
         1JTw==
X-Forwarded-Encrypted: i=1; AJvYcCUikNLrsrzXaUOf4zNmGcx5UzlMnUI+NnsCUzudtIB9Wj/pdQ59++6MG++w5kRDk+eJVcQGthCyv2OFjRreayzy3BGGbpWwGbaoiap1KPBk1MQwAHHm2ox2EmG2jSqDKXtahTiI7Gz3eg==
X-Gm-Message-State: AOJu0YwEsuhwAAEMtYZnxgSkM5lxCca4oRAoBDK50pSRDosCKmMCFZaf
	mKQqdLfQSzs3IrSjZCd/i56R44PYgJdjK1XZpCPtAY+haLF2BAOQ
X-Google-Smtp-Source: AGHT+IEFs7hEdNwjzfIuQqncHDIY/VqfkUAcvB/QBGM5T81EBacvh3Or/nXIm55fnBLMjr+w3r4t4A==
X-Received: by 2002:a17:907:efcb:b0:a71:ddb8:9394 with SMTP id a640c23a62f3a-a80ed260133mr195793366b.40.1723538638929;
        Tue, 13 Aug 2024 01:43:58 -0700 (PDT)
Received: from localhost (fwdproxy-lla-003.fbsv.net. [2a03:2880:30ff:3::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a80f411aef3sm50716366b.106.2024.08.13.01.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2024 01:43:58 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: martin.petersen@oracle.com,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: leit@meta.com,
	MPT-FusionLinux.pdl@broadcom.com (open list:LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)),
	linux-scsi@vger.kernel.org (open list:LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] scsi: message: fusion: Make compilation warning free
Date: Tue, 13 Aug 2024 01:43:24 -0700
Message-ID: <20240813084325.3097653-1-leitao@debian.org>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are a few of unused variable in mptsas, and the compiler complains
about it. Let's get them removed.

	drivers/message/fusion/mptsas.c:4234:6: warning: variable 'rc' set but not used [-Wunused-but-set-variable]
	 4234 |         int rc;
	drivers/message/fusion/mptsas.c:4793:17: warning: variable 'timeleft' set but not used [-Wunused-but-set-variable]
	 4793 |         unsigned long    timeleft;
	drivers/message/fusion/mptsas.c:1528:5: warning: variable 'fw_id' set but not used [-Wunused-but-set-variable]
	 1528 |         u8 fw_id;
	drivers/message/fusion/mptsas.c:4869:9: warning: variable 'termination_count' set but not used [-Wunused-but-set-variable]
	 4869 |         u32                      termination_count;
	drivers/message/fusion/mptsas.c:4870:9: warning: variable 'query_count' set but not used [-Wunused-but-set-variable]
	 4870 |         u32                      query_count;

Remove those that are unused, and mark others as __maybe_unused, if they
are used depending on the logging option.

Since scsi_device_reprobe() must have its value checked and it isn't,
add a WARN_ON() to let user know if something goes unexpected.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changelog:

v2:
  * Add a warning if scsi_device_reprobe() fails.
  * Mark query_count and termination_count as __maybe_unused.

v1:
  * https://lore.kernel.org/all/20240807094000.398857-1-leitao@debian.org/

 drivers/message/fusion/mptsas.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index a0bcb0864ecd..00a738ef601c 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1447,7 +1447,7 @@ mptsas_add_end_device(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info)
 	struct sas_port *port;
 	struct sas_identify identify;
 	char *ds = NULL;
-	u8 fw_id;
+	u8 fw_id __maybe_unused;
 
 	if (!phy_info) {
 		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
@@ -1525,7 +1525,7 @@ mptsas_del_end_device(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info)
 	struct mptsas_phyinfo *phy_info_parent;
 	int i;
 	char *ds = NULL;
-	u8 fw_id;
+	u8 fw_id __maybe_unused;
 	u64 sas_address;
 
 	if (!phy_info)
@@ -4231,10 +4231,8 @@ mptsas_find_phyinfo_by_phys_disk_num(MPT_ADAPTER *ioc, u8 phys_disk_num,
 static void
 mptsas_reprobe_lun(struct scsi_device *sdev, void *data)
 {
-	int rc;
-
 	sdev->no_uld_attach = data ? 1 : 0;
-	rc = scsi_device_reprobe(sdev);
+	WARN_ON(scsi_device_reprobe(sdev));
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
@@ -4870,8 +4866,8 @@ mptsas_broadcast_primitive_work(struct fw_event_work *fw_event)
 	int			task_context;
 	u8			channel, id;
 	int			 lun;
-	u32			 termination_count;
-	u32			 query_count;
+	u32			 termination_count __maybe_unused;
+	u32			 query_count __maybe_unused;
 
 	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 	    "%s - enter\n", ioc->name, __func__));
-- 
2.43.5

