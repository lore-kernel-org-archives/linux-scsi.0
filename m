Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926741;
	b=wxLVObQ3bE0BejgJENXTdM5YJqUiagElN3O0nXIcWbGME/Sf3EeyqOTwA2dXynNVMOwn
	 eiRRmu7Am2jBreRU9Pv0q5IOzHKXXdvW/gOGzbBd8TA4yUF81sQv1arMKMlZEQ7o2/wLJ
	 8TWGA/eCRaLQm9me1WYSlJZrpeDWoUWF+7+9mLTwcAV+NWUAjh6OeiKwJuD2V9+dReF2F
	 rDchpRaXnlDBqTxbZyk5Dyx7AKN6chgod9fCjQ6Mdpc4pI+66+90KfJ61WP3rdQPDxDMp
	 YlVlB9wSZ7llLs2q7tS31MmvbMthIoMTM7fU+3qg+ydSUpQugJVIFJDVVISeSXjtjtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926741;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=ZgmW0G52hmK+RHwDPoT96E1M6NPrKfganMATU5hv2qU=;
	b=ljFrFzkYUMb7bbqnXWnO969XDVHgkjx7bUs00x5FwU33Ru3l0ity4l6aYdZWQFH6AbUV
	 dviXS0wN23F+kSgTcr2cIsdarpt6/AcBwyixsnv32b6uvooY0lnJz6u4cvaHPkNbuiGD9
	 Oqgs9qdGXGxIrUtY6UUGctB3vvONpR8zMO9lwmCAEYeuf17Rhusv/8E8AFR+KEjfen6FC
	 +VE07OnBoF9EoY/LTlyvqFj94V7Z71jUA1fL2RarwNAD3qu+lGjtZQ8PEW160gR6eX/St
	 9PE9B8o9ftXOWKjU5Hx+RXpM+I7ryHedrhzVumQLW12G9QOqv0OLPqjKFvEFM7JvSOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="dGp72In/";
	arc=none smtp.remote-ip=209.85.216.99
Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCC6606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:59:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1DCC6606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=dGp72In/
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-3ae1da332bcso44932a91.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926740; x=1794531540;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZgmW0G52hmK+RHwDPoT96E1M6NPrKfganMATU5hv2qU=;
        b=xDnxfFJLWX/wqUj6cCgnoljJ2PrQiwi57MS3aRE0BU/eNiDpCul9OhZsGJvpv3io7R
         C4TVg/zVXrtR46xaF5RuOzrIpSWKOBjRdFtdnjbvfrMNVw/45mJFhOH5ghpocDhHbgs/
         Kz+gYXsBGcHYGOw0FTsMah1xCbwYeMuYpjrgiQIgpfBhcyaxXVxkHMqDbW6OWQoj+l0t
         dXBCdDNvNBoghs9/HVbSWM80moURVRWTtqxljbcGoQKwqsGD8sBqBe4axNSdXXwj5t88
         ceCTY5PcSGRII46MT9os32ugsvVQVINvc966HWE6/f1KskUXZVxS5s0h0RJB1uI1R3zC
         Mb+Q==
X-Gm-Message-State: APuU4Z9TnKKTr/4ihdC9V+GSIjeiYw49pEIED6ILoUDlD1scZXOsLpaU
	+u6VYUKBnDvP0JSO9byrMjiMbkppNlDqPB/mjPysMdeL5Q37BRNvQBL8DKI72bVkWQUXtmXHKAN
	K7Rkq0V0euDnt4yvT8F1ij1d/qRkuNd1HguN03OmZpU0AlIst2EDUmTebXidk1DtQH+lMXwySDM
	B2yTLqB2GPK5HrRPk0ubMzu/rcMggd+cR+1BGKUB1p8pdtRfW3Amz/1jf0wJFdGGivTO/I9fW+y
	rTRyGkjmaBVkiCU0R3cTfmxNklaa+4xBNQ=
