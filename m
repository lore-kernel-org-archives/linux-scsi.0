Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996862;
	b=giKoVHUiE2xx64ypzWhvr/gmw04n7abTI9um08sPeTMfRTi93yKtlqeZrUbF1TSFun1w
	 GzbVmd/ALBFGmRt2UzHVrIP7ovj5eZQ2ZX3l3B5ouUXY+POelgRJm0AhCpu5QTRn7YpNw
	 r9v578YAuMaSzru12QzAop0rU45T+PRm+nRQlU1SNWL0+hiY+asT6wl9t469NmByS42oV
	 A0czJeTvl14AQ6waxq+ghQ1NbuEPDU1jiodr9pIa/Ylxmt10voubYJpIeisAY6oIhbGPx
	 5KlZQen72G5t4KNqjEgfmvQtOSpo3HnyUzy3zCut5kLtENhfsYRGNqheIHz+TvnAkVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996862;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=NSKjBVLCMexDuWuZH0DKzg+u6EKsWSH5mH8q8VgQcJY=;
	b=iPoG/PBDUzLVv/mbq5H8nqwGBpLudnu29cLMTFWQ6fQqL7CAjqANutvcbv/sIBlS1Rru
	 5uCFKe+9AMvz32xHcg306dJqDATeuJn8L55tYsPWJplwA3BBGx/Cy8WlDePkznnnJqzQf
	 +9k6JrgvR5I08Xza2BHCnieEFugoZdGwd4MxJOZ7RoddjDx+WpLWoXhMyTivT/xhbkxgz
	 uB/Ukiz4HzsJGt+/G6W1htC2+/shm7luj1KubQO1qir2Zu5pHSGvXG8gzG3Y56NgZoYg1
	 h1MjSitv4koO/GKcK1+h9IH87CoH6HpW5gVm0PYxCv64+p8ur8UNPEP0ZAWySuBF3BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=hz3NEhka;
	arc=none smtp.remote-ip=209.85.214.226
Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A5B606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:14:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3A5B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=hz3NEhka
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2e9eb579c0eso4813745ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:14:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996861; x=1795601661;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NSKjBVLCMexDuWuZH0DKzg+u6EKsWSH5mH8q8VgQcJY=;
        b=xUXJf+OEgnvFvm/k4hWPfi943KobE88GP1BOoMjb7LKApfpAPZri49EzPnPm+zJnfR
         aKGHqPXnaf285jF53MbuNnnSMTr3Ui7FY6EkIMY7Ud3wYPemN+Nz7nVoEgb5LrCKz97R
         9U0rO7e+ZlBsG6mMveX9p1NUkDJQ0+I2WNN6EHfPKETfgPskVywQQdp6GU1kyZIJPAYD
         3E2yrRO2kMJ8zraNbVyvNunJTEdH9jOUoGn/KTNdUGvuytiHk5yRPHFg6mDxi+HoOMJq
         wAyJmtgojl4RwDFZEeDo+vuzbv2F5nbzKGAatcLOnPFWjNwSF0RUDjZbx+Ac8Mx9JcQB
         EEXQ==
X-Gm-Message-State: APuU4Z88gJGoX1Mt/maPbxKvof6uNT2TVdfdbhKgS4/OAl9Cb0GS07op
	hxS/xBwJD/AFdu5X2SXOXeZrZG8jVwqNnSJ1ZIqhEYn5YnJ9BXsn3eEuJRGwUxz425FlcorFgKB
	r8TytNddA59dznZ1+4sCLmIHVnACEPVkndjIwPWsyC/ebmykhBPu0LxRzVrpLmJ/riLbGngljRX
	rQnyheNQrQGea4qKjkdqP5i0fGzqUtGBLc+iHsDAXvR3HvAuEgloaPGkNbxe4De5pIFioyn70sQ
	TySgrlE9B00euxa+OkEjFz5lhJUScs/yBw=
X-Gm-Gg: AZFdTZctZQCksTCH30JW2Fvj9mxzxs0CIRncTjxtRgv8zSSg1x0261/DdKViUOR68j2
	doLqFuAUN3BXdqvLGEk74de/hpplHbNIIouedXadpsHziapTGTWl80TwkLlokKBfYLb12HVnno4
	2ZEsu9virlI6sNR9fgLpCHEoztUqISYGnCtmxe+ueet8Ppq527zQRseVR9/S86wFiQ2mfLe0iqD
	6ssFr8WlIGVsRengWd6Rrqsfb45z2eoknZ1vf/dzCbWb/i2MvHwR7j9JYCGGsdthm+Sytd5c2Bh
	TvBYa17A5hcBfe2KW28pEd/t4cUOXcy/qq0RqGwE+8+Q5RJyh8qJQwdVAcJavtsUWfkPk6gKte8
	VTu3zfoqPg1cmynWB7ZCBW1ibWHA+IYC10Y5aDuzmVUmFrPZ+9tyykZEHRRuj7rmuFtM6b38tQe
	rZtPRbNZamUl0ok2ENauTSXJyfG4C3FdBLLCrIzMwZGjK0+VOL+16IpQ==
X-Received: by 2002:a17:902:cecb:b0:2e9:660a:7946 with SMTP id d9443c01a7336-2eff7403ba9mr19623345ad.28.1794996861214;
        Wed, 18 Nov 2026 02:14:21 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2eff623645csm475875ad.44.2026.11.18.02.14.20
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:14:21 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3b0afbf532eso714352a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996859; x=1795601659; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=NSKjBVLCMexDuWuZH0DKzg+u6EKsWSH5mH8q8VgQcJY=;
        b=hz3NEhkaaTPhSyPgBKnemsZ+0Q8bhjB1PaAObVL98dvsS4GzsoHEjOKU0+Y6asejVY
         xXcS1PK0ySoW0T4WhKMUlbGFNeZckdiOwUvXewFHpyLcEaa22hS43pcXupsBemXY5fG9
         vWGZsJot0uDpatDwjPLxR7BIRNVnbVqB5Juj0=
X-Received: by 2002:a17:90b:4a8f:b0:3b3:b425:fe4e with SMTP id 98e67ed59e1d1-3b3d07e0f97mr1976292a91.55.1794996859192;
        Wed, 18 Nov 2026 02:14:19 -0800 (PST)
X-Received: by 2002:a17:90b:4a8f:b0:3b3:b425:fe4e with SMTP id 98e67ed59e1d1-3b3d07e0f97mr1976239a91.55.1794996857580;
        Wed, 18 Nov 2026 02:14:17 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.14.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:14:17 -0800 (PST)
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
Subject: [PATCH v2 37/37] scsi: mpt3sas: Update driver version to 59.100.00.00
Date: Wed, 18 Nov 2026 01:56:46 -0800
Message-Id: <1794995806-5835-38-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Updated driver version to 59.100.00.00.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 6fb511530637..763e1e901917 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -77,8 +77,8 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"54.100.00.00"
-#define MPT3SAS_MAJOR_VERSION		54
+#define MPT3SAS_DRIVER_VERSION		"59.100.00.00"
+#define MPT3SAS_MAJOR_VERSION		59
 #define MPT3SAS_MINOR_VERSION		100
 #define MPT3SAS_BUILD_VERSION		00
 #define MPT3SAS_RELEASE_VERSION		00
-- 
2.53.0

