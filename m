Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072765;
	b=YBho3/5wvticul9qxWz/2l83V+PdLONFlihQ3aP9066AFbFAaLrXKGA1ePCCJ7i41CVm
	 d6iQcuhEt83s6hsfngjyojikSzD8YvxJAK9hST6dP5VqBnqK+W1Pzguw63Hn5A8gPJzXJ
	 rr2ZLutOYWdjEm7eAj3PuFbyGYJiv1PIS+55Mg5rqga41CxNUD9o+qfx00Cq+MkWuTLqn
	 nZG0RryXnd8i7Gj+lotylV4TZijKmP7W6K3nssPxHHThTJMEvDNeKYulrCQ3B6hOK0aob
	 hymMp8W54bke/WbrXFRLgrwHNJXHmWnExJFaX6JcPdqacABA0L/461oxelAkvSLZCBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072765;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=1rFGev2MK+/6P1u104TnEw4yef0uRLxw/k6IqH9SfO4=;
	b=3QFOeTTMr/ePOtH6+RirY0+weAn4se2PThKtBnbVJ1sKTzMweQxicuMk+fO82JHtmfSB
	 VNrcgcS3Ty889tzBwbQqA+4s914Sy0RzLpe4VAI0xLMvZD3NVh2nqMqVf2fEgI9ppUybW
	 bSXffpNh4QycWKmeY99VyOWBLZdycB9t35e+m1sE4iwyCbMxDbvCbNPnGZL+0Ry/slS6N
	 vslWCA72l1fTEnEUDbbC0MHCGJsnirR52ytTmZoKLQxlYJqeCTx0KlFDdapkrgurnPtZU
	 9S36LGvPZ3PswlpbfPM9h2P0ABnfyVxT50UErdHGETAVo1kZjJcX37VtM1MajcQcsNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=WxiQwrJM;
	arc=none smtp.remote-ip=209.85.215.228
Received: from mail-pg1-f228.google.com (mail-pg1-f228.google.com [209.85.215.228])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547E8606A32F
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 07:19:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 547E8606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=WxiQwrJM
Received: by mail-pg1-f228.google.com with SMTP id 41be03b00d2f7-cd6028ff33fso1341777a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795072765; x=1795677565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1rFGev2MK+/6P1u104TnEw4yef0uRLxw/k6IqH9SfO4=;
        b=ZNJfqZ5C08qYztB4N+81sTsF1Il0Ojc6KzjbXS/fpAHpHfsx045/m1vYqsMQbabVoD
         xhEPB10LU2sJZpSH8HySld5HXjP5Ra6Ga8TX9EnoAQVvGKZjzEyU50UaWcYYKnxtuAH3
         QuqGQbecOG9HxwvmpAniQjn2PnjR8e1VvdHP8Y1bZeOCiuSXub5LN0JrQNZu7k3RMJ76
         ihEs4W9w2xdttgqYqZ/CsUcOZmgv5Pry/TPg/0xy5IyGMhPRjaJHCqyuiM3aiQnk9EMo
         5dMxtQ5dc4KcdCeBfGUDz++G2FkFKDTnejpJqw52qXt9DGYFDZNpGHVqyJutXIeeyu4o
         u7sg==
X-Gm-Message-State: APuU4Z/avAmJmVDPh2XvQK0N3BMllVz0QpLR9zjTUiiAnEOJc1H6VJ2q
	eyUgfV8kZya2kBg3sli5Hurk2mDeajf+RNVXl3xvRdkU+fTISrikHWAsoWQJWOvQ9y+DKCN5PbQ
	lqqM/bs2afJ0CJVzPsth6SzbzNRHRGntv2ezIPvHFAyzrX56evHDOBOzdBaBJg8k1NKB2l5Orn3
	+J7YQYvQWQ1kl+LCNmqK2muLW+yHvt1ugrhfM+t6UYDNBhQRlThUBaWT7i3y0EXjJdGfcKrbSNd
	SSyuSTklu43yG8D
