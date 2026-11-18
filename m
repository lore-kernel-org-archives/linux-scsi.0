Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996829;
	b=2jT9HbvPUW6VYDuXdymieIBp1atICNV7HG8oCBqt30U/jtlgdruJZJE1Sx5WVVptd1Ns
	 3YKr51ZIw3IrV9XUW5FWqmHHmon9Gm0g11sPFniUrFotuchpdr9Cbt2HBa3Re4aDHdfHS
	 c6yfn87vny/H2UcydRttIthjNDKKLScRofktZZuHnxDQPhu40noSze2Yuf9Beem2vpkKS
	 9OQM3vxxUCYZUtWYiu8GZVziMC5+aVu8G7tgm6Ir5Yz6wuEpg/bnKYAbs53QxuCkAIEMf
	 GBMAtiin/Mrx7d/p09M4uKfcdaFp09c+RUf9QM8hB3nLw7VgBWTSKz8BLrzWdbo09vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996829;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=TF1S2wGlPXawZyhWsy+9usc2zc1Xr/XHFwmGKDzVDU8=;
	b=2xR5TQNyBZ58SodSBL1ctUtT98UAOJ/ndi3MQ0vyIREiQrlNVQiXOJ30q9DGAoumTqwD
	 1yOWLxMlqe4ByHYFm3gbyCDqbdCZqt35rYEqZgXiZNVOi7zeo/xwij7LdmVUQRrueZiDK
	 yUTzei6eV4PvToVGrrAaGlZ40ovRwE3hrejjBLjJa6LupLw58KlPxONsqu9wX0kftVYs4
	 CEML7YHwd8rjGKu+hVf8QExPcO+CgtE0jREdXPi6PwlL0QM/p1tpOQzu9ZK90xGKvDbSO
	 HVPzwj129ONE8yRlKYCXlOUgeZhjh61pifIIel1URuYw+R2AFAtq+FS31WP59PiFJXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=T5TnAoNw;
	arc=none smtp.remote-ip=209.85.215.226
Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA843606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:13:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA843606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=T5TnAoNw
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-cde1479f76fso649588a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996828; x=1795601628;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TF1S2wGlPXawZyhWsy+9usc2zc1Xr/XHFwmGKDzVDU8=;
        b=0xid6zAUGPIlGfNj5FkH8rbceqkkbRD0jFzNYJB64mNxwOuoBblOTxqncL4VwPSlfb
         Ls/8YEcYnYoAXlz1q1NpliJuL4ahpEpeyRFqE980PfNiPB6qbFj68TP1rfPrPC/EOR6P
         f5cu1t1N8uRyp7foyx0cVDi+rD0/yoioLWq+Un73QHzbrEYrjmoDizzaUYhqx3QU6eSf
         dG0kSMmvhgNOKxNAQ6KajgYsRyj2j/tzKyXI5PMQkS//wcOm23lS367kKWATutRpX5ir
         9eSTemBtZL7vhr41fam+r9keZ8dHJ3qEWKfXxcG9bKXH7FM0mf/9yN3LXURSvzA0WxTA
         XJGA==
X-Gm-Message-State: APuU4Z9CLnkKgbh8DlHjjbNAssLYfGem/1iuOMiABFQlblC1JXqc5qV0
	cZvaqj98kymBcyjW9XAQFp3TVtbhhHGPS1nlGDoiJ98B/dubQVCKjWCcoqnZoN15cQB0iBLLaxp
	xd/nHF5erBRRgAqpQ9HF5rt8xM8InmEFXqNnk+rvbcoGbLjSGNnqw4I/mzCIm8D4xXoPxIJ09BV
	YuiJdZ4rNbXeE/8jYcvZ2fKapgWm1q2sp6GtFBNRaUtdcgBAvxiL+FnZFrSH3uubK81xA5qUcKs
	iCObHlCfhT8zedmpJQ2xWnCCArqqhGNLDE=
