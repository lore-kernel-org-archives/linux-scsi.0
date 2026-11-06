Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926721;
	b=UY+jYZFV67G1eEhjwlufwojEV60UH1L10bZqJNueeUrv5qMW0uiEo8BEHXGwaVTjV6ON
	 1vNgJJP4E5HhxW6I4Y/R89b0Y33XM0CHFVDAOQ9iu6I6ynx+5SrGNz4j8j91/D8XeGsUy
	 WLFL1NYwBUD+bQRjwLbUe/vo5PuBTCS5UJc6N4OuzJzr0E14MGipLG3vD/mKWBeVsg8Ge
	 xK4UuOCe6DUEAC928aMJyLOLz0yk1vliN9Otx5FGP+8kWSV2f2ZXn2zbv+M4a+QLvgs52
	 rwBVKNGqiXIRqj98UJ1dLrrKZMsMC1EZpfeDzCrTJvxDwVtOAsHU/rI38BF4wg1diHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926721;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=Izxfu88R66sNnCmVjXJnPBLCGe7XqHUeNXNMpofY+gU=;
	b=0igcCvgUcag9tuVRRHZBOSqKDPmu6dHMumvu/Z9c5/incK4Y5Z1qJnwkMwVc35scv+g8
	 OQabN6KN194TasaDUdj68tejPV/AECLfDRgvGddRQKO3TsJh4yvbXOZKCJ8MvLI3U/wPr
	 Kdv4gSr0esie7nLGcM9EutQQ2hbo+BPEuqyZitJg4D3f/9p1XTxC2tjZsnWfI3c1sYM+u
	 BEdc2bFSVPnFBJhx05aA4M+TfhD42KIf+XbW1jXAkmNGQsRuYEYC3tL9cfVhLM6GcEpc1
	 tqKb5RtMMxEyuVGhxWNAx5K2YCWrrFI6NhXs6EIUoPj7iGf2hsvRwFwVxd8NW+uExHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=R2sUjBBS;
	arc=none smtp.remote-ip=209.85.222.228
Received: from mail-qk1-f228.google.com (mail-qk1-f228.google.com [209.85.222.228])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E821606A329
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:58:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E821606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=R2sUjBBS
Received: by mail-qk1-f228.google.com with SMTP id af79cd13be357-93f3c895a0eso11030385a.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926720; x=1794531520;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Izxfu88R66sNnCmVjXJnPBLCGe7XqHUeNXNMpofY+gU=;
        b=Z1e+YedyfRiz9jw8CJ+b12Wr/bRknZSiWE4OdL2zs+26o6yE6sWwVYX13cZXVT/J0d
         6n53wuvpRVRYQoh8swJOhFex3vsdH4Km7KpB4C5WHeR4Jub61Wtj4KsMU56jkh+YI9LI
         shtukJcmZ5FqM86RaFiIv4cFfAR85RLsJ77fnrwLf9nyKjSp8LkYgclh/4qjuEz6YEtS
         6QpghR7wc8DtKlDZF0LC6qzFuohbSlTKh4y2BDOm/GuUeeiJO/lqTJUK3ZOJN9kN5Yoy
         atDt8gWTW93KcD5OnIb3n7FcvVa3yGQoyTaCccKCFWkv21leRGS1t1HKQ+jHEdUfBlkg
         myzg==
X-Gm-Message-State: APuU4Z/mULukGiFgxUJLMJHjw4GMhDnYivWj6/ic6xbUrh6JnWM/1ZVf
	C/xl6ROOsg1Smb1u2XcU5PBFBhoXu+GbtBJDLR+nS8bN8MK+Q+8OEecVrrINa7lkzWwA2O1Ny1b
	ZLBliNcWM8qGejDBBpoR2uO6BC8EhSrf7b10rJ9ZCYdIOc15mHjrvd94Xe7ZyNPXmLRAjlpgOEZ
	0JB3I1Nt8/mrq4CFm3taa3tnHDUjHq6APQQy23y6DHsoZKhjAv1++rCU+ROQDX6BIZ3qPcXw8Jv
	P3Vur3XcR61zB308YpV9L/Wcg+czyRdicU=
X-Gm-Gg: AYBFou2xODK+92eEYBcTeZeSuVR30FQrScvEHiNtVpwIL2mCI8QICOoa0pKESjaSFY3
	8O05GHxxQCq1YroR0AShATS9KCv4jB0zckHZGCEmNjGNa7mdf/Jl0n6J0cXXpphm3baVNiE6vHI
	YfB16si1qygV7DUCVV2I5+2vudrPf23oJ/hz2N41B2cx+a/Zg3nKRzfOnax6as70zRA5N9fpJfA
	vxsDObxRyKtBGQIlZ04ZLJC1n8AZZyd5RgvDq5iaxP5L53xSd89cIb2nsGOwsASikSfoUCUjbk0
	+DVfiBHqZeqx7XmMCdRtwGUmPnlhLVUSlg7e4yNqaA49MKtR+1Cyh2fkXizQZs/75FFHwu5LGRk
	G0rbEKZg/IXZ39KQDy46+0DRWrfnHRcUGlE82/7jwWwbg1bSBFL4zeZRB1bCzcJKjKOYTIA8/nl
	CuF/ML6ewEvfXEoo85yHDhvbm6cqaTV5lfSHfygV8eWqbsGp3QQGUMOQ==
X-Received: by 2002:a05:620a:4503:b0:93e:90e0:d2e3 with SMTP id af79cd13be357-945f3500ae7mr140882885a.39.1793926720138;
        Thu, 05 Nov 2026 16:58:40 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-945f5984eaesm3719185a.4.2026.11.05.16.58.39
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:40 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2eced5a4cb9so923275ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926718; x=1794531518; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Izxfu88R66sNnCmVjXJnPBLCGe7XqHUeNXNMpofY+gU=;
        b=R2sUjBBStF1GRPEGCDUpdGWAjPpNvSNT2pX0h+oGS2oPrzZPEqmSpqQz+a7HtQdvdW
         OC3m5YcCdN4PePpDDnhTZ/s1Vh697q5qz7cRhYlRaOWJPTlFOBKbTcCe8l8ojVb457n4
         zbz9uZwFOGvfMQkAUGl4eayn0iTdhyX0161q8=
X-Received: by 2002:a17:902:cf4b:b0:2ed:1350:59ff with SMTP id d9443c01a7336-2ed404d2ed7mr15741565ad.3.1793926718149;
        Thu, 05 Nov 2026 16:58:38 -0800 (PST)
X-Received: by 2002:a17:902:cf4b:b0:2ed:1350:59ff with SMTP id d9443c01a7336-2ed404d2ed7mr15741385ad.3.1793926717612;
        Thu, 05 Nov 2026 16:58:37 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.58.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:37 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 10/37] scsi: mpt3sas: NULL ioc->reply_post after freeing it
Date: Thu,  5 Nov 2026 16:42:25 -0800
Message-Id: <1793925772-1303-11-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Match the pattern used for other pool pointers in
_base_release_memory_pools() so a repeat call can't reuse it.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 9bf92c4a14b7..40624b3c972c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5869,6 +5869,7 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		}
 		dma_pool_destroy(ioc->reply_post_free_array_dma_pool);
 		kfree(ioc->reply_post);
+		ioc->reply_post = NULL;
 	}
 
 	if (ioc->pcie_sgl_dma_pool) {
-- 
2.53.0

