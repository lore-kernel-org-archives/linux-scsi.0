Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793794231;
	b=pw8fig454iFkNu17G3gmPpQb1kHVw9KKV2nHS3YAEu+gDiQwoFxe7x55jDK9EiZC8uIG
	 Z+kc005hwjc4t2wObeuaPor4n1jJjnB6oIHVufBhgvuQWuDruTho4lDvEWnuNBgGroZOL
	 c/PExmpLqJTaouNQ0NS5y9WrSZNM9QIyYYR5NAquxK/UKueTFCtxGTNCmKsaVQStV86dn
	 Odt30XXZFPoMoYOhWSacxT0wnBWjQCrPXFhJAsf+wDsQGU1TPqDUuQavJhbBSastoPU1I
	 oCnE/Ft4bHsFXEz/mEPNCJFkBwg5NIa0CbkbvHmVOt6fJsVcjc3484afWFMHqlxa/8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793794231;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=Yl4Aud4+nI01JJE7OATDLhNZN7IHI7ouTIMUBxeFQtg=;
	b=48/9fg+s7wxFR1eCrumLuoGW+AwF7gkULopai0EEA0lXa12tRGoVx17f6UGJi3mJrdkX
	 kjyJpBMBcDo1e0sK4dhhvKJ2yFxmz5kTnPcL3f+bXr9l6IMeXJ51DF5lm6IwCrph7dLQ8
	 jo41VCXziJk/YYxAFfTs+XxVaEr/+bMKC1NHmTwQXh16gxQNJPnpeaRPfTpVocnnGsPOl
	 jDn/Bqxv9U1ZOm58y6Aisn/oiLVPKQp413n8NiIazBQtu1/6tyDhSoJ559GVgKe1IFxvk
	 zFQSEXXRhtEZxsXZWf+tiI6KNfewUC9QnrRTXm824vZ3ZVL5MfM1z+U7ORvBUR9op8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=YIIHndjh;
	arc=none smtp.remote-ip=209.85.216.97
Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F169E606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:10:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F169E606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=YIIHndjh
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-3b08a162d4bso494070a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793794230; x=1794399030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yl4Aud4+nI01JJE7OATDLhNZN7IHI7ouTIMUBxeFQtg=;
        b=NexX+snPeNa4INhQpKn53mczjJbUWAs1sbXcKRivRks5SEi926Ky71nZ3+RB0R5Q5K
         ooGV0XReCeb1hCHjBT1PjZ2qJ4shZnZ/i/2b/dhezky3GB3pRlb68a9N9VCyUO2bcQJY
         jb/nTlGDLyVgI8Qrn4KGxvxy8oTQc2zHvrxjAaC1P09Fx5xzj4UQiVIChgNGpCTEny9C
         rI0S08zZ0bUQy1gBOmuLdVHRMJ4Z4DTDE+QKeWmEAlnGX6IC3daHN7CdDrDzT6gy87qZ
         9vX9ym0Hv9yOVmrokn0br4z+Fv67n0mkEGeeG3Lk8la8TpHLLTlmY7trtg5euikYwFMp
         ViqA==
X-Gm-Message-State: APuU4Z+PEMCQKFNyY8+c3n5Rs3f4bu/MJUuGscXPvZ1ZuPFWA6IkLwq+
	KoYKpeOfCeXKhYo6hU4NFBSRVUJxZf4l+rjuL51o+gUNLFOaqpowfEk5XuAIIm3/K0rthcqaTrD
	r8NvAJLuSw769ZiKEuVDBcBF79ufPxOzAXc1gaRPOtTvPYHtbC9/f5C5eI2w4L1hGS7cloj13y8
	CpNM4PE4X3Wym5nVu0NwpQzOIEQjbE7HHjji5FncQOCjkO1hss249kk9R5PaRhgy1eusHHd8BHt
	Oq6xX9v+Iov0jAY
X-Gm-Gg: AYBFou1VUnZPzQGLmcI5JpRQdEuxiGvIBswtE8uu/1X+7di7wyNrmadqHGwTFyVls6E
	Q8LWJroSJlflH6hTN+aQL0czzyGV1EGNvzOj7GNsJZ8Pytdbpg6J1VePYE8pOo5qZZhkineKK1D
	Gj5sXU+/IXuu3RsJ/FPfFx+mj9bQndRZ13MXoCqnt8TM47kBsncGK+S4dZVB4RADEjBr+NjK7C+
	tUHRodKu2qlC+BSDKmMEu1hxd035jFcMmlqPiE4QPmmVtg8vA8QLL8g2YNQN8aOjXvbSFDz6RVk
	f22ujOZfDhE9fWfXG+AgtPInsb4FNsBDx1dSxCMre9HVKPFYqYirqeqoOw4cil7VBpVJXREyfrU
	M9awxZ7thvVjwdSVLaGInQxdQwGOIyIebQYLaxdWWS1wknNLDZkpoZYXTkbS/mMzfOss/J2YTnS
	6tbSTUXWqs2dxOJgrcoQolq6tGhbqmF7OCFBA=
X-Received: by 2002:a17:90b:5844:b0:3aa:548f:eb77 with SMTP id 98e67ed59e1d1-3ae8985b789mr14054935a91.56.1793794230153;
        Wed, 04 Nov 2026 04:10:30 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b094da9182sm698023a91.1.2026.11.04.04.10.29
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 04:10:30 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-36a1e2485fdso1220959eec.1
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793794228; x=1794399028; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yl4Aud4+nI01JJE7OATDLhNZN7IHI7ouTIMUBxeFQtg=;
        b=YIIHndjhf0LdBli5r/987U2YZh/eS6HLx4bvC6uO7tLfc44aRndRoZ08N1UFPAtRXT
         CpKdKS7xUvtlTDg1cLl9r8APcEVpTOkLHS3mmwEcylMEcLfHU1WVbp1tJj4SvyV46ZGq
         PPwZRu8DHnllgivCCpCBaJzMcChW7QmxjElSQ=
X-Received: by 2002:a05:7022:f105:b0:141:5281:8a41 with SMTP id a92af1059eb24-1ac5a2a3112mr18057816c88.9.1793794228147;
        Wed, 04 Nov 2026 04:10:28 -0800 (PST)
X-Received: by 2002:a05:7022:f105:b0:141:5281:8a41 with SMTP id a92af1059eb24-1ac5a2a3112mr18057787c88.9.1793794227187;
        Wed, 04 Nov 2026 04:10:27 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm9377095c88.21.2026.11.04.04.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 04:10:26 -0800 (PST)
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
Subject: [PATCH 12/21] scsi: mpi3mr: Fix empty device list race in the all targets query
Date: Wed,  4 Nov 2026 17:30:53 +0530
Message-ID: <20261104120103.503871-13-ranjan.kumar@broadcom.com>
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

The number of target devices is counted under the target lock but the list
is tested for emptiness later without it. If the devices go away in
between, the user is given a count with no device list.

Decide from the count that was taken under the lock.

Fixes: f5e6d5a34376 ("scsi: mpi3mr: Add support for driver commands")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=13
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index bd105efdd9cb..db27bff58c27 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1499,7 +1499,7 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 
 	if ((job->request_payload.payload_len <= sizeof(u64)) ||
-		list_empty(&mrioc->tgtdev_list)) {
+		!num_devices) {
 		sg_copy_from_buffer(job->request_payload.sg_list,
 				    job->request_payload.sg_cnt,
 				    &num_devices, sizeof(num_devices));
-- 
2.47.3

