Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996817;
	b=DZ5uBSdeaBINexVE2x3fsdsj8jVLMisE5Agl7Zf6FZveV+rZkJErCufmlK1FUO8RFO8g
	 hWmkE2fEPN566PeKeGenW5XxpnCvSNnM163UIYJTTuyV2YdgEwNNyL4O7fpLd9Y2wtSq8
	 W7PfGH3BJ8H46Dm7x3UUCsosp2Vw7mP1rzGWZkhLO19C4dAunpDqOXk+EtFcx5ydRCbSj
	 hJcXVEy7aXZodFkNgCgP/nFYfoIpkltPcmpFudlVYMGiqjSSWKcjtYmqX/1eeVBPKIxPd
	 HL/RW8rmsIQJ8auuxwKoTZSTYem310+xufllEjXO6lBirOyKJ1453Ze7J8npudN24iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996817;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=HuqpxmqkYUoUhhUXONTnZbGPyj3lM6yQcfPot3EL+PQ=;
	b=ISbtWWhnV0UfXWEf9lPkESnE+Rps8ZXL/9axdmt7gUNlojaq80TwIyclTBHnFm1dhZTh
	 3KsY1l5tEui+spPRU92/n6v66fyaVFMdXz4adbjTAgcc1cGFugNJPE/FgattaUmEV7feo
	 H3K4R8ar0vRISOtIj4TJp6JFhTo2QYPGMahiFtpZOXuocW0EVYoyZirFlc//6D0HQ/BoQ
	 scADCWmmW2oRQj5T9v/4YXAqbDhFOy9oTi1uwRNfNHfuZcNpYzkgq23R4AfO8oaVjrgQh
	 j4/Dmkmie4DEl0ocHhqW1NbVCip7E6tBJNF57+OTmIBzPVwfO/21e0hwHnbIoaUMyRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=ClLNrvcS;
	arc=none smtp.remote-ip=209.85.215.225
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF21606A330
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:13:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DF21606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=ClLNrvcS
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cc758830601so673787a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996817; x=1795601617;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HuqpxmqkYUoUhhUXONTnZbGPyj3lM6yQcfPot3EL+PQ=;
        b=ZHWX8ligf9Qa8gBhoAFTH1lACw82rxvoMqa5dtQaczHTrjFlPsOyF+Vb5FOQajThlr
         wfNe+OqiuUi6VJRz8g2+r/yjpLG5xsmh6H85ZUR+yda6L4a27RGROkRSLPUBm3re8RDv
         Kdjj0Okow9Unm1S32l+5+SoPDTjCvY43OHFk0bprZFKLTO2UJgK29VFY0th6ibQfKXoR
         qtpw/qJyfA1TXjuRSIlu8mtprmPMZDtv5WV6rbiaDborvIycY4K3QsGDk7QgS+ouRIAM
         8H/Yf4MEU3FGBRBf47548I6i7TYkOneyZ4FUW38xt7miXOHbG29SN3S4pxLNm937oG9o
         YSlg==
X-Gm-Message-State: APuU4Z/4dxQqDmRdYhRggVtr1nQzurkVbOg1Dvp4/ABY1+0YzewO3uRZ
	nCfbOaGUweR1AL3AcnBZe+wn1WPHI0/aXBPi0FwGk3w5951RcfifkIbXbRs2p64rArcHrJUMlmp
	tb9A4Gt6RRYhyHI2VEMKH40EMzJiOqMCBDx9sda+uIZKPS1KJOLvvcO/RJ6AcZ3bf2ztk78yFWA
	kVxA3selo1uJ1T+KQyJXEtebJeOQL27tJZonDu8GeuxafBdujvXB0jBpnQCvcWAemS/eRZhElRf
	ySXCyrm94XEPFPmOsiOPG2OjrhFymL20wA=
