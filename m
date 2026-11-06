Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926774;
	b=VUrGGAjXdZeN18uyzKvVUKeiEJtpikawVAGN49ZXQRRs+KGMvfJCOhRfX8UsFT1d8rmd
	 HJ+3UaePDPL9iFUtiuc2DGdFlLlDa+9GSxspEczAflVfVFISKIGmvo0TlW+fdq85tDoqZ
	 3Su9YJ1KnMWI/LAJTrvHg81SNiGNnErLelJ/UT1Z5XS71XsOIyl6tiWkcv73hDmGs3jF9
	 tVWDEFDKFkakL5emQTLgeJGPz9P/uCGsCK8C0hdEgp0bNapUIfJB+K3aN1IFFytTHRdPz
	 MFpaZd+egpctB6afoarXN7ZNsgmF2psd0OFpQUMaZ5tQfkUc7Vbe2iazMmNWpCsjM8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926774;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=0mJF7ligDKQWNKCZhhB+1JEIBLoVoXwcMC9yxU3LEtg=;
	b=O94HOHbz2dYiwS5ooJt1xDfZTYqrfviMbikOIuY6ETbAc//ksu54JCzeIfCywcBT/kX4
	 8dtv4LxqqeGqYwJV/QctUCCVPQo1COZKvTr45l5EN3EzO/0ombNL1Oo6FJheBQEMYdrbc
	 tEiwOBepJ8v6BTnmHcswKTbRoWpsSdcb9zZRvQcAbyjVMx6RD8EtiAJ4E7mDy9Pa2jwii
	 GV7gJDLkM9Wou9wfS9f6lORyzSyffq6GghFM56f1sadOBVT38kmVqxwQNNrEt3kHV2EKT
	 Lfk689q+P8gFNUdGjCCGK6Ur+RsRKlTrmohtnz4F/9KCTCF30GIXstXGtheH6F4tX6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=grBx4X3D;
	arc=none smtp.remote-ip=209.85.219.97
Received: from mail-qv1-f97.google.com (mail-qv1-f97.google.com [209.85.219.97])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AFA606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:59:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81AFA606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=grBx4X3D
Received: by mail-qv1-f97.google.com with SMTP id 6a1803df08f44-91c75267b0fso781716d6.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926772; x=1794531572;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0mJF7ligDKQWNKCZhhB+1JEIBLoVoXwcMC9yxU3LEtg=;
        b=C+L9lJQ7Mm8Mdb2J+lDgs0mr+BHzmR26mDN455KLf2i375h8WLZMDahEXnkSGkzo/e
         4MmTwQlYh5H5nl/qEWypNAwnLTcclVdc55PQrPMRt6tlUE2700HiLZfXzFZX8lip3veO
         4m1aYqfFE+69jOROmOPUI53SSF+EN9ZQBfm3/i27mGbbPyYoBCVBx8B3HgPdMF4ABc+7
         oX91rzBtsf3sST2KTvS1Q3AZMzMzkA+jjh1qPIvgG2/fSnxdtJtHqj6u9IVNM9fgr4V8
         davSUhFHoBiR+5pXA4CKVP39VeKkmx2hsJnRxj2t3nYm7wGbQbV2Y2s57nZ95hftypQT
         x13w==
X-Gm-Message-State: APuU4Z/GI6FD/l7Ytkut7YoF30hru3Bt5+Csk5F/wk6uQ6yJyM6lOHTl
	fbjLP29p+9JIfQV8OAcopGoZvZoB6XL8hsxT92EmbpbePs5VU3f/UQQc36117HMNCvudLlfRlCu
	65b0cV6M7CCr0P9OAhRaqT1QKGoKRmCvJf1ZF7MUZh+cU1yOaD+V6PsD9mmYore1SRjmw1EEe8a
	YSN0kKT0Yz5rtGQtu5rBTED8KCcu1SA4BiOhO7M4TvMrHD8U2LRdOGc4qUgMCxkJTp/Qt+F0TcC
	5e8Tik2AjUQhoNeBKRJtDEyhoZXtvSCGkA=
X-Gm-Gg: AYBFou04GBtDcUaWZ+7N320/5aklCuZzm8/fz1S6uwqTBOwS78KiI/Zoemn6RA9JGHE
	w2VQj8O7FR9+s3dF048kmqOuW9WJKrHTOQf+UahQ2VqNphZv1eM+N+373IM1qJowi5GpVMpWBSV
	HwdV57Bypkrc3XWbRgS+vipcE6WlzdK59Qq39hUY7Yt3KBoZSYhfyPloI3kUScyyQdyZ/TrPc9d
	0He2XazZ79BxNVDXtx3ywc7XkJjHSchj/WZ7uGx6SeJcRl5AB/wyOjd8jfTRNQmbROIOVmVSR1I
	wkH2aP3ycTKBpPjVwQVTsZ4Jnzs0rspInZHmS3FmJRwb2UbBobzKuvo8GoI5sA5OBRZzApsAxH6
	6LCdgLYny3H8J5992gVk/pAl87Apq8otyTMLEkLyVql+iSJIr29JsWZfQqPjtXe/x86VCrVTiOr
	0+Y13v3LsLKAZMksrOe4WbZGFnL4aic1+Qqw9D5LvoLcwc+2jYZSrTNg==