X-Gm-Gg: AYBFou3CiZbLI5TO9832r95If4zFf/LLlZ8WRyl7cNeHIQFWMOSoVvVbum33uc5ONVt
	IQGNBeHwgyEOprSnHyQtuyrtHmEeGiM5HbeiiD0tQZPMWQNOPX9bD4Je+ihbw3pKKvUSnEIBpfz
	eO/sYmGHMwXvVpokXXfy1eXuickeGgK0dOjONQ2Kd4IyV5eUZxnXO24gn547uFhK6qYqqLge5zl
	KSTX61+dvwszlDqmCD4IHxu/H/9XXoL2CohgW44yREauMVq/GPCQvlmDKTrtTdLkUIUbcd/Uvus
	bwZMr6KQXAprxquJAtJt7tkUufShFqzSz+b+3s3j4CLTrxWxHtn9kJgMdaMe2OX2q80PqfEx1L4
	GqJ/ymzSvceSU5F+1Hrvqkx1rUrGpwLYBjTLwueIqKRgB+bQRb8dTBZnmsI/AY10NJ0XKzRhvqM
	ZrGpht/AVTxPTxTD0win1Dx2MnQjTkbS+XhYk/jo3sHHkOIAKcY1ZdEA==
X-Received: by 2002:a17:90a:d88f:b0:3ad:1b0b:1246 with SMTP id 98e67ed59e1d1-3b0db6e9d7cmr781235a91.32.1793926740425;
        Thu, 05 Nov 2026 16:59:00 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b0d7c9e3a8sm744109a91.1.2026.11.05.16.58.59
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:00 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ed2803f863so1259245ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926739; x=1794531539; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ZgmW0G52hmK+RHwDPoT96E1M6NPrKfganMATU5hv2qU=;
        b=dGp72In/MlgaeOBCXTQk+gJkqERDoFxoovXBrI3neCmOKKDbrb6sXiSprXm1EE82lq
         gwzLwgDy2W7lgbluchPIylPyekQgbz2IE3kNq5j1iU/jSin8ZIDH9goWYiGH2mjqSjIJ
         NR6vf6UprFnLA9bRl11ulDzkL51rZIAYv1xX4=
X-Received: by 2002:a17:903:3d10:b0:2ed:3f47:9691 with SMTP id d9443c01a7336-2ed40c7537dmr15185595ad.42.1793926738843;
        Thu, 05 Nov 2026 16:58:58 -0800 (PST)
X-Received: by 2002:a17:903:3d10:b0:2ed:3f47:9691 with SMTP id d9443c01a7336-2ed40c7537dmr15185335ad.42.1793926738342;
        Thu, 05 Nov 2026 16:58:58 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.58.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:57 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 16/37] scsi: mpt3sas: Fix page fault from stale ioc->chip after PCI error recovery
Date: Thu,  5 Nov 2026 16:42:31 -0800
Message-Id: <1793925772-1303-17-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

NULL ioc->chip after unmapping it and guard mask/unmask_interrupts()
against a NULL chip pointer.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 060482ba20ae..f0ed1bea64bb 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1645,6 +1645,8 @@ mpt3sas_base_mask_interrupts(struct MPT3SAS_ADAPTER *ioc)
 	u32 him_register;
 
 	ioc->mask_interrupts = 1;
+	if (!ioc->chip)
+		return;
 	him_register = ioc->base_readl(&ioc->chip->HostInterruptMask);
 	him_register |= MPI2_HIM_DIM + MPI2_HIM_RIM + MPI2_HIM_RESET_IRQ_MASK;
 	writel(him_register, &ioc->chip->HostInterruptMask);
@@ -1662,6 +1664,8 @@ mpt3sas_base_unmask_interrupts(struct MPT3SAS_ADAPTER *ioc)
 {
 	u32 him_register;
 
+	if (!ioc->chip)
+		return;
 	him_register = ioc->base_readl(&ioc->chip->HostInterruptMask);
 	him_register &= ~MPI2_HIM_RIM;
 	writel(him_register, &ioc->chip->HostInterruptMask);
@@ -3579,6 +3583,7 @@ mpt3sas_base_unmap_resources(struct MPT3SAS_ADAPTER *ioc)
 
 	if (ioc->chip_phys) {
 		iounmap(ioc->chip);
+		ioc->chip = NULL;
 		ioc->chip_phys = 0;
 	}
 
@@ -3682,9 +3687,11 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
 		} else if (pci_resource_flags(pdev, i) & IORESOURCE_MEM) {
 			if (memap_sz)
 				continue;
+			memap_sz = pci_resource_len(pdev, i);
+			if (!memap_sz)
+				continue;
 			ioc->chip_phys = pci_resource_start(pdev, i);
 			chip_phys = ioc->chip_phys;
-			memap_sz = pci_resource_len(pdev, i);
 			ioc->chip = ioremap(ioc->chip_phys, memap_sz);
 		}
 	}
-- 
2.53.0

