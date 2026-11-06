Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926755;
	b=OQZOrC7hsLy2hGEoIamdKwUNDHjkqyNG8QlCGTtsAYm4Bc+Dv5fpfhaC+gwPEXhWrSJC
	 vHQloMYcWEWcxZDGUUxgXZqA01xH8TKIWZ8IKJR/JM9/9ZAtas/t8X+NHKhF/W/4N8GRx
	 2pUl8b2IdGZcbDoi3S6phWQNzGhEP/2GAqIw4CqDetno/yK4223btN7YN0SQsEDG2WTWA
	 Jal46rQg9OLavIqOmINpsPBektsx7pMeMqhjJpfVrT1bpyqMe7vSCbJTdVj4Le6/RIbW1
	 sBmnsKId3CZf3nzt8Dd6LDiWW/iaXfM3I67HDM7rJ3p+Z2XVhSKX0mq2eRxpv90nPCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926755;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=fLUSVRPwkmUTUAgq80PahC96btJ6jADokyfUrfGOvrA=;
	b=zCCK3TbKmwvqc6emLbpqVhIiDoSvh+55lhwDTEolx0ZbN8Tu1DKIl98J+yiL6HitqTaV
	 IG1bx8y54ekcQkJijkzPi6dSJhYes7uYkD4KR8ghfv+lVa4/kziM9DqEiPIVsog3nduhy
	 3pSz5QgKGaLwlyWhlz2ETS6YXavHgqj6A7jJQgQDpSqoTtT5wZ4pouHYGUbYL1jNKetYA
	 6CWz/58tajPBD4dmBjcgza88v5TZMkWfie4DtBJFMbe6cQsaMD9UNyRFPrkfuFqQkD9+M
	 MxTtAZlJ4P2xg0b07DFKNXblt2jrGCujJITjNcTPUjtgb0ryii5NB62iUVRwX9mPF+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=VOnDeGiC;
	arc=none smtp.remote-ip=209.85.216.100
Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD74606A326
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:59:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DAD74606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=VOnDeGiC
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-3b09c07b3d2so71096a91.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926754; x=1794531554;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fLUSVRPwkmUTUAgq80PahC96btJ6jADokyfUrfGOvrA=;
        b=ISldIT7787wN7MB5U032dxlBWuB8D8X2nfij2Lhemi6+XCi4/l32DYVWKTqri1oM9Y
         7X0TYV38/FMq29NnkmOAoi7g6HV6ft4cEANEKWeBwAC0Ty4AJeDKVJC2PFGTYflPmiHu
         8PKdvkvPNaVoN9WD1t0LxGW1i5yh5vaYi9QTIdTI6Wb4mxRde2GGhcnu5ZYdo7Nl8lIv
         M1hV5kbhXuErt4SEj3Ek7NcGzGEBtDIdcLy7N3Ee462S+2eY1tpsy0hmX3gIQbDW9gRF
         bMAxOmvfdD/SCrxBlUhSDXFMWSI8S1CF7euhNdWddwudvedbsqp9uEYme0rqVITnWKGT
         q29A==
X-Gm-Message-State: APuU4Z/axRwkGvXLyB3ZJCxd4EDrEODHnqotxVc8Wo5lzd3y8LqMelZh
	rDcktAtz1qGUkQLsPXV27t8q7wQ9W6iL9kve1/fFlwE0UvFXji64RInvlZDr+54EvAGaQMz8LIA
	WPsnsFuJev/vOcFt+wh6BnojBA5qk/yySqNnfsZeyr09jW0YgIr0AVTKJAQQ644hq+0JCaTqbLO
	PygOHcjzAhEFEsR7n4I3YYM5UxVQHCd7cB1v8tTh1zGSG6HEiVAsSxZr4l5kpJJndhDD4okfOnK
	1rVge57eju/Jzt6wNwcTU9qwL5sbyHlAeg=
