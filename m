Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996756;
	b=ApSQ2XgEuh1lksLv+uTWp34kM4APZfhhkmX0auJIvP7d9d8PEMqU31K+83HgbVXZ7O1C
	 1SiSi4lqKTcV2s+gruzg5WC74PbvMDujCJ92OJkRzVEEbq/C6AuIYuVOSCwzOGEPV03Tl
	 Ly52Hw8EOG/tKE6OpcSVHKc9nQaOx3D9vvnjh2UsrZyhYG9qs9yeYbV0GRZOh3K+90/3m
	 77dS5Zhbwv21eyP+jRgo+qvwwx2rrahf7GPUs+1JUoHzuSPz+lnafH5XPiTdw11OdZZ86
	 a2K2Lmmko55dr6K3G1VEbrN4RfMSJDKMcGWoLjjpAXWXxyPNKJZKEtYglkxjFo3kwQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996756;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=kurkkV1xOuV06AkYU9PJ9CYHgvn/I2cYpZUO1Gxnf/Y=;
	b=Zdxx4HVjpCD0qRii1rnoaGi6OBcaXbS6GTZ1RC5PyG/WFmOWGWrweEtEs2quI6CO4uiL
	 QhgQ8ndQIycacrf9zNGJGe+58Skl49Ms+OIEUasbNhOFZb+AF9r+93T6sIZZDMGmrUu3a
	 JIAUEp3xrJZm8vTD355DGGEexDBU1NyB9qab7VHjVqfzB1CrR+K0rYYGzvQHumcolodN8
	 tV5rRqWRhRXE9Xyfkp/n0BeNyGjfgvfWpSMv7aCDEkFnZ0cOSW4z6ScZiL7aEPVq5cxvO
	 M4MhoIo0t0gdj2wyZ1BXaDn5czqOLvcfw9GImlj8LrCfdvUt1XEYq4LQi773bPPCkMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=MsZwrqck;
	arc=none smtp.remote-ip=209.85.215.227
Received: from mail-pg1-f227.google.com (mail-pg1-f227.google.com [209.85.215.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7B3606A325
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:12:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F7B3606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=MsZwrqck
Received: by mail-pg1-f227.google.com with SMTP id 41be03b00d2f7-cdb75699c7cso405517a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996755; x=1795601555;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kurkkV1xOuV06AkYU9PJ9CYHgvn/I2cYpZUO1Gxnf/Y=;
        b=ZagUtcPGW/noxHUiqwOM7v8Ek7iqrJXEhPlc62hUvXor+Q3QONDLuRKMwxWyTIauiL
         SKx1VZ4f2LS7xvc+6x1fdcPgjubnCTe8X0rA6yK2I2KSLxEdhOCfIh/0BvyG/qla8nxh
         oppIDr6B6rEZhN+3hN/3gar+WAnWtUtYX9C1ze6jW0Ibn9yQAJmMZ8yu/iEuwl/G8oMu
         KODy0whcUz9CKBmO+KKlglv/jUz1xp+6Ki/N5ltAb5x+fdjixFeSa7IrG8F4uMNIHU78
         wiJYMrLpfo5HHfpXWcWG+VOV3S/uyFzBbfnHGpHEsb5cg/eLrv1ewmO7170CKXX6w2FE
         vtsw==
X-Gm-Message-State: APuU4Z/mNDnf5IaqmU1p7Ky2n46D+phFZzt4MJav6KaVaxraZvsMHe+n
	GCtb46fXftpfecFWkUKagjeUfWMFAQSZ4PoaS6Bm6qsWgwcMRLtsbkvzTVh5ruACFeKFKFnKIpc
	P/xstrZyuIl2VILcTYTOM/+CL13kOAQpqZFouLp/g8cp2oUrPOldQDwxhoRAyp9nCi36pi6BGK8
	nBSGAmwwymnSqFD0HIkxNh328VppcQMdFdwRoUqVhR9yOUQzqOxZVycZKL6Eb05t3o8jdqqPotk
	CbAp6YbNNWyr7RzhwR1qGqssYY5Kifxk5Q=
X-Gm-Gg: AZFdTZd1pMBBquQ6u/oRujnK1vwllVJ6VNZL4VPUQr9uLofYrOnMv0dMbbeL9Wl5KKc
	7IHeW6o1Q1eK2TMPGjvyUReHGZ3Gu70rnpDccODkQkLW65jlE6o5phFPt/x13UW+NMB5S8D5fVq
	S6TFvm29QNaBcOUmw9KUUt2+sDeM+qeAIdl4VpMyMnnZPkRkLMO26E44V5haNkVj8Rz8sv1ZqSX
	gPxC4kbbL/pWHjhQg5HVCrXkKVBbpcjBGsdH2leTI3XLewxaivGzsVDzrHYxBD2iSImsC5NBsQh
	pbM3hJE6ZCECQXGtmDOaqtIHxZTNvrgXXpKFB8G8TmPV6AfXPcrDLH16QPneGTe+MyDqUMF9Roh
	q/g5wnoqCUuSqDQUaRLHnCc8fmSI1cD4lv2XylzVLnim++tA08vQWdaTvAJGimPAnrfSuOBXC8L
	+3dlCcEvA4Pl0kkEqZTSTHN49QrqE1epY7sEkcmqWJ5y8EfmU9oJCHNNnX
X-Received: by 2002:a17:90b:1fc7:b0:39e:4c80:f67b with SMTP id 98e67ed59e1d1-3b3d0764959mr2145892a91.26.1794996754896;
        Wed, 18 Nov 2026 02:12:34 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3d1423c73sm1649687a91.3.2026.11.18.02.12.34
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:34 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3b1755b2f26so803230a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996753; x=1795601553; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=kurkkV1xOuV06AkYU9PJ9CYHgvn/I2cYpZUO1Gxnf/Y=;
        b=MsZwrqckIW//cqJH+n4mdVOTNgkoqWlOzlasm5OBKyHQ+FkqNCVOSLkbGX3t1cro7y
         5evf2ims+bHrseGvdPN9UQDtj4MSKBpiVlTzeUWe6od1d7PF7MdZgexTFNq1Nppdemk5
         Bx3ncAuL5qpEf2GKDXihogm3mIRr5k1o7UPcY=
X-Received: by 2002:a17:90b:4b0d:b0:3ac:7449:40b4 with SMTP id 98e67ed59e1d1-3b3d07aa6f7mr2104776a91.45.1794996753189;
        Wed, 18 Nov 2026 02:12:33 -0800 (PST)
X-Received: by 2002:a17:90b:4b0d:b0:3ac:7449:40b4 with SMTP id 98e67ed59e1d1-3b3d07aa6f7mr2104753a91.45.1794996752686;
        Wed, 18 Nov 2026 02:12:32 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.12.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:32 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	thenzl@redhat.com,
	mgandhi@redhat.com,
	loberman@redhat.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 10/37] scsi: mpt3sas: NULL ioc->reply_post after freeing it
Date: Wed, 18 Nov 2026 01:56:19 -0800
Message-Id: <1794995806-5835-11-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-Mailer: git-send-email 2.4.3
In-Reply-To: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Match the pattern used for other pool pointers in
_base_release_memory_pools() so a repeat call can't reuse it.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index aea300f55051..5a51844608aa 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5869,6 +5869,7 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		}
 		dma_pool_destroy(ioc->reply_post_free_array_dma_pool);
 		kfree(ioc->reply_post);
+		ioc->reply_post = NULL;
 	}
 
 	if (ioc->pcie_sgl_dma_pool) {
-- 
2.53.0

