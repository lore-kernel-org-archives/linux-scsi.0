Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793794218;
	b=B3rUaAaLgatlneEKEZUOuMlf44Udie0j+cCWBgyq8CmQBqWD/DUNoLGc/XKpzHIq7xb2
	 Ndnj9BxCXgwg1s84fw0gjXKwyGrRSYkni7abHvQzx+pbCIGigbM2WLqiBDyr98iRmKpVb
	 T5txyKErErTlu9qWwp0BlLhXGOP8pGT8a1+4vhTtr2jNTbXjSqv9RxaRgdUpXXlRyYhNF
	 UAmsKQtjk8cLZwuO63BgCht46qc6i7vq/gg/X6KekRAcgHCr9vkH1qY+MYkd3SP1QPs4e
	 UBcDmyVHp+Eq4yEhGPdBO1a95C9A8bBM0FHp7t5lkMTVqXrJeEywzOC1zBOWRUIezPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793794218;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=oujmMz9BCSgEP63rK5A5KBALQH4TEIQdpFTTb1rGEOI=;
	b=mhljWGcw6po5OzI2EW6G9j1atrvhRduQDCcyegRVdhOV1dbAfyafT0+qrR3Q3KEra13T
	 MZDO5F4AgOIs0vNwfX216gJQ1XhbDLM4TnFppIUhLMzkDnO3s1lLBpQ/UpEXhOkq8LZX4
	 DYON2I/l7xTrWRKFZDOruGiGm8p6TxyRQIIo8HRKCv6+djPfkYxOjWgpc33kMJ5Lm7yFl
	 ddL3+TxvItJGFhEdNCd7lh8pqf97MAvNVMHSyF/Tu9P8mtPKLpUCdlsFLSKCFoYCM3Vda
	 MCsTMdk3s8zVQmtmXm0bFU73MZfZ/+WUrIJssD90+ddwipVYajJkSDwPARZbbwSUdJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=L+NE68og;
	arc=none smtp.remote-ip=209.85.222.226