X-Gm-Gg: AZFdTZcr43aaG2qoyC1ahv1buw2yTqEkYxmfqlKOrX0HtRIfHcHVvqRPrqyVpZifYGB
	Bb3HMrNDEE9TaPQkDPqXmUpkXcQ7AZVvPrqvzcqZiSYJJcoK8935fl8LVW7LS0bqtMi13xax7GN
	EQtT6MDrNsWjdGXN+T7lI4Z5y94IvdOQMZZ28BLxYdpR0GmFlI8ff/B/wM7wsYG4fCEWG4kbEgz
	OtuYvyDeRl+Ses2SLMwvsiSNdAVmGG+DD9qhw0PEaiXxn2BfUMBii1/cCkCzPjLZMGSEPFU/atZ
	Vuew5z7hvD/kcH1otaZjOXqbKTANj1N64pcLuDiEiFK9tVx6Q/RB6fH6m2KSkApcELAV0qqDX6V
	heae07/HvFkF1ZlFIAUtq6m3N1zU6U3RXoCLAQKf2SVccmGcOwU5tu22yaEOKtGh3VwNbLp0Hfb
	08u4eNIl/DieO3KY/3ekS3pzWK7iEvi5ZnPF6KvNk1KzgQa/XE1mCDAQ==
X-Received: by 2002:a17:90b:3851:b0:3ab:1e1c:837f with SMTP id 98e67ed59e1d1-3b3d07a88b3mr2032320a91.47.1794996828325;
        Wed, 18 Nov 2026 02:13:48 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3d8b8ce6esm380032a91.4.2026.11.18.02.13.47
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:48 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3b175a69ab8so887165a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996826; x=1795601626; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=TF1S2wGlPXawZyhWsy+9usc2zc1Xr/XHFwmGKDzVDU8=;
        b=T5TnAoNwG2dKlPvTSidCR9QFTQ0YeOlvczc/LChGhTPfnrx/GzTQEq90UYmnrlIa3L
         qqVkIVaiti+Rczf8QFk1JIZsoNUb8WLa0SoG3gv7JZCokmce4BEZyktf0bDuH7DUxhzJ
         NgVplAeFNGGmDCKmSg/e3rmk6WD9VYopE8twk=
X-Received: by 2002:a17:90b:2243:b0:3b3:c44b:b774 with SMTP id 98e67ed59e1d1-3b3d07a7a7fmr2137179a91.45.1794996826573;
        Wed, 18 Nov 2026 02:13:46 -0800 (PST)
X-Received: by 2002:a17:90b:2243:b0:3b3:c44b:b774 with SMTP id 98e67ed59e1d1-3b3d07a7a7fmr2137155a91.45.1794996825986;
        Wed, 18 Nov 2026 02:13:45 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.13.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:45 -0800 (PST)
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
Subject: [PATCH v2 29/37] scsi: mpt3sas: Bound event-log copy size against reply frame size
Date: Wed, 18 Nov 2026 01:56:38 -0800
Message-Id: <1794995806-5835-30-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Cap the event data copy in mpt3sas_ctl_add_to_event_log() against the
space available in the reply frame, not just MPT3_EVENT_DATA_SIZE. Treat
frames too small to hold the Mpi2EventNotificationReply_t header as having
nothing to copy to avoid underflow in the size calculation.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index d3166e048991..d15ef29ed077 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -366,8 +366,19 @@ mpt3sas_ctl_add_to_event_log(struct MPT3SAS_ADAPTER *ioc,
 		event_log[i].event = event;
 		event_log[i].context = ioc->event_context++;
 
+		/*
+		 * Bound the copy by the reply frame ctl owns, not just the
+		 * log entry size, in case the scsih-side clamp was skipped.
+		 * Skip the copy when the frame is too small to hold the
+		 * header, since computing a size from it would wrap.
+		 */
 		event_data_sz = le16_to_cpu(mpi_reply->EventDataLength)*4;
-		sz = min_t(u32, event_data_sz, MPT3_EVENT_DATA_SIZE);
+		if (ioc->reply_sz > offsetof(Mpi2EventNotificationReply_t, EventData))
+			sz = min_t(u32, event_data_sz,
+				   min_t(u32, (u32)MPT3_EVENT_DATA_SIZE,
+				   ioc->reply_sz - offsetof(Mpi2EventNotificationReply_t, EventData)));
+		else
+			sz = 0;
 		memset(event_log[i].data, 0, MPT3_EVENT_DATA_SIZE);
 		memcpy(event_log[i].data, mpi_reply->EventData, sz);
 		send_aen = 1;
-- 
2.53.0