X-Gm-Gg: AYBFou3jTlwS9sXohkvWN+zfsVtihakbkZhdItp2C7Vixv0ruYCshE9yWA4kFRWbARL
	BdPi5J6Mvvztcl4ojLH4MHp0xT/gIUdlUrL/tPfQTIRjUAMVlVjlCqjMJjC11Hj4IwzWdqR4KQI
	b+gr2uyQmZvBwXVi/lkKM9vEv3ODP+6lBM0Jt7uowECrUtr0FV0zavNu6R/J8SBAPlcv//gr7WV
	/5WTrnZ1nnKiVuo+IIGtuGPh4+rFRCpAc0AJA766E/y3UzV0q9oUiovB+ynRTTg4Y7XmYFdhrJO
	eHFB9Y37LsJQEGQH7BjJ201CQPiT3sbMhmdgbMbyaLectSD0kWfxRNbAmBQc6tJ3GAemvBHJC/8
	w+tFa3JpxYVo/01O6b9QMGCTAL1DF8D1N5LgIYZkWO/I9AjoHYQv1Ie/MYFAzdN6VoCr121lBpb
	GRB9K6ySRBz64QBubW1b6rTSd/fkVnAKvE4DoVwbhIUTvXRqneOmzheA==
X-Received: by 2002:a17:90b:3e4b:b0:3b0:da22:db62 with SMTP id 98e67ed59e1d1-3b0db7236e6mr843730a91.61.1793926754254;
        Thu, 05 Nov 2026 16:59:14 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b094ced6a3sm1597043a91.0.2026.11.05.16.59.13
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:14 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ed05b3eaecso990125ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926752; x=1794531552; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=fLUSVRPwkmUTUAgq80PahC96btJ6jADokyfUrfGOvrA=;
        b=VOnDeGiCEr2NflvX4RFDCUuIvpNfvmtHz+6dqo6TD2Edu6T4VOoS4lwTgxorANH97g
         j/2Uwi3DwFWfcuOMoKZc2bXauaZYvVgwv7Q1XVXJCcueEoWzGAg9VlArLI0yd7DnwudJ
         hvqnacYwy0l8Br5rnV3lXAURIZzfkRoaI5tH8=
X-Received: by 2002:a17:903:f8e:b0:2e9:56a4:8571 with SMTP id d9443c01a7336-2ed41988447mr13818135ad.25.1793926752184;
        Thu, 05 Nov 2026 16:59:12 -0800 (PST)
X-Received: by 2002:a17:903:f8e:b0:2e9:56a4:8571 with SMTP id d9443c01a7336-2ed41988447mr13817905ad.25.1793926751682;
        Thu, 05 Nov 2026 16:59:11 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.59.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:11 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 20/37] scsi: mpt3sas: Validate CurrentHostPageSize before using it as a shift amount
Date: Thu,  5 Nov 2026 16:42:35 -0800
Message-Id: <1793925772-1303-21-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Reject an out-of-range CurrentHostPageSize instead of using it
directly as a shift amount.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 12295ab544ad..3622d8a42725 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -7532,8 +7532,15 @@ _base_get_ioc_facts(struct MPT3SAS_ADAPTER *ioc)
 	facts->CurrentHostPageSize = mpi_reply.CurrentHostPageSize;
 
 	/*
-	 * Get the Page Size from IOC Facts. If it's 0, default to 4k.
+	 * Get the Page Size from IOC Facts. If it's 0 or too large to be a
+	 * valid shift amount, default to 4k.
 	 */
+	if ((facts->CurrentHostPageSize >= 32) ||
+	    (facts->CurrentHostPageSize != 0 && facts->CurrentHostPageSize < 12)) {
+		ioc_warn(ioc, "CurrentHostPageSize(%d) is invalid: Setting default host page size to 4k\n",
+			 facts->CurrentHostPageSize);
+		facts->CurrentHostPageSize = MPT3SAS_HOST_PAGE_SIZE_4K;
+	}
 	ioc->page_size = 1 << facts->CurrentHostPageSize;
 	if (ioc->page_size == 1) {
 		ioc_info(ioc, "CurrentHostPageSize is 0: Setting default host page size to 4k\n");
-- 
2.53.0

