Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996744;
	b=zxWkawnhk72dW1Ta4mm5LsGbgztoqPmzmLFI+eGsr59BcxpxPWHMiebYqqAiKsov2I6q
	 b1OH7G4X4BWQJfP9dpK41aV5ihp7/XblLg8XzBzj2/jNnZwNXo0SBL90+sElN4SQHEVN7
	 rl//UmnUx06ju3SCEI1KcphH65xpp7Kxp+gzHj2c22xQRx4z0eD7U8tl0ZEtXfyTSSFfq
	 CIyf5pAHeO4g5zU2sGr4KUxuNm3AvsEKIuP/0roitTGAv3Y0qYWagNjKpIFJjn10cn1UN
	 B0PprHmbjR+HMG/bOZzB9rtNTyMAL7FI8128jUn3V9qLma2aosXLNOXJkDNcVSL9/kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996744;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=R3w5BnXRfp1BkKT2SC4/1on8kgV+rGChlpaT00YnZ4o=;
	b=rQPd0ppY99EGSjXvWTezoeS4fYtcQTjZx29ot5RR6OqeQKr0z963/+Jhfu0JpLecJi51
	 58x5n9lEsEMH50g95FQo0AhaQrkuMfgpX6FjnD68EDYYTs6NM1MxUTs7ardZvcot39MUr
	 q5d9zrC2R0vavGk8hkCVirlTEXBvPGFr1WaGdkd9Te9f20bRaJD1LqJPf+/RZkma2rjgl
	 mOvljoumFK71+zWQ6WboHz3S7yv2t+wQ7VjBO+p+bwVQekjjUz5HfoE29dm95ClX/d+P8
	 Qkahvzm9HMH+KO/LV9g6bBsiGqRzroGDTdkkjTv7XEUbq0kAsxjVhwl3FU7fgmTHDaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=ZySsIttP;
	arc=none smtp.remote-ip=209.85.222.225
Received: from mail-qk1-f225.google.com (mail-qk1-f225.google.com [209.85.222.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2673606A325
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:12:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2673606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=ZySsIttP
Received: by mail-qk1-f225.google.com with SMTP id af79cd13be357-94961ed97bcso100868785a.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996743; x=1795601543;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R3w5BnXRfp1BkKT2SC4/1on8kgV+rGChlpaT00YnZ4o=;
        b=jOa5wobvJRXs0bNigcUMScgXz/LxPtpQrPseQ1nib0ySuz18z3Obu2xFRBLqdpKVJV
         mz3vYO+m6yolhJ8AXVoA0qt2b9e2BzRpXm/slW2lLf2cffuQaRJipTDsvWBxuCMDuMwj
         OTqR1ft8dClcAVwTuaNOkE2YyVHDMqbbI+Y+OnX4jP2bpc+L7l+MfR70tUVXGAD18/88
         vbkmYSjaO+MHMc24NrTA71F+Ruo4T87FMyvM/gIVI7mcoH8Ut6a8frnpnhILL4MXSj1S
         247NTGxlybBii1PpctmUrzQLDYI5eHK3sQsXlKrrqzyegA4JyLdXPaqtC6B1yyuozAmj
         temQ==
X-Gm-Message-State: APuU4Z/EElNn/FcZubU7ZLHFKOeQHY8x/Q/seG/2EmJK3B2Wk+uBeIbz
	1+bcR/4QH5nRct+ovMJ92wzsaJ/Aq7fn0yKRJfVudjKHJHzd6vHBHuOw0kvyRXZDzoye9XfnAE7
	dpJy+x/mlN1ooKgTBwtI/KV3fA9hUdLoWvrZZ6VW/aZUxy27AIam/+XnhbgE+mOmEkipjouJKYU
	VRBx8mED+tILAjvJFAQlfjUqeiHlGxWEyUIokncSNsVQSDP6qXMNyWB6lBcBHj5qnx24BDR6nmu
	oYxPDkfG/vTaS8E/UvVjaCOT6DVfqMlyQM=
X-Gm-Gg: AYBFou3rw0iRb2aBlRgy5KqarqvndlErtAziJm2wcbBNyc3HCdF01xesksInwRmM5FI
	3B2dY9nBtw07893eYlQrHk9L8vW8nQAtvTjKv0kBuI/FS/nAGdfgZflckenEm8XbPpUjKrBCCp0
	yM7ggFqamMx6vmVDDJJuFQEDatvwpKeRgMzpu0+XkpFhqNkSf5o7ytIbt55yTtZD7oVt4HhaFud
	58T5VTAWQHz4DmbqvXPKHQPwGWq0P+MZWErYZ5QRXnNqenPhwc36bsiZ3St1sd1J/xDIjbttDRS
	hzmrtAXuMMoM+6t3BPB7JuRDPF4sNwz0jQfm3ZkjFK/TidecKGa+QsnmKbzfOJSDDKgUkQTKLpS
	oGDe0Z+a5mJZrqeQKE+z1+21AubzzYr8/uQToo0031SUxY02tUAhGbBzu/p+DTgUqu2qzWdHrE4
	zgGt7XPs3m2LIREX+3xPasMNbBft9AZ9I1qDJH8E4rr6Tj9Td0u8orgQ==
X-Received: by 2002:a05:620a:6c8a:b0:93e:c6ff:b787 with SMTP id af79cd13be357-94999721fdfmr358007885a.13.1794996742860;
        Wed, 18 Nov 2026 02:12:22 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-9499b52cbf0sm12686185a.17.2026.11.18.02.12.22
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:22 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3b3b0ebd98cso831886a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996741; x=1795601541; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=R3w5BnXRfp1BkKT2SC4/1on8kgV+rGChlpaT00YnZ4o=;
        b=ZySsIttP9E5gZD/0G2hxR8Oe2aEaO6xsbfkLbQl2uIzZ0FYiz+D3ZD9z6lDLkGcZgf
         3Ztb0X7IO2D/3ZwYDd4rZqkbIJ4rUhJFQ3clPI03nAJhUg7Ft2yXqiy3wlQ2khiYE/nr
         8NlxseYdUriG6RA5dWUKJAr9y+GV8M+d6AKio=
X-Received: by 2002:a17:90b:4fc6:b0:3ac:7e3a:1033 with SMTP id 98e67ed59e1d1-3b3d07d9ff7mr2399156a91.59.1794996741638;
        Wed, 18 Nov 2026 02:12:21 -0800 (PST)
X-Received: by 2002:a17:90b:4fc6:b0:3ac:7e3a:1033 with SMTP id 98e67ed59e1d1-3b3d07d9ff7mr2399120a91.59.1794996741121;
        Wed, 18 Nov 2026 02:12:21 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.12.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:20 -0800 (PST)
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
Subject: [PATCH v2 07/37] scsi: mpt3sas: Validate SMP request/response length in bsg handler
Date: Wed, 18 Nov 2026 01:56:16 -0800
Message-Id: <1794995806-5835-8-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Reject SMP requests whose mapped request or response buffer is
smaller than 4 bytes, avoiding a length underflow when building the
SGE.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index e74a526efa8d..b03422fe86fb 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -2095,6 +2095,13 @@ _transport_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 	if (rc)
 		goto unmap_out;
 
+	if (dma_len_out <= 4 || dma_len_in <= 4) {
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

