Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793794267;
	b=sa8QwvROueVPo3mbNfxEipoYImz9p9d7Nb/ipdGvVLMWCytH8E0jQJ7gXaXAHIHACnBw
	 XGYygtcvh7BCWjNXNACy+rysKKr97qXiGEZG1cMT6MT4Pogfg3XC+eZ/4GL4N9uDmFkyD
	 MvgSCYLNcLEaxRVXHCBwftB9ZSLsqDuE+Cdq/Qh9YWrbbEuaHejHuQ4Ocihl4CXKAQhVS
	 tyzpOUSZInCnwAj+7qgjXelVxn9H1OK5b2vheKLujUkUh93Sc/z+DWY1chIjonStj6x8k
	 qJJoMTRH//L5OIQ+3xCHXO5XNhcSMhRfnPzTUf9mzKRn9GwWzOKmxfqq2YdYO9NiWWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793794267;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=0hiz7PU5TjwG1X9hXrb5wkr6rJYnq4Oaw7ub9l8aGpQ=;
	b=Q+CAZQ0dvevS1pDaa3lOP5xDEJJlhncIb/lEuwoQksvxfckMwbjxRHDDMzZO677JvDQ3
	 E7o6CN928uLbB3p+gK8LvWkToF2D+UJYkr6uf1s0aU0BxcPkAsZalFksx9Z2UScVtjzWK
	 209attSQDiMrKQxAHEPc6rzMFcABZK3FK0FIKa1i2+EDNcW7BJ4l13EZ/ZX0wr3BVm/6K
	 cr/IQme9WdWHjMfemSqVpC0s/TKl5hwSrVknWboNa4gOv8Jk4hctM+iXxfw1nXBklPO7F
	 dF8NLQNSaBit8niU3jdD8s3HYzmdIfKr/WcOJIM9x+vY12JeJbaLuVEWtLZNPHbUk/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=GUJuZbjY;
	arc=none smtp.remote-ip=209.85.216.99
Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012CF606A32F
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:11:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 012CF606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=GUJuZbjY
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-3b0a0d19a60so189426a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:11:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793794266; x=1794399066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0hiz7PU5TjwG1X9hXrb5wkr6rJYnq4Oaw7ub9l8aGpQ=;
        b=zwyQ4infebzgEUsB8e7T8LAUIEi2ZKi3MOWEaPaUPgQo/Kwh1/Gm5LrLA/XdTi0v95
         nbvgtvtSrjNRGNyR/bR1SDtXbUnJDiX8SHGqyMQaH+lmJ+rZuRFm4L7f/2rYLRvlJoSf
         8C0hQNBVjHf4Xe13+yMA0NBIyJxXy+32BBZCikUsmDED0ZTc5rcm6aQt08sj4fEEDczs
         iJolGQ524II2QrVmLxduvMyWX2bF1WyVLBbrevZ+YJlKudtCi0/9W3gwCTUrMtMIlzZ8
         rhDDbKdcSbeH757UHKxtwTxXF2Hh5c7O3qn6WAiiBtPB0N8cW/sxYBZZpjjI/+sQYu43
         E+7g==
X-Gm-Message-State: APuU4Z+EV0+JqyXmqBt13vHdHBenZfuW/2sUOS/1qgGtLTW/+b2CWYtj
	FGtaAOy4rVS1sInayzop46edxJVh4l3qcwE1O2hzcCPGoFEZzBUUyht8KyjBG8E9ZSn2t7s8D9J
	8Zi9hPeaWinpAv6d5+Rij5d0OZIaLxSjnqzrvjK3NHhbi8S+8gCt468ngAJirDMG+2sVxXpcm6N
	mj20h7V6EkyKDlX2YAnwezw9Bj8Kb/u0SqAnUWcbF9TcqZhhS2SoJa6Xo5Dsa16q9Mp1ta1BSCR
	srdPnFPAgofAsmw
X-Gm-Gg: AYBFou1WzudACO4R6BtIngkG+Z0FTw7W6KI2l8WWehYfVB9pyFbkt90cvc53E3fUeNE
	x52qa5pF8veXBPsP4t/j/ExlrXws5r6KO+3imiLb2+qjWfrKcuC80ce7QmVPhLYW8VM5Q1PXEaE
	5ez0IBbb9swaIDSWwZK5YeYE+jO0mGCYuQvntwFf/pJptXvNDvE/8085qSK9WLebxF5Zj6VMxVL
	XP0hUK7GSnsdZLAp3DWCqCERAJMvgbLLeweLX0SDKt36D+1ClvOE8LHCqqU8C4N+pmCi8tZFGDP
	PgJkYPvl0rBzgFyzfaIvHzITNmoPj6O1yWFInD807mhpc8ZPy1ieTz0Iw45Jy05YSgjsCTRwtoU
	TCGJqnCNBhhGErCsJeHbtPBQa8djo7oJrBeq/hZLn2xnPoe5IM+TaF3lj2dSnLfaaSXM+uYBmrX
	KvCKhipF11JHm+bU2OGBlkd/bNYr2zwZk9MEU=
X-Received: by 2002:a17:90b:184c:b0:3ac:452b:4a63 with SMTP id 98e67ed59e1d1-3ae897c4ea4mr12536732a91.55.1793794266178;
        Wed, 04 Nov 2026 04:11:06 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b0946671b4sm1645496a91.5.2026.11.04.04.11.05
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 04:11:06 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-139b62317d0so497791c88.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793794264; x=1794399064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0hiz7PU5TjwG1X9hXrb5wkr6rJYnq4Oaw7ub9l8aGpQ=;
        b=GUJuZbjYy0u6AlqQbkE2nKkRraOTT2Cl+Wj1Q94uX2MVYNOl9A7NXN2zCWitOdl43s
         T0Kapx6FvKmCBcQCGT/LS/k18ZxDYfzW7HagoLSFKbmuNn2ZTwQV9yA/dLBGmX/BFwG0
         iwg01Ioft4z7XjGg64DfS0maOvjfjiLCW2dYg=
X-Received: by 2002:a05:701b:4208:10b0:1a3:116:848a with SMTP id a92af1059eb24-1ac5de5424dmr23681291c88.35.1793794264189;
        Wed, 04 Nov 2026 04:11:04 -0800 (PST)
X-Received: by 2002:a05:701b:4208:10b0:1a3:116:848a with SMTP id a92af1059eb24-1ac5de5424dmr23681251c88.35.1793794263297;
        Wed, 04 Nov 2026 04:11:03 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm9377095c88.21.2026.11.04.04.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 04:11:02 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH 21/21] scsi: mpi3mr: Use the correct conversion for the diag buffer post request
Date: Wed,  4 Nov 2026 17:31:02 +0530
Message-ID: <20261104120103.503871-22-ranjan.kumar@broadcom.com>
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

The diag buffer post request is filled in with le64_to_cpu and le32_to_cpu
where cpu_to_le64 and cpu_to_le32 are meant. Both swap bytes the same way,
so the result does not change, but sparse reports the wrong direction.

Use the helpers that match the direction.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index e38208241707..792c34ab5bdf 100644
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

