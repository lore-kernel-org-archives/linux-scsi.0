Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926711;
	b=Af5tiL1YK0OsSIcIp4LCIj0IQXDYnFby3RK7fbmtnPXYNJ+LO0dB6QSc100bUIu0Fpta
	 LqY13+2cbFBII8+vmMICqHE70C769Z3kKvKB3p6WtohvDXLScHvkqEKbIhR+2K2W2wtDt
	 72s6h9+6DIPaKgdSnnkgsWrqLOcVQywOCLjNAZ310c3V34HzP/ZRySPpmPHTRl8abERK2
	 7gqhH4c6xPIjWzz74AC4age9HxPo2leP32weOUlmV+LoBKskVbpKmzuFffiq6D80kAWSh
	 xrabQOGdDGpJ94eodUYuWLk+pkyQSmjf+xFHttFHlew9JuBt1IYkUr3qFlEl0d/od8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926711;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=RXZRLQdbeyRlHrVJrx6nRhsj/cbBYpcGAf4ct5BZogQ=;
	b=308+oQPAPRB44rFWXeWLJFKAltshxk2gv5gO1C/OCRafOk5qOW+6A0zMkp4tIvBgRdHv
	 LyUt/oVYVWKFyFaCtwBehqiv+B7ZfwNVrrx0BT5ZGknfxOvieBaaXIk0aqbWI2NKWzgbo
	 oFm4OZUqXU0+JECoP7TOnYPXA+na3YKrbZBFpqKlGYzS4129cOiGK18uLa6Q2SYB0NWKi
	 s4MJgoKV9t50tXjPE/0UByxET4e84r+5pW9jOBngOZA1GrAM4flkDApTa9JcY8A+95MVy
	 YcQchL7tswOvbokmNRaD9Kg/fsUkJBMqXcnYUJcWXFVH79GJQl+4D3UTeg4c2YjvczA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=edJImVjP;
	arc=none smtp.remote-ip=209.85.215.225
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD31606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:58:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFD31606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=edJImVjP
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cd6acc50b8dso36356a12.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926710; x=1794531510;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RXZRLQdbeyRlHrVJrx6nRhsj/cbBYpcGAf4ct5BZogQ=;
        b=bb7C6JJ8Q+nt0LzoLIFVtdjLs4z/uCMPGu51k3toSyuicOK8ajGL0a+aJmHfKBUVEv
         nBIoFnd2SAOM1KBt7aF4d208U6Qgsz8VcIP+NA6McHkFPcTbjppM7WXY2i46qI4zCCre
         nnu64v1NTn+RYpQZDQw9V0fuyc7C/CfqkT3YgqGFTFDzEpdU9Bm6fagumOJjyOFB11lA
         AWXMzhKY3uIgqz1dZe4aQ9GB1udenCTuXDUIpl0FKVIK0D5OdO17Ej/+T2aqLmvrIQcO
         bxlY58u4U21jfBMlwIcE02+jjHnyMvnHA95yAnE3GXiXX1iIFtS9IXbj+dRqqUhDkn3J
         nSwg==
X-Gm-Message-State: APuU4Z8BSUwtl6RLjBf87qiB4TAC/9EAcZCQZu5ybbh5qeUUd6lgDmU4
	lFxRiinxvcNdjO3WHrO9pmB/SIBS4jQiIFIhQaAobh9///DOmdKB86l3MsKX4BVb6CNrsV+++YQ
	2G1w7EG21/p16KqQlal1WXlE15RMmuEX6gXjf4BZuXYMQQixZedpxPsxrN29xv5UjzIT4aW6/2f
	z3kH3PED8g3RG5jbHUgqXSxZe5dxlIplBQrYMF5OxHGoHosHtzgE4jm/OXCH+1MD2uxMag44uW8
	sLdoh9K8D101UF9mfOf8OpPjjrg0ait6wA=
X-Gm-Gg: AYBFou36Wc0JI4KTZmTWVfsiGbp9J9ZuTS/Sl9RhzWpmRE7eAejB1Ja1FTjOLvzeHqW
	wC0+y92DnH0HKbjY/le4fG79DZvmWGRtK02oJb6HjYwZ2msTKvqrFgppS7qbuprLlvVkVs2qYRS
	z7PKG5Vod9TyLWZz1ZMCkHQIkoUdOazCfppz3SGoE59MenLwi8FxTtqzGM0qwjtwt83L0hralVj
	EfYAyCi4LUrWtvQ1SCoVGM+PAWt8GUp1t3oDSdPMNX+klI6KD9MwVpQTXqE7uReCSnI9WCvcg1m
	sOlQ1y00ZTfSZTCoPTAfuS7ZUWZZu5H0Of7dHYeOxbHWGTM4p2+sR9X9E/44WtL0jk7XJ7Phcls
	0XCqf7f/jnK10wIMpD4csngmD7FheGpNEjTa8jRLUE9EOyCBbMtYGaCbFP8MM+RvheApS8OcvuT
	9sgo7RepucvsVriQcnIiljjTFzCmGOQDvcibzCyeiDjih1AvgSLR0Ttw==
X-Received: by 2002:a17:90b:47:b0:3ac:9d14:feb1 with SMTP id 98e67ed59e1d1-3b0db7022f1mr822890a91.43.1793926710276;
        Thu, 05 Nov 2026 16:58:30 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b0b315a756sm2907077a91.2.2026.11.05.16.58.29
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:30 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ed05b3eaecso984205ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926709; x=1794531509; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=RXZRLQdbeyRlHrVJrx6nRhsj/cbBYpcGAf4ct5BZogQ=;
        b=edJImVjPjeDlyFOb8WHqqug2dUGkjfdSGyIFKa7wnIwFUU5alhcS6Z4wCrnJR+DaL8
         pvDvlpGk9Fnfcnt9Z/Y3Z/n7mJLozUUZNKAVL03v+xU+hWegbFx/y0nHRgmk+ugTudkL
         WQbyrPo97N5cP6bO1OA8bdswAAvJhLsQcV3Kc=
X-Received: by 2002:a17:903:2406:b0:2ed:790:b8f8 with SMTP id d9443c01a7336-2ed412f7979mr14104905ad.2.1793926708643;
        Thu, 05 Nov 2026 16:58:28 -0800 (PST)
X-Received: by 2002:a17:903:2406:b0:2ed:790:b8f8 with SMTP id d9443c01a7336-2ed412f7979mr14104745ad.2.1793926708136;
        Thu, 05 Nov 2026 16:58:28 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.58.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:27 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 07/37] scsi: mpt3sas: Validate SMP request/response length in bsg handler
Date: Thu,  5 Nov 2026 16:42:22 -0800
Message-Id: <1793925772-1303-8-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Reject SMP requests whose mapped request or response buffer is
smaller than 4 bytes, avoiding a length underflow when building the
SGE.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index e74a526efa8d..abb46a5e1c1a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -2095,6 +2095,13 @@ _transport_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 	if (rc)
 		goto unmap_out;
 
+	if (dma_len_out < 4 || dma_len_in < 4) {
+		ioc_err(ioc, "%s: SMP request or response too small\n",
+			__func__);
+		rc = -EINVAL;
+		goto unmap_in;
+	}
+
 	rc = mpt3sas_wait_for_ioc(ioc, IOC_OPERATIONAL_WAIT_COUNT);
 	if (rc)
 		goto unmap_in;
-- 
2.53.0

