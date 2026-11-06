Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926729;
	b=dpPW9DsxSgDjHSCPBUJmy4cn3qjJHwNBX8SHg4t/Yh2o25wIB6nWah3EyUqOr/A9vSQU
	 sDxpzbEhakxq+hE44nuznGNj1iWjaHGSljJTx25DHZJjl6IoEyImYmmja7/qCMfKi2oh/
	 C856knRSMt5rQjy1247NV61At5YIjSdnGNGNI233JP7Ky0wrg0IkuApGX77QuXeFz3BOx
	 w6MT5GHicUlkWEeF0rEU6N6K5cJfl0NczivNn9GR0knO5w66Zyb3+A05lDtF01FOb+1Ti
	 rkG8pDoe65+dleWFrHTdGWltvZ9mpFwCMqbj3gbnNMKzMs3qiocfuNdpqA2Ug00jWjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926729;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=7QcqjmwFhGnwAvS1KYbq8Pn200oJzoQDmFAU4qnG3zk=;
	b=mCNs0OCKPL9rOYQgOrTiZvACjZG8DGKUZ85SXZTpzO9Bfs33aaX7PsPHhCrA6EweTemJ
	 C2kYIxoio7gIv0Egob2BrzJgJf+3sGIRk8pGL13XG5g+d6FO2LwGyDH9/tb0LiW7e/Idt
	 08YilNiPbBf3NnqgAUEX5gDlIa6zo9CKp6rxrQuJ1vPsvHOEG2YiRkaAvMVVDbX2Y8tY8
	 9CFcybXqH6MALyeVOqLPJq1kHNImM1xJ5rYjXJGdrf0QmtsbdKCavh7AWDb7QypnjGH4t
	 nUZ+2VJsFaKZ8nIGVRKdGGuzrmVRCuXf12ErI42t9w3c8OzaaCtwBBBo1/T7W06WvOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=h5L0VnsW;
	arc=none smtp.remote-ip=209.85.216.98
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F24606A326
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:58:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6F24606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=h5L0VnsW
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-3ae6b4c669fso704299a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926728; x=1794531528;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7QcqjmwFhGnwAvS1KYbq8Pn200oJzoQDmFAU4qnG3zk=;
        b=LF9RT6bTwb+0mXZn5lSK9WlDDHdMailKh6o1owFZy+sEJr5/XC2r/EE3M+ijfi8fV7
         P878F9H6VU/wnPqslJ6i6HP/QS/ZJ1fyYaSeBc3lo+kaPx96eyMSIkTgmHigst0nl/ro
         cbO9M2s5YYyiY6kn4c3Ivk7vGzYKaejp1dOjP8knrxWOxtFD0mQzlft6M3vCV12BKQqc
         U6KQahHFFQtzFouHYYc0Cus7A4yTe7bQeKj6haRxjot+xYsEeKk1N5gM9e4GtZ6l6IXt
         OeUFhzoY4Dz8xjBSJSTuEm1K3ECV9kQJvZIi0kH1mAInrmsHVF3czGDYzMrFtRQdlohf
         cgoA==
X-Gm-Message-State: APuU4Z9r3C4WpMvrEDOkDM1Y8j0jBpZVIrmUMichP2LAJluHjADqc0SU
	hAGf+vKTTFVNVkTVAWkqLVdR6tJ3OfeL0YWjvmQsUF5iXE8ftpOy+alYWnq/ds+qpCSNejEnxFd
	TXSqmDPw6mTIVk226wWIjs8OxbBd/6yMAUwkmU8Poxr3Q7j9DR/p8pm98p1Pl6H6KpyUWN8hIBA
	5kqez+PGPesvlWx7qDlH/NiSKgeR18H7DnShCgPiiZMqWW0hnx47f7aVky3CZy/5AAY8PBkyOkC
	celpXidzNm4Te3Wh4O0+UjAwUzGcQCKrJk=