X-Received: by 2002:a05:6214:4a03:b0:91c:708a:6da9 with SMTP id 6a1803df08f44-91ea98631ebmr11273046d6.42.1793926772377;
        Thu, 05 Nov 2026 16:59:32 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-91ea69b0b40sm193686d6.12.2026.11.05.16.59.32
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:32 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ed05900df7so1234075ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926771; x=1794531571; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=0mJF7ligDKQWNKCZhhB+1JEIBLoVoXwcMC9yxU3LEtg=;
        b=grBx4X3D7e48IegbbRD40uXxyr8JUSdFEOIERwLDrfXuXsVhrjX/LjKPdSkRR4Ubq+
         wYsE/2CiukZ71xM2W9U02JDJY64UVi634KDvNx/YIj3qIDKW4rbo6HKGLPXdr94dddDi
         4IXhlVkhc6mpTEip/9orCcyF02kFgS8oc+rko=
X-Received: by 2002:a17:903:2f4e:b0:2e9:4f7b:affd with SMTP id d9443c01a7336-2ed4128283dmr12907765ad.6.1793926771177;
        Thu, 05 Nov 2026 16:59:31 -0800 (PST)
X-Received: by 2002:a17:903:2f4e:b0:2e9:4f7b:affd with SMTP id d9443c01a7336-2ed4128283dmr12907675ad.6.1793926770671;
        Thu, 05 Nov 2026 16:59:30 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.59.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:30 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 26/37] scsi: mpt3sas: Enforce minimum reply frame size and validate chain segment size
Date: Thu,  5 Nov 2026 16:42:41 -0800
Message-Id: <1793925772-1303-27-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

In _base_allocate_memory_pools(), reject a firmware-reported ReplyFrameSize
smaller than MPI2DefaultReply_t and validate IOCMaxChainSegmentSize to avoid
integer overflow and out-of-bounds access during SGL construction.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 39 +++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 3622d8a42725..1af9dc241666 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -6395,21 +6395,46 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	/* reply frame size */
 	ioc->reply_sz = facts->ReplyFrameSize * 4;
 
+	/* Enforce minimum reply frame size */
+	if (ioc->reply_sz < sizeof(MPI2DefaultReply_t)) {
+		ioc_err(ioc,
+			"Firmware reported an invalid ReplyFrameSize (%d bytes). Cannot safely attach.\n",
+			ioc->reply_sz);
+		return -EINVAL;
+	}
+
+	/* calculate the max scatter element size */
+	sge_size = max_t(u16, ioc->sge_size, ioc->sge_size_ieee);
+
 	/* chain segment size */
 	if (ioc->hba_mpi_version_belonged != MPI2_VERSION) {
-		if (facts->IOCMaxChainSegmentSize)
-			ioc->chain_segment_sz =
-					facts->IOCMaxChainSegmentSize *
+		if (facts->IOCMaxChainSegmentSize) {
+			/* compute in 32 bits so the product cannot wrap the u16 field */
+			u32 chain_sz = (u32)facts->IOCMaxChainSegmentSize *
 					MAX_CHAIN_ELEMT_SZ;
-		else
-		/* set to 128 bytes size if IOCMaxChainSegmentSize is zero */
+
+			/* reject values that wrap or leave < 2 SGEs per chain */
+			if (chain_sz < 2 * sge_size || chain_sz > 0xFFFF) {
+				ioc_err(ioc,
+					"IOCMaxChainSegmentSize (%u) is out of range, cannot safely attach\n",
+					facts->IOCMaxChainSegmentSize);
+				return -EINVAL;
+			}
+			ioc->chain_segment_sz = chain_sz;
+		} else
+			/* set to 128 bytes size if IOCMaxChainSegmentSize is zero */
 			ioc->chain_segment_sz = DEFAULT_NUM_FWCHAIN_ELEMTS *
 						    MAX_CHAIN_ELEMT_SZ;
 	} else
 		ioc->chain_segment_sz = ioc->request_sz;
 
-	/* calculate the max scatter element size */
-	sge_size = max_t(u16, ioc->sge_size, ioc->sge_size_ieee);
+	/* every branch above must yield a usable chain segment size */
+	if (ioc->chain_segment_sz < 2 * sge_size) {
+		ioc_err(ioc,
+			"invalid chain segment size (%u), cannot safely attach\n",
+			ioc->chain_segment_sz);
+		return -EINVAL;
+	}
 
  retry_allocation:
 	total_sz = 0;
-- 
2.53.0

