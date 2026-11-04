Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793794251;
	b=t2yGbBW1+injt8XoB5SVzDYvIHRkuN9tvzIRzL/QAywnAORb8HwQwNN37EA6pmmsMbee
	 j7z+HoeirFwgrQLKBwLocfiEZO68Xa2gjxEiLstESiiulmRtZkTqxYG0TY6+pEkYjO8st
	 e2KKJTe6uL3OQhLZWP7Gxqa4cn12UmRuNigiGR8zzcchBPBj0kcS8dEFnSwAuouBlFGwY
	 ZULeJZiI3wElRaGmK0bLFgzSIrpfSLU/0w89jPM1nv8wFzARRniAZ77XEi5cbWZxHvxMk
	 WLkANf+ZRFk7G6lTuFqZfiZ1PpA1FUNWsHP5VpT/A6ifg7+LdI9Po3bwKQlycNKm1UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793794251;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=s0ts1uO6r9k6Cw8ocmHrCkTItWA8qEMO4bxVdk6OkTM=;
	b=Zy95qR4EtVY/ouqiCOg+/SoLLT5S/TIx9hop6VxNJ+tub+R+65+7yduzgV0nfOgz3S1m
	 V6Zya7GCSg41s2eBp982Gxevwvl9gmZ7taUoeR4BjymOTeVKSJgPSmiJOU+jxmRNZWvet
	 GUJzQvLfWJH5ZFehSsVYr8wCc3s/VOHF6bKzlj2YUA6tjnXeoIZ07gtSnkl4twm5/2pWn
	 +zLIE2BIr+11Dr0JURFEOieGTZD0hWmQ+StDVMlJ4AWUxn0L3LDi9hefLzvPGEe5nHbrW
	 aRzt4c4gxsYngyjqK3xSLNEX1SvhA9HFQInKf0AzvJfYtJfFku4+Hpk8r3Jy1yJCL0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=WLVlmFbB;
	arc=none smtp.remote-ip=209.85.216.97
Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DA6606A326
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:10:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6DA6606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=WLVlmFbB
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-3ac9f49b984so377706a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793794250; x=1794399050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s0ts1uO6r9k6Cw8ocmHrCkTItWA8qEMO4bxVdk6OkTM=;
        b=xNyL5ul82ArXs4N+tw+ABdeAFvLZxk/cZljZRzISFgMBUajeB/wHghkJDQXwMue56U
         M0UgZrCOANKBU7jPBrlyHBMZe5/s91ZMce9nF8tytVYyRtpK0w2vxkEeB8INpnWKIawh
         nzfTw5ReANBI3OKSZJTq9KJsiVu6GcQZ0NeygKyJep8gVwR/QbqD6sQQP9hEqJVsT+zW
         /p3yEAqueFIbb8lp3ffhqLY3gC/X5N2RInnbQvMCRN5cbzd4Dyx99GK+G/0AuulbB/il
         m36hcO4LLa6L+6Bfq3wPo42v9peGusj6/EBrJRjOtTHWkHqU9ji2o6rPhvbOKHztKh/P
         qh+Q==
X-Gm-Message-State: APuU4Z8ziAQbMFr9Jux5HqGJukX2SvhB6ICHmBg2PlttedTUanx0igUe
	u5gO5rxFZc5+5Nhgr4uj1Xiorlrrg3KB5+eKKcokjJLn4ZPKwRpLi81XULXBNNAq2kzUUqWf19T
	tR1vdb2HZ096jz0m79UKfat7vM1Gz45w7g1H5LZ0j8h6eqAO/0fLVfrCKu7klzzqBZrRn7M2mrF
	MwYgkh0voBu5lbOSOVY+yUGlWQd1lKk02k5V3k+mw0s374dkyEkcCpl0f8jeL9TLKi/GgeM9jST
	lp7+h9/hMSrpsU+
