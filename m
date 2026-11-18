Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996775;
	b=GD3B9G/XIwjGm78MbiflK3mhLbedpJj9tziT0u2I3dBkA/bI+5AThusIPl0JwXOFhoLf
	 5B/+c8s30Ong3rpbYsUrtsiT1IUdJQa2WegeOQ7/2iUu4xAhzGpZ8WetTgeapcCtUb/f/
	 vdjdquhTODIuN3s3hcntkMhXpAHZnKodUdsHTsUiQfhvl7vsq398qkkZnanieTloCkIyK
	 YR1KhH3oxHjLFCu9fPP3IRx/2kLoAGgKcSEOICXK1SQTZHsEMZNaIRKSVFyLj+ub0M84/
	 84zkNMz9eZpSrIxfOsgLwfxSdtUPp3wbx/aLkycGUDxjfpQpHig+/S9eLvyeQAz1WRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996775;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=jGaFvVkfvvhGtdvF5mb9Kb0qLbCMqH/SpOxnCUsr1rs=;
	b=nFtQcwqcxJPyZ7beWgNnWPHKTZZ0DGa9DLuPZTpWKQXx/nz3G2MYYQruK7vOTEQBh7zq
	 AKKod/8fHmoQ+FOdO1fTmhr9tyDgRrksoydgOsBRFyT3/itp0+WjUbRrz+qJbm7lfipAL
	 Cfsj7/mB4xF93mKwHlEtPlriM7AUB/0QgtMQ1nZ3/pOmqKyovI+1lOVbeRrNk/BehRCdH
	 HMMRNoRDGulyA7cKRGCrPeQe+kd3exyB3crfv3Sn50X1Q1S4vPYkb9J8T9cPf0P7pQT2z
	 KHbYAjSpKzXsSmJMUEPWwBMacf0L1rO4DHU5liubigl/cD46pk28FgJvg4dyed1xkdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=YBrHcUZI;
	arc=none smtp.remote-ip=209.85.215.228
Received: from mail-pg1-f228.google.com (mail-pg1-f228.google.com [209.85.215.228])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D99C606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:12:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D99C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=YBrHcUZI
Received: by mail-pg1-f228.google.com with SMTP id 41be03b00d2f7-cdba1b5ed8dso406353a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996775; x=1795601575;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jGaFvVkfvvhGtdvF5mb9Kb0qLbCMqH/SpOxnCUsr1rs=;
        b=mFZeNbdjSFhK7zOl0/tL9uqFKHhdP4tOY9Bk6FC1GS37hmNKAGfzpizMWa7cxc5lz5
         bd/TL4YHC0fGaPmtxDJQeLYlGqYO1RxE+osIOEbPTvwssbcDknd0qC0Kj3C5qfw6/uo9
         7+J3jlZ18IWdK2BH0rNdGK9vTg1Vdnf72e4lPYgsnD4wKkm93ijKyOhJo1Ji7ef/FATD
         vg/AqeSbqkWW7j7VyHe+aoDRI6u6mBFxnSWTUpblFjVVkvuHnx+w+e5WbG6/idQHAZjc
         JI+idRyjQ7j3A9JqgcbAdEkNEkzoa50C9TxbPTmn+y3LVm4UXC1f+2kwMCjVnZPrYEhs
         ywDQ==
X-Gm-Message-State: APuU4Z/Eutl9Yj4olQbP5gV3qA3kt6ElXFQGX9sP244jhF6lfhd5S1/o
	33li1qSdWPsZkxIPRyDR2nq+RvR/LATWlEUozUVVEyWk8kardtJP4dHEo5bNacjNqdfl7l7aRhF
	UgTm1TVN0oxtgut58WLubAH3abKo0UmssIcUTyCmJaIJ4hgW2QPKP1Lb3Q1REZYKKWsb/tQ2zvk
	Hl/QsH43mrzwlKOqDvW1cTtYBddip//X0o93kbvWehFk5jhjsVAAn9/TfUbct5KMT3hS9aQHXuc
	AI9orbA4a01qql7eehd7iSwMlu+S01PJNo=
