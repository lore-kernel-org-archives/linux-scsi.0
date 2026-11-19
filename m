Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072821;
	b=bsjWAw0JkCn1Cd5QsDGOEFhli4/hnwAVyE01P0gzj1SWGdKHiltGCxtvoObXwk9kH8oi
	 Tl7sJVDVZ3SCik16q8boMX4lmsedwq6JtQ1oTNP4G8DE0p7rzgtCZRzoHDwKv5fX81oqw
	 kEsLzFEq8uJ735Ww3d/f1o7TrvVqYR55pJWS0N9UmH/FDsT1IJAIU5MFb5kv6BufSATNY
	 YF9FEdFfc1EEKJd3vovW8je98HFwa6D+Wv+Htzhxd5GmLYghAwEdipAUCAJXxGI4xM01D
	 6Yz6R/q2j0JoEUD7/guChr7FH9c8vvH75ypD8rSFAqU3SjFThOdEkWXYlQ3sgUMYSJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072821;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=qmKvrhhPQ8h4Eh1WESAn2LSzvbDGxzKfd/KfAYIKQ/c=;
	b=FsuFuS0CZcJhQrxeCFJ13GrTWlqGnpfp5uinyYon+ew8Hkper1ZkaXD2I9hUICx2o7G2
	 79Qg6k73TkHizK0jS+xo3ad3Lpwg3il4KnleVT4Pw2S/r46Fyv/OfDNCofOtaL40o394v
	 uCIxnw+NJthgcNzMxSbgb3WAckNp+s97jpO4jrRHV5Fu4zNLTFDj/SAFYkNXoqM3KkApQ
	 Y665d0BGQ5OGhiXPrVh5AuhcSgf4j8nCHDIg4Q2PDIbliit+gPF4AerunX2Y6dZ5ZpWW0
	 BrRZl2OK+bqmBCETm0rJ4DrMwIzAn97S7y8i1VutB/iVvDuozo5WNlW2FhmuT1lUgBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=UP7bZLsP;
	arc=none smtp.remote-ip=209.85.214.227
Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9B8606A32C
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 07:20:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED9B8606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=UP7bZLsP
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-2eb18f4da15so8386335ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:20:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795072819; x=1795677619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qmKvrhhPQ8h4Eh1WESAn2LSzvbDGxzKfd/KfAYIKQ/c=;
        b=OeVPlAE2fitOoRef+kEooN9SdkEGoblxtHndal8Iim3SzR8/Q+aWh3LEQCt1qdl20R
         4EOMTMknDR5ohCaOxVpBR4tUuIH46wXm38H6x3E7cUx4FR3tyk18ml/r6dsOFDWU3wkN
         SfY84ZmVWyuYXTcdjhD0ytbca9ergOVdblaJN6f3koz3Mez/ajPw8mWyNanbpUZDz1ZG
         IDApehGqP/s4rSFpQWz302M6V0LvPZzRHwaTcE2a/kxvriK7Xzwi8SQHRoxGOOBweW4t
         +Wh3dxPGng/5EgKEcEnTB4VQDQUspAXZde4unUaVh2ZCh7HzqxXZjgf3ezIkD+yyvu7w
         zahQ==
X-Gm-Message-State: APuU4Z+f1ZozDYqjkHJ4pGrNBzSNwHHcAU2h2vO8zJnmXsjlYhR5ynHa
	K0ldYhTbryiWNyfoUi2FfACGSQnW8gwVmFTjZY9gfR7AHyK8r7b+sJXcZ9+8aIUkAHBAM8ezOMQ
	yQt/iGuCW1AsWV2qWoCs6/y4s2r+ToWFG+H8/1Pc8jv7xgDASskmzMOuHgfVHvoe21LJaOU+cyr
	X3xYeProaFOUN8GnHWlZdUBMTHSkBVBamM+phH7HAquKzGaqPvHcR/0if3NbCYzQzIDWrvDsS9T
	ioqC84vAcI18i2f
