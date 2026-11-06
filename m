Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926768;
	b=dxvgAmcu9Z+Vb4IG0r+JJJA6eL1GQcj5m0U+F2+mi2DRwYaVmJ3hjotf2QJDcXDkQIZc
	 tosUPkF5+wwXFzfusECXrUL/NLomxZhEnQAHc52uPzjjDiRbmtXloupGK0VRmEbjLrcwP
	 8/J3kh/nx8NM47vw8+DM4tpP7deSd21j8es96Y6Uhi06VFuLb0hjqmaJiCFHlzp6VGSw6
	 SqWWHOXN5PI176sp04ilwTkCidcZ6K/1xx7Bbt72ut3tokolZdzmNT5ukGEQHzFWwRw4Z
	 1/0xQkP38BBAYWHsm+emz9q7DrVkr1Gwd326bcRsexXADusGGTLnf+h+ZZbAHhNWzDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926768;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=LZ8/YWkLZpgEKmipy7A7GXC+udgfSLhy1XoF8ylZkKE=;
	b=G62FWUqmTu8LNiKwynHYAaF1YnTNbdLJzS+tCEHzRzTTF9fIpvSdE+RM/07YoT5iyvdm
	 fW9LQd44gOETZxOuvVliNuJpaqgPeLq4q48rpUUvxYs0nFmDqxA397ubdu9MEYIa2pdX5
	 nbgRj65IQvn86Q+0oO0U6wjcsezGbrqs1oslQJQg8Cdj2W6FAMelIfNpM21gRTnjx7OLa
	 21rIkDPDbguqGB9NYNZARnUVG3Kd6rYdqF9FvXSkR09onyaZ+yPPVg8jV4/9eAl3ZpfCW
	 ZyNpb/s2toNaWF+EFcnORsSfXf4/06VU22GsdJvQkUl2W51J5AJk85wU7vu0tZgd16w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=EUkZMWze;
	arc=none smtp.remote-ip=209.85.215.226
Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FD7606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:59:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3FD7606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=EUkZMWze
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-cc4aa18f9afso33994a12.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926767; x=1794531567;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LZ8/YWkLZpgEKmipy7A7GXC+udgfSLhy1XoF8ylZkKE=;
        b=uCNBVjlj+8vATxk3ZzMGl1f0fMvi6rC5L0PjF9CY18OmtVErcS2BPvHXAx4IMyLsri
         cPzkqmxoNNNfdXS74VLttFzuHEkvFmCgiz2IdJXmU9PuB0rJDDjZ8Y8vyU3kASG4/taJ
         kmXGgti429QwnUvMuJOY91ya8RIKiRNxSzGdqdPKJrXT6gKtDleM1M7xiRiNQo8ricx6
         0opedQQCJ3NQEhHd/9i7yjJoxiUCKueUgWj7ae3ODV9vLHb64A+3z4/40loUn9P1JkCf
         LJn5M8B8Cn4/38vVYK+gKmrTK7QJ94dE23qs1etLAOP+I50xJr+dBjbkQ8GzpYZxCCee
         rCdQ==
X-Gm-Message-State: APuU4Z+Zfik7tS4Ui8zbXkQdm+BNLWQgnRpBqv52UY1WgQHLhkXYaPGN
	DLrfCQYpwKAUkpuAvTzlgMKha1xPviG+NsBr6P62LGW/RHP+mqJ1ZYFLqeYNBwu4tEZH9eMbUmc
	WB42Wd6IydP4fSErv+0miflVWN/R1q/hwLtf0xwuOby64Ixw3pdPLhKev1RS9lPPV+pCwHFDZfT
	Y2oqigmIXQgFIvGQyXLhCfu02h5py1txj2PPG27oI/7kWqPu+5+QH3JJ6OTEk2mnH5siFf3j1YX
	1bozPjOrnwP2rF8DKVzA+PbL7wwJL55M6w=
X-Gm-Gg: AYBFou0SlQqljCLr7ztVs66p2YVwxZtMAqR24bhHagKy7x54dSlOaOC1SXf+x4/o0hl
	N9BO5YMUP50/GgEhrUn7yETJBFn6pn27PN50XqhpTQLC5Sfw9isQQyjkGf7/4zeQ9ENhJVSoTa9
	+S0S7ZrNYH5ljdv8jz4tHXyVZiOV8PnUL2n2drstRXBcK5jUveuBMm3dLHYirBMlPyPelx3MqHE
	rEne7xRIpzdqo24AZ50oJIXAFKoTHSIObQuGNOjP1eAWF56z+CNt9hVt+IjHI+bwA5MzKrXT0VB
	m5ZvftwGcVOB8dVeFkOTOgpHUhjfgsFkHCZCBjSW338RINdvzilYJPUpg17Ao/tyEd77uLszGPs
	LhHHx6tNftQzj5BBmWGPGsKD5WzerDiUNsNGW6jfhdTE5JTFDjgxkfu7Ii8mAOae6KgiFPCU9Cn
	ey2QbfdXvRTRJKReOqxh2/6jsq+91cQSZ0VWdLDEKqR+jNtn8PPJryTQ==
X-Received: by 2002:a17:90a:dfcf:b0:3a0:a912:e759 with SMTP id 98e67ed59e1d1-3b0db6ee689mr660836a91.25.1793926767084;
        Thu, 05 Nov 2026 16:59:27 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b094554e25sm1958440a91.0.2026.11.05.16.59.26
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:27 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ea0fe07201so905225ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926765; x=1794531565; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=LZ8/YWkLZpgEKmipy7A7GXC+udgfSLhy1XoF8ylZkKE=;
        b=EUkZMWzec67AeyxrinnzGPrC7FUSUDar3XDpaDRohvfZTPC6vygL/p0BQbAgQ53Y2U
         jjjO2uUo1e2V00V6FEgH1BkYBdRb4P0i+ulZtmhwMycV3KHT2plMDploC2AD7Qk8otmj
         DiCFeS8rbI73E8qQ56ezvy2sGO6GcNr60L1rA=
X-Received: by 2002:a17:902:d503:b0:2eb:1bba:abbd with SMTP id d9443c01a7336-2ed40e83617mr14794235ad.60.1793926765154;
        Thu, 05 Nov 2026 16:59:25 -0800 (PST)
X-Received: by 2002:a17:902:d503:b0:2eb:1bba:abbd with SMTP id d9443c01a7336-2ed40e83617mr14793955ad.60.1793926764409;
        Thu, 05 Nov 2026 16:59:24 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.59.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:23 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 24/37] scsi: mpt3sas: Require CAP_SYS_RAWIO for mpt2ctl/mpt3ctl ioctls
Date: Thu,  5 Nov 2026 16:42:39 -0800
Message-Id: <1793925772-1303-25-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-Mailer: git-send-email 2.4.3
In-Reply-To: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Gate the ioctl entry point on CAP_SYS_RAWIO rather than relying only
on device node permissions.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 6df51aa7bcaa..60815302daf7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -56,6 +56,7 @@
 
 #include <linux/io.h>
 #include <linux/uaccess.h>
+#include <linux/capability.h>
 
 #include "mpt3sas_base.h"
 #include "mpt3sas_ctl.h"
@@ -2734,6 +2735,9 @@ _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg,
 	enum block_state state;
 	long ret = -ENOIOCTLCMD;
 
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
 	/* get IOCTL header */
 	if (copy_from_user(&ioctl_header, (char __user *)arg,
 	    sizeof(struct mpt3_ioctl_header))) {
-- 
2.53.0