X-Gm-Gg: AZFdTZdB1FMtGXT3ftEE5vu9TLbyUO8bwhKbr/8n/zVr5ZtUyFKQsh/16Sx9X9/zvbl
	8dQRInz8Qi/ymUzA78g6ml2FSs/ScOIFeG8q1jmJT/tWXwHQ5psAWD5FOVXviJpknPbVRN97zT4
	nn6RyWvG64ISRtIyiG3ZUnuljAmr/GjsWsSJRAqZugtcssaquvWRUg/oJYfJXk1OlyocwVHKKoj
	POaCHK4pOYbl6LaXZmg2dHRTtTDodgBgxFyxPqCMKjpZZGF6KJMzsAPrLoqFporH1yaeSgbkqXJ
	dxqBvcTQk0qzm5YAP7ZJ6EzGOtz3c1a3GJPw7yh+R3czS/pMAVCr43BwDFy3LITYyoFjcUNt6ep
	WWB/+uV8J1HuTgbpGcrC9n7cEkZIJk8sXWKeER0gyDRMLC/HPk2f5srkCbse8uNV5jn7LjTKEHQ
	Ilr44euGAsfV6LRnn7rY9nqraIOb7Fzk4F3bDiGhGv1m7RVpF87xsgdQ==
X-Received: by 2002:a17:90b:4c8d:b0:3a6:d850:bf16 with SMTP id 98e67ed59e1d1-3b3d07d519emr1549402a91.23.1794996774558;
        Wed, 18 Nov 2026 02:12:54 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3abf029a5sm3964872a91.5.2026.11.18.02.12.54
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:54 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ae19907a31so845300a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996772; x=1795601572; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=jGaFvVkfvvhGtdvF5mb9Kb0qLbCMqH/SpOxnCUsr1rs=;
        b=YBrHcUZI+VVP/anSujyVxLuuaBQSYBbi/YPqhqZvKyUs3fJ1nOoJ+gMvgx//gkBjuu
         9c69vyElTHPH+AHus/NYMW13owZzlthhSwaVSmQfE4hLtjhmz6qNAetwCya7HJKlTLk1
         2cOM5nrsXpP0NB5btSmBs1RrRkeB58JAAa4nY=
X-Received: by 2002:a17:90b:4c8d:b0:3a6:d850:bf16 with SMTP id 98e67ed59e1d1-3b3d07d519emr1549342a91.23.1794996772558;
        Wed, 18 Nov 2026 02:12:52 -0800 (PST)
X-Received: by 2002:a17:90b:4c8d:b0:3a6:d850:bf16 with SMTP id 98e67ed59e1d1-3b3d07d519emr1549325a91.23.1794996771953;
        Wed, 18 Nov 2026 02:12:51 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.12.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:51 -0800 (PST)
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
Subject: [PATCH v2 15/37] scsi: mpt3sas: Fix Scsi_Host leak on invalid/tampered device probe
Date: Wed, 18 Nov 2026 01:56:24 -0800
Message-Id: <1794995806-5835-16-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Release the Scsi_Host before returning on the invalid/tampered
device-ID paths in _scsih_probe().

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 656241678899..0b219fe87a0b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -13569,6 +13569,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			    "HBA with DeviceId 0x%04x, sub VendorId 0x%04x, sub DeviceId 0x%04x is Invalid",
 			    pdev->device, pdev->subsystem_vendor,
 			    pdev->subsystem_device);
+			scsi_host_put(shost);
 			return 1;
 		case MPI26_MFGPAGE_DEVID_INVALID1_3816:
 		case MPI26_MFGPAGE_DEVID_INVALID1_3916:
@@ -13576,6 +13577,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			    "HBA with DeviceId 0x%04x, sub VendorId 0x%04x, sub DeviceId 0x%04x is Tampered",
 			    pdev->device, pdev->subsystem_vendor,
 			    pdev->subsystem_device);
+			scsi_host_put(shost);
 			return 1;
 		case MPI26_MFGPAGE_DEVID_CFG_SEC_3816:
 		case MPI26_MFGPAGE_DEVID_CFG_SEC_3916:
-- 
2.53.0

