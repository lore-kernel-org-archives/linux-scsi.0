Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996764;
	b=x6gBYEzYXMJ9hn6EvgfQ4360jZh+UpqdeX8GWq62f5QchgyKPJZ79LqwA+LISauXq6bn
	 CSar6rKrXjB88qEqlpAnDqfbYTdviUaXUzK1U1V4JogsWFLN+uhBeMt7AfI2aGagYPlh9
	 jX49x67Y9bdwjfJdGCf0eZU0JtG8XY6Is1QPHsWgbiET0xNuatWFYTSCZBwYI3BWYU4bv
	 fVEBzsPTDY555S0dfin7m/pdGHV5OfQBxSkPOHh0Gh/5WbrKOrev4UlS1XlGSW49ikMXp
	 d56NDYJdpo7OQj9japH4w22D5z+tWPBcyRXroPToyhMhc2K/7H/ESMyCCF71E2dtufQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996764;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=hUppLo67BqrqlwYILpA04BdoQ3pRqBFLBMjkIiZThVQ=;
	b=AnYOVzZgmVIxQLqM+Jh3GJ8BQ08ZHOx1c3hnGZYZuJ+0qQEQKemI9VSMgxSS3GLgD2KE
	 WhFAkLMFhBSTb0yQMDiXUkOYUZ0pC2XKtzKBLsbzGdzk+HRM1wALic06YxsKU9in4F0en
	 zP77ntjpJPK4TOKBC3UcGHjSzRBnviNifr+3up6j3yYnZDxG6L601kvCrcJc6XL4m+mJ+
	 6NFKvtTK6sumW9Cs8jy5jAxBpNCttzYfbpnVA3KKf+yGEWlFAdzav0LJ0JVZzfnZ+UdH3
	 15Ae60Mmor/9fJWipBkdlTk55MPq7t31KWIv6PNAQ3KSkrqwm8/UCCrHSAEiU6Fkhpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=KN1N0843;
	arc=none smtp.remote-ip=209.85.215.228
Received: from mail-pg1-f228.google.com (mail-pg1-f228.google.com [209.85.215.228])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86431606A32A
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:12:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86431606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=KN1N0843
Received: by mail-pg1-f228.google.com with SMTP id 41be03b00d2f7-cc4aa18f9afso480671a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996763; x=1795601563;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hUppLo67BqrqlwYILpA04BdoQ3pRqBFLBMjkIiZThVQ=;
        b=oRfc29GhG6D1b5R8oeHZgC/MkRD0KfDKdA6nEY9WY6/lsNj4OpJ9AIH+TG10MQDrFm
         z7ZFkMxtPwg4nHDIPurHWso+PRfqmw1jOSgkqk1c2CfE1UODphFHrMxrFlAKGDVIsXV5
         TV816D9qdoA/nW16B8BszmnXK2XyMIE49bws2TlKDXmtudwlBAlFTK7B+9afjtxKEZF7
         gMs03ExL4UuFG0A2mrDvGiSz+vgRNZMGYgGDCwuVOWtvtOVLCjH4i9haT/Yzvokdaxde
         hT3TyrLoojJz0boOI2lWfOPYQAIsvt1c4r63tTukxfViKMR1mLxUAazdH8g2hFbYMXJg
         n4vg==
X-Gm-Message-State: APuU4Z+w2qg79yr0qYBhN3CecrULdE3lfS0grH9vGWPDkTGvOMfawpKm
	v8XvDoFFnaC6DaI5UPizOaR3pBMIPJDSaWk/Ldw4Z0RLrOUM6ivBH6it9vap7H7mYKhklxMB5HW
	Sx9K0bNqK+d3hM4MBGWqrS0p/PoIXZy3P9Z5Or1PXGr/DQt4rr5zEWukuTYC4XRvsG3zZtTqNNU
	bpR4dGA6nAP+Zw0jMjXLPBGTnOW6YxM0wXRtAxqlAqqwwap5OePsd6gmLbBp4jQ+F7lEP0dcmO3
	fbyS0Uk7M/RacE9C8OYwcRePMlCjwjuKLU=
X-Gm-Gg: AZFdTZeIaCYjpcitgPhphoL3S+lte6KQNS1oOiv84rla6UpyLcIIr8IdR+TMXy/EaSj
	FiGs+tYIY5CUKR9gyH0r3ZxrHwm92nzDjBhR9RnmaCnQu3ALmVeiPUDUqFPSStNp0bcrF1+CMq0
	OQlQC1guB+RKKoejM+wX4JcYujXvHlVo4KrmOJCyuLqLkZvk/KN+uhupeqqlnqUg0I/IhomGDH6
	swA4H/y7+77zpIZoFzdQZaymoMfoG0Ae8MxU883Z4v/5FfKBcc1qlgkmYlgAl7HkCG7aZa0oXa0
	itwRWW6YC5XS5wO6CBZgoiAf/uLyAt4ZdbE8p4vqjwOvyl+aWVBGkcAg6guSKPIFbmn3N4nd+wG
	zZFdLoL9o5z1kOmJsc5oi47AwehfWoy3xSTRdJYPv+BQxnU25feitK2WQGNQJJRaTg7nngqhoPv
	KHx2T8ToiI5d18V1x/aTd7ypkTU9j+7OJk7iIuaJs6zppCYvahNaWf0nfH
X-Received: by 2002:a17:90b:4a04:b0:3ab:e588:c275 with SMTP id 98e67ed59e1d1-3b3d07598damr2052722a91.20.1794996762753;
        Wed, 18 Nov 2026 02:12:42 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3ab9f98bdsm4031447a91.0.2026.11.18.02.12.42
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:42 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3b08aee6b3eso749029a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996761; x=1795601561; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=hUppLo67BqrqlwYILpA04BdoQ3pRqBFLBMjkIiZThVQ=;
        b=KN1N0843kbiJyZPkWcjX0CY4N2jPKL7cMR9FxVU9HjeR3/+saSZfJOiQm8HNnCPxzw
         S+yne9LThSfwHB8US6ZuQYpt923ok//zQsRVd+YlmQmKPpvaZse+2SxBAtA4u4rASwRf
         zopmw5Pwxr5j05Org384Eh2gwsGxOFmFMUDUY=
X-Received: by 2002:a17:90b:448f:b0:3ac:9c37:942e with SMTP id 98e67ed59e1d1-3b3d07aba04mr2288091a91.49.1794996761088;
        Wed, 18 Nov 2026 02:12:41 -0800 (PST)
X-Received: by 2002:a17:90b:448f:b0:3ac:9c37:942e with SMTP id 98e67ed59e1d1-3b3d07aba04mr2288062a91.49.1794996760517;
        Wed, 18 Nov 2026 02:12:40 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.12.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:40 -0800 (PST)
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
Subject: [PATCH v2 12/37] scsi: mpt3sas: Fix leak and dangling pointer for io_uring_poll_queues
Date: Wed, 18 Nov 2026 01:56:21 -0800
Message-Id: <1794995806-5835-13-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Free ioc->io_uring_poll_queues on the legacy-IRQ fallback path and
NULL it after freeing.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 5a51844608aa..bd169e3f18fa 100644
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