X-Gm-Gg: AZFdTZdBFVeu27K8OWxbtCHyu4557nn0ALeBWf45MOAtfIdQ4sFBzHeb2ryFoI3eJJx
	ck7CpqP24erjeL5Zs2HOteQN9teXA32/SFGfHuoYGgbUCw8MZdh45x8OriJ5RpZOEGQqA17Pne7
	ePPFme0NroZXD4Wk5A+0Vh69MOKXg5iD4vGSeZ2KyGxIvxry81jMRJEXsS02gZcdMlHxERPsK43
	Pk3JVWyek6HATuwEwvmEYUBQQMW1SRufLzrGO1Uaz4XdPXYG0HQJ5RBleMH4JSnmDQPIkYsB2P7
	zVhFf1dPbACVYFKS9UEBmWmgZEkYWyhkdbS2R06xYQA0jEXY8jZoWvlbrrpWVhTOdHbiT/40vqQ
	tRAB/aq6/zIlaZipKNaLvLQW0y0Bg6ltR+LPbe74XzyMTLuaX1xtRsGRcaPrl837YhCPrwh2rUX
	z/Qa5Lkmyg1ITjbZXWoyOz9lM4xanyJJGXWH5FDdi35zHJPpeD3bqy2A==
X-Received: by 2002:a17:90b:5290:b0:3a4:7730:33dd with SMTP id 98e67ed59e1d1-3b3d07e0fa2mr1844729a91.58.1794996816877;
        Wed, 18 Nov 2026 02:13:36 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3ab9f98bdsm4033158a91.0.2026.11.18.02.13.36
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:36 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ae72da2f57so1052509a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996815; x=1795601615; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=HuqpxmqkYUoUhhUXONTnZbGPyj3lM6yQcfPot3EL+PQ=;
        b=ClLNrvcSOhjqOxg7y9gtgSwESxzItoKfC8Ny02VCAT2bFwMCAYXMi4UkOn0TqEL3Ph
         hfvI5sIKuQNPi9ZysjX9kz5Ml6isITYMxJTNl69+wYELZsN96J/5X5lx6PqgBGmjufeg
         rpOu4gcii8z3+maDTD+VcR2Ru9kP7LTLpOilA=
X-Received: by 2002:a17:90b:52:b0:3b3:b9e4:e3f5 with SMTP id 98e67ed59e1d1-3b3d07b92a0mr2151927a91.30.1794996814876;
        Wed, 18 Nov 2026 02:13:34 -0800 (PST)
X-Received: by 2002:a17:90b:52:b0:3b3:b9e4:e3f5 with SMTP id 98e67ed59e1d1-3b3d07b92a0mr2151907a91.30.1794996814336;
        Wed, 18 Nov 2026 02:13:34 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.13.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:33 -0800 (PST)
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
Subject: [PATCH v2 26/37] scsi: mpt3sas: Enforce minimum reply frame size and validate chain segment size
Date: Wed, 18 Nov 2026 01:56:35 -0800
Message-Id: <1794995806-5835-27-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

In _base_allocate_memory_pools(), reject a firmware-reported ReplyFrameSize
smaller than MPI2DefaultReply_t and validate IOCMaxChainSegmentSize to avoid
integer overflow and out-of-bounds access during SGL construction.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 49 ++++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 0b4b8aad2162..7e5f5576fc5e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -6396,21 +6396,49 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	/* reply frame size */
 	ioc->reply_sz = facts->ReplyFrameSize * 4;
 
+	/*
+	 * Enforce minimum reply frame size: the driver casts reply buffers to
+	 * the largest reply type (SCSI IO reply), so it must fit.
+	 */
+	if (ioc->reply_sz < sizeof(Mpi2SCSIIOReply_t)) {
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
@@ -6422,6 +6450,13 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	/* now do the same for a chain buffer */
 	max_sge_elements = ioc->chain_segment_sz - sge_size;
 	ioc->max_sges_in_chain_message = max_sge_elements/sge_size;
+	/* the SGE count is stored in the u8 NextChainOffset field */
+	if (ioc->max_sges_in_chain_message > U8_MAX) {
+		ioc_err(ioc,
+			"too many SGEs per chain segment (%u), cannot safely attach\n",
+			ioc->max_sges_in_chain_message);
+		return -EINVAL;
+	}
 
 	/*
 	 *  MPT3SAS_SG_DEPTH = CONFIG_FUSION_MAX_SGE
-- 
2.53.0