Received: from mail-qk1-f226.google.com (mail-qk1-f226.google.com [209.85.222.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EF6606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:10:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31EF6606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=L+NE68og
Received: by mail-qk1-f226.google.com with SMTP id af79cd13be357-93e4c00d71aso61902585a.3
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793794217; x=1794399017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oujmMz9BCSgEP63rK5A5KBALQH4TEIQdpFTTb1rGEOI=;
        b=064UVQJR+pORiRTCGCuMmljJJAEghtErgAe+eOepKcbzNpGryDj3D644wsWoHPwYkr
         HcVYWl4ieGKtIfnOYDqNiEl64xkgCFHjvVR9NAvRyY6QuVn6b394nycX5dtSkLdxXCLf
         TVPlRR3Zs8OJZf+HoQd/s1Z+4eXddsAsCyT4WNEUwE0/nJi5BCapkeTSvXxV2Hvshsk4
         i0EGQoGf4v6bgRTyUG8UdyWMWuExIHhMITSuSChbx6KCC2XQQHcGTLNS4AxCIzkEjmRP
         WMwx1OeHLK99a2Eerwl5AQQPz4T6STHaSeZKrUxzST/VWjnYyPYx5SU2w4TZMsw1M7Rh
         lVZA==
X-Gm-Message-State: APuU4Z+CGBUZGDll3C/aHcUDAZULyiEgmUNBYab4H8kTsNvTTa3BAcFo
	MxkjB9bucu8IEZQ2ICw/AjeFLKfrGacrQTqzDcSeNg5tKugtSiJmVRbbQyRoJco1kDmcAj5VM5Q
	CTSSZfhG05xOesqOpbV1qJV4cbEMsn6WZ+BKjDZWL/vQt4yG4m/O+7S/rjnA2xehWiuV9dbdTyh
	Rgn/2dY+ESWM/PqoR/x6tOtQo24b29vydznykw7vZaCbMwycOphMBaUv6z8oRL7R6PMlLm0g/FE
	sIxvKvLQEddCqCk
X-Gm-Gg: AYBFou2WKyOglUJW8lSCcILyziafY9qUuWkSKSU5xBGdnFeNtq3g0OhKKfXjGWwDWmk
	u5hdUszCj3xDt14atdc+iBxbM/UL33RHNIdy1ykWZk3F0zOUIkiund2LnRRXfXL5radHVluYSRw
	pnCy9fZmh7IQRLkbzk0EcKj/30yULb38b8xdt+GAjD47PALo9dj/DekaF9aTL8zFbBpo+1Si737
	4HZj6SAFT6dpSnYKdtjwiProzfci1jbv5pCiLrWZkuHQUq1aL0V/SxBTm+Nadcx86q+3vfK4+7o
	dC9/hh7RMpHt2Hbk8GdalDj9Ej0oElGAMDrKZLPWZr3AXYvNXU5FRXG888H+e92yaNVtH6wZt5d
	WkYQYfjMWyKv+3tnJF8sXX+6x218WouKcyizZupv/q8c/iruM50rKkY5d50GqQIYfpD4Xa4RC2Q
	Ac+4OinTHbSBvbVSaZI3DVXICTLycpmBuMt7w=
X-Received: by 2002:a05:620a:6602:b0:93f:3358:3ed7 with SMTP id af79cd13be357-944217a3b2fmr2260504985a.54.1793794216798;
        Wed, 04 Nov 2026 04:10:16 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-945d481a652sm27095385a.18.2026.11.04.04.10.16
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 04:10:16 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3b0a519048eso204872a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793794215; x=1794399015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oujmMz9BCSgEP63rK5A5KBALQH4TEIQdpFTTb1rGEOI=;
        b=L+NE68ogXay5EjWUPya4EhdFGbR4BrymceqnyOK7Ol9+YnWEvdxSnvmxxPD7J4254F
         0a4aTbP17zPtE5FvZRxpj4AfCp53P1jY8XfrF28eCnGyFfpCz1aJP27QAjT9VNSvD46n
         /tx7Th2m/I00JGsq1eYJxGJHPSpNqpyZ3tR48=
X-Received: by 2002:a17:90b:4cd2:b0:3a8:a1f6:3b32 with SMTP id 98e67ed59e1d1-3ae89772b3dmr11346473a91.38.1793794215446;
        Wed, 04 Nov 2026 04:10:15 -0800 (PST)
X-Received: by 2002:a17:90b:4cd2:b0:3a8:a1f6:3b32 with SMTP id 98e67ed59e1d1-3ae89772b3dmr11346442a91.38.1793794214899;
        Wed, 04 Nov 2026 04:10:14 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm9377095c88.21.2026.11.04.04.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 04:10:14 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH 09/21] scsi: mpi3mr: Queue DEVICE_INFO_CHANGED events to the bottom half again
Date: Wed,  4 Nov 2026 17:30:50 +0530
Message-ID: <20261104120103.503871-10-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104120103.503871-1-ranjan.kumar@broadcom.com>
References: <20261104120103.503871-1-ranjan.kumar@broadcom.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The DEVICE_INFO_CHANGED event shares its case with the LOG_DATA event.
When the log data handling was added to that case, DEVICE_INFO_CHANGED
stopped being queued to the bottom half, so device information changes
are no longer applied and the event is saved as log data instead.

Give DEVICE_INFO_CHANGED its own case that queues the bottom half.

Fixes: d0d19250ed81 ("scsi: mpi3mr: Rename log data save helper to reflect threaded/BH context")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=5
Closes: https://sashiko.dev/#/patchset/20260818231426.58105-1-chandrakanth.patil@broadcom.com?part=11
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=11
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 6b0156e54d45..7de8f20e396a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3273,6 +3273,10 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 		break;
 	}
 	case MPI3_EVENT_DEVICE_INFO_CHANGED:
+	{
+		process_evt_bh = 1;
+		break;
+	}
 	case MPI3_EVENT_LOG_DATA:
 
 		if (mrioc->reply_sz > offsetof(struct mpi3_event_notification_reply, event_data))
-- 
2.47.3