X-Gm-Gg: AYBFou2turxFs+eo2FMZnGqRjW6RZ2Wm2LZZ0Ch6VRdqN7aYwuOZ8L64WH81+CSYTmZ
	eEAYoIoNMl08Z57or5PC7lDgSStPMU0Pm89oM/T1r9BYE5OVK8b9dvfxsfKvoc/Ml9ciBWta4Nf
	vO4S2/PwgC0WmJXma3P/hsCmEYjFMc+w3W3SkiSRozkgM9VsYitFCEMiVF3PaXBlCdODypOB3h9
	QJQP8Mbas5lLxTipkhH9FFoFhTK42GwJbPY72pUCdTP6G684HLs/nW+ZhccKnlJo8iOj3BuGPd2
	ZmYkPuT1jt9KZUkHBhLFvggFb8d+yssq+GLX8GTzDTGdIP9A4qg+T2hgPkIS7iQfuMix65Rrdlx
	gm5eXyLxht19WIpAeCsBaccVwP61hYlgc3ALo1P+n7DK39V4uhLhaqZLb/RmTnxfl2OED+U7Rnd
	PRdDcrroL3pdC8x23v+HbSnun+AF5Yq3Tcmp9zvjjwBlgUvOJVuOuv8g==
X-Received: by 2002:a17:90b:518f:b0:3a6:d850:bf16 with SMTP id 98e67ed59e1d1-3b0db6e1f9emr483846a91.23.1793926727940;
        Thu, 05 Nov 2026 16:58:47 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b0b315a756sm2907568a91.2.2026.11.05.16.58.47
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:47 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ea381ce04fso2476055ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926726; x=1794531526; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=7QcqjmwFhGnwAvS1KYbq8Pn200oJzoQDmFAU4qnG3zk=;
        b=h5L0VnsWM+txQcuAGuGc099Kpl8P4z4EmBTaJ1knDbDG2GTwIjjWTgVbu6RS1LjGRh
         W8Kl1uI8UrIfWHvkhNblP6i+sYbBK+MGvkGQqnc0WCkerzShr5k0uXFMKe3+ZHLcVK4G
         r9R99oz8JtBcUmNa0bkJCRVnfCACuTuXCVAfE=
X-Received: by 2002:a17:902:f78c:b0:2e9:484d:693 with SMTP id d9443c01a7336-2ed23e53d15mr28740645ad.5.1793926726353;
        Thu, 05 Nov 2026 16:58:46 -0800 (PST)
X-Received: by 2002:a17:902:f78c:b0:2e9:484d:693 with SMTP id d9443c01a7336-2ed23e53d15mr28740485ad.5.1793926725809;
        Thu, 05 Nov 2026 16:58:45 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.58.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:45 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 12/37] scsi: mpt3sas: Fix leak and dangling pointer for io_uring_poll_queues
Date: Thu,  5 Nov 2026 16:42:27 -0800
Message-Id: <1793925772-1303-13-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Free ioc->io_uring_poll_queues on the legacy-IRQ fallback path and
NULL it after freeing.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 40624b3c972c..060482ba20ae 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3362,6 +3362,7 @@ mpt3sas_base_disable_msix(struct MPT3SAS_ADAPTER *ioc)
 	pci_free_irq_vectors(ioc->pdev);
 	ioc->msix_enable = 0;
 	kfree(ioc->io_uring_poll_queues);
+	ioc->io_uring_poll_queues = NULL;
 }
 
 /**
@@ -3541,6 +3542,8 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 
 /* failback to io_apic interrupt routing */
  try_ioapic:
+	kfree(ioc->io_uring_poll_queues);
+	ioc->io_uring_poll_queues = NULL;
 	ioc->high_iops_queues = 0;
 	ioc_info(ioc, "High IOPs queues : disabled\n");
 	ioc->reply_queue_count = 1;
-- 
2.53.0