X-Gm-Gg: AYBFou3GDEhgj7UQdxPACfXloiqkET3fwwra5vR9NOSCGgM00xKoY0MEqh3yKgzFLrI
	xv56JBB/YjaHCyjyMODEO0RTMKJudXmxQKnDtGNICk8jn6JMlASfu3Fj6z+qI0vEB5oZEeUKa/N
	VyHQFhpvX6SyyAQV+BUedLyPokhFxepuMIyK62MNClwAk9+1Kyy0UiIjMzbrgz/G1heGwteGJQn
	fJbleYbaI2eyqrXh7a8kyBqroCR9K3UnA+x2ChZ7wOBRcSnWyh5OmhV30ZmNzWsL9IOjFqz361F
	rLqVBjYchRZ9WIU4tixrEPA+WyG9E0WpyPJ0rHl++c38vSQJKaL8/AR72jSMn6IidpTwEdBCo4F
	0zyH19LqXEDhJVFlhIWdGlEYSjhNBavc94k/4ZdFYX6d30npComwoDZyi7SujmBClFE3t4SgK+V
	8UQBP+roJUYlPJSrPg3i7VxVqqGEdeeq8C2ms=
X-Received: by 2002:a17:90b:4cd2:b0:3ad:7f4d:2839 with SMTP id 98e67ed59e1d1-3ae896d79ebmr8473461a91.14.1793794250152;
        Wed, 04 Nov 2026 04:10:50 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b094e6bc36sm574983a91.1.2026.11.04.04.10.49
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 04:10:50 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-3425098ae4bso2549012eec.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793794248; x=1794399048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s0ts1uO6r9k6Cw8ocmHrCkTItWA8qEMO4bxVdk6OkTM=;
        b=WLVlmFbB6Ji3zSmCo1ty9p/TpWChaJtx8B6XWXFE/FuK19Eb++rkUHbE9j02rfe0Ku
         nUv21AOJjn8wjHLNRqzJE3QJrowhxyKS4eu+JuOks2/8YClqFtXBoAzNKGnetrtvF+bm
         ZwbsYakOOS0/uKRdnMagfaHj75zNfjk0YkTf0=
X-Received: by 2002:a05:701a:ca8a:b0:1af:194e:8264 with SMTP id a92af1059eb24-1af194e82e0mr19413889c88.22.1793794247849;
        Wed, 04 Nov 2026 04:10:47 -0800 (PST)
X-Received: by 2002:a05:701a:ca8a:b0:1af:194e:8264 with SMTP id a92af1059eb24-1af194e82e0mr19413851c88.22.1793794247026;
        Wed, 04 Nov 2026 04:10:47 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm9377095c88.21.2026.11.04.04.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 04:10:46 -0800 (PST)
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
Subject: [PATCH 17/21] scsi: mpi3mr: Reject a too small reply size when enabling log data
Date: Wed,  4 Nov 2026 17:30:58 +0530
Message-ID: <20261104120103.503871-18-ranjan.kumar@broadcom.com>
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

The log data entry size is computed from the reply frame size that the
firmware reports. If that size is 20 the entry size becomes 0, the buffer
pointer is a zero size pointer, and the next log event or read uses it.
Smaller sizes wrap to a huge entry size.

Refuse to enable log data when the reply frame cannot hold the event
header.

Fixes: f5e6d5a34376 ("scsi: mpi3mr: Add support for driver commands")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=5
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index fb54bd8093da..bf2c8c413a80 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1311,6 +1311,9 @@ static long mpi3mr_enable_logdata(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_logdata_enable logdata_enable;
 
 	if (!mrioc->logdata_buf) {
+		if (mrioc->reply_sz <=
+		    (sizeof(struct mpi3_event_notification_reply) - 4))
+			return -EINVAL;
 		mrioc->logdata_entry_sz =
 		    (mrioc->reply_sz - (sizeof(struct mpi3_event_notification_reply) - 4))
 		    + MPI3MR_BSG_LOGDATA_ENTRY_HEADER_SZ;
-- 
2.47.3