X-Gm-Gg: AZFdTZe3ZfJLzh+6cbJCYSBMK0dyjhtGybrnbxPVQRjOhpnQJ0qRiDbEdpNjslcUZYv
	OjhnpyHA5eS/MNj6m0sp6OQ/WTJ5vbxIhbu86c+Y73YoArVCe0es7VpTr3BkRlaYD/Mx15aH3XQ
	D8/ep0RmC8qLS90ouGeea1UfMmybWXSma4PPFs7p7wU+ABZ+WdQtP1X4P4hbUdBYTlbx1Z7LXZY
	zZQFOApe9ODst6UADjUxI1QvVibSQ8FFh2lqzaI2b1X3vH75zjSqemszgAv5+CJIgb3VXP3Qzqp
	WxqjK5/2c9XqT/CCMiiq92JY5XFohGjuZm8DfrlCl6wvWiBhhhSQJdEBw2t8FhMg0iMejo4Kwpu
	Zm622idf7zJPV2SQhI2MegywNezuWNlK7GlqMhlg2EP8xIqxgUZdakglK0PmC7hnjZDIlOkfhsg
	CdyDl9ByX3EdH36IXJKf7wJckyIDpkKXmPde4=
X-Received: by 2002:a17:90b:2642:b0:3b0:9984:18c9 with SMTP id 98e67ed59e1d1-3b3d0763288mr4665414a91.11.1795072818969;
        Wed, 18 Nov 2026 23:20:18 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b4062a77f5sm461978a91.6.2026.11.18.23.20.18
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 23:20:18 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3b3c459a35eso1976169a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795072817; x=1795677617; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qmKvrhhPQ8h4Eh1WESAn2LSzvbDGxzKfd/KfAYIKQ/c=;
        b=UP7bZLsPur7MOazTLMYLSA1zU0RuS50I4lT4LSXXA2GFgJHJjrB20Y9Dnc7KNfHz2M
         G1Lkj7XMDHijZulkrTzSqO/w+oUzY5gby5qRfFZS0H02zrFNuscYVtEIGwL9WSFHs6w7
         fIk9fqxm3j0KYWjhhwS49lf2LUXsoJoki4mgY=
X-Received: by 2002:a17:90b:4c0a:b0:3b3:c998:6d6e with SMTP id 98e67ed59e1d1-3b3d07c68a0mr5599032a91.37.1795072816935;
        Wed, 18 Nov 2026 23:20:16 -0800 (PST)
X-Received: by 2002:a17:90b:4c0a:b0:3b3:c998:6d6e with SMTP id 98e67ed59e1d1-3b3d07c68a0mr5599002a91.37.1795072816208;
        Wed, 18 Nov 2026 23:20:16 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402981814sm748560a91.2.2026.11.18.23.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 23:20:15 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v2 20/20] scsi: mpi3mr: Use the correct conversion for the diag buffer post request
Date: Thu, 19 Nov 2026 12:41:32 +0530
Message-ID: <20261119071133.127282-21-ranjan.kumar@broadcom.com>
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

The diag buffer post request is filled in with le64_to_cpu and le32_to_cpu
where cpu_to_le64 and cpu_to_le32 are meant. Both swap bytes the same way,
so the result does not change, but sparse reports the wrong direction.

Use the helpers that match the direction.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 3937647778e9..121cf5ece518 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -266,8 +266,8 @@ int mpi3mr_issue_diag_buf_post(struct mpi3mr_ioc *mrioc,
 	diag_buf_post_req.host_tag = cpu_to_le16(MPI3MR_HOSTTAG_INITCMDS);
 	diag_buf_post_req.function = MPI3_FUNCTION_DIAG_BUFFER_POST;
 	diag_buf_post_req.type = diag_buffer->type;
-	diag_buf_post_req.address = le64_to_cpu(diag_buffer->dma_addr);
-	diag_buf_post_req.length = le32_to_cpu(diag_buffer->size);
+	diag_buf_post_req.address = cpu_to_le64(diag_buffer->dma_addr);
+	diag_buf_post_req.length = cpu_to_le32(diag_buffer->size);
 
 	if (diag_buffer->is_segmented)
 		diag_buf_post_req.msg_flags |= MPI3_DIAG_BUFFER_POST_MSGFLAGS_SEGMENTED;
-- 
2.47.3