X-Gm-Gg: AZFdTZdrt+IHZw66nbT3pbRnS/ylz4NpFNotNjbfA9OccpksSHeadHPr0r+aMuUgyBa
	jBok3Y381xDC1fwsaAMgXzJ5YQwb4QhRd40n4mcIfibOFjw5QzvuBJS1bbvjYIN68JOywYX3LvE
	WQnLxOT8fEpmRTcXTIVO9smDJml9qEu/p9fXxAOW2kkHf3iNckdjMvqTnmVk7o9YeQxIFiDfCGa
	wJ8Sy7W0KnTuLmwc0WynnSgIZN9e/njChZx7QZXx1UYrIDCdNE9fu9mYGSCHyQYu/ddJFR70lQ0
	tJozJTZ6QNzNyJwIw3odSxFwDH5jaRzX2Oj5qP70P2Hj0GXv2TOZQFpcYglhmC8VcD8pgOJIBzo
	TZrTp5/76OYd53ghZHu9D81NOJGTLooGMdOmZiV/vN1MEnpr9hq8bDlmWJuTWMDiu/+6CYoPG6n
	4K2/myH22FSJw2362AzhKwW3s3n4FCeSwOsTKEaA==
X-Received: by 2002:a17:90b:4b12:b0:3b3:ce10:7659 with SMTP id 98e67ed59e1d1-3b3d06a51f0mr5109380a91.5.1795072764563;
        Wed, 18 Nov 2026 23:19:24 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b40266feddsm378804a91.1.2026.11.18.23.19.24
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 23:19:24 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc7361c62b9so1380699a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795072763; x=1795677563; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1rFGev2MK+/6P1u104TnEw4yef0uRLxw/k6IqH9SfO4=;
        b=WxiQwrJMtcicn26IGHRnAzrJBsSYbqtf46CibHa+GJ8rO+tPpky5j6OkMH3M7tCD7I
         wdN/wG8DqTnXPYK2HS95jFD8L8EE/2jboia7tzwU+L18RYpsrNaaII03BjaC26sRUk4U
         j5+gYwOb+oF0QhBpMDaYxY6G25Yz5JE3MOL9E=
X-Received: by 2002:a17:90a:da8b:b0:3b0:a831:5acc with SMTP id 98e67ed59e1d1-3b3d07d4347mr4377282a91.42.1795072762592;
        Wed, 18 Nov 2026 23:19:22 -0800 (PST)
X-Received: by 2002:a17:90a:da8b:b0:3b0:a831:5acc with SMTP id 98e67ed59e1d1-3b3d07d4347mr4377258a91.42.1795072761993;
        Wed, 18 Nov 2026 23:19:21 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402981814sm748560a91.2.2026.11.18.23.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 23:19:21 -0800 (PST)
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
Subject: [PATCH v2 05/20] scsi: mpi3mr: Fix reposting of invalid reply address on the admin queue
Date: Thu, 19 Nov 2026 12:41:17 +0530
Message-ID: <20261119071133.127282-6-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261119071133.127282-1-ranjan.kumar@broadcom.com>
References: <20261119071133.127282-1-ranjan.kumar@broadcom.com>
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

An admin reply whose reply frame address is not one of the driver's reply
buffers is still reposted to the hardware reply free queue. Clear the
address when the lookup fails so it is not reposted, as the operational
reply queues already do.

Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=7
Closes: https://sashiko.dev/#/patchset/20260805110634.346670-1-ranjan.kumar@broadcom.com?part=5
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index f0d3cd398dd0..eb3f41f50649 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -402,8 +402,15 @@ static void mpi3mr_process_admin_reply_desc(struct mpi3mr_ioc *mrioc,
 		addr_desc = (struct mpi3_address_reply_descriptor *)reply_desc;
 		*reply_dma = le64_to_cpu(addr_desc->reply_frame_address);
 		def_reply = mpi3mr_get_reply_virt_addr(mrioc, *reply_dma);
-		if (!def_reply)
+		if (!def_reply) {
+			ioc_err(mrioc, "def_reply is NULL, invalid reply_frame_address\n");
+			/*
+			 * Do not let the caller repost an address that
+			 * failed virt-addr lookup back to the hardware.
+			 */
+			*reply_dma = 0;
 			goto out;
+		}
 		host_tag = le16_to_cpu(def_reply->host_tag);
 		ioc_status = le16_to_cpu(def_reply->ioc_status);
 		if (ioc_status &
-- 
2.47.3

