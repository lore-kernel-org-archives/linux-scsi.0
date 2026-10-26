Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793046236;
	b=BysuQs4fAkXDRfv10Tkjz2qOL0gyHgrA7i2hoKnfT72MANASCZMQGsEyWEMOlhvXxFPR
	 lQMZZuMEQKdIecS/IoxAx6iNOxoiUna7gBrprmufHC34S3+xZ4Lffn8okdMTfs8ojfZY8
	 VJg/P9eeSWgcB3TctxwtVljdI3cgry0Nhc7AzSGrEpfMbNBG3m49gzcMuYL0cURRWR0qw
	 icFKJ4eZRBX2oS+bndKKtzqHREvzuUH4j776aLFItv4WfFTjYVOKynE6loqYbnQ0E7c6y
	 6TKf064RN9pn4YCsHgR3hbyAQXNYrCm+g4RZvLHvNFUkEwzu92fytpM4MW7FsKfiFAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793046236;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=dgrqIkyT1AWg6HRmyXzx36ddvTTSHAJSFT3GWfCe4Hc=;
	b=P7Fqbhb4b82tERMVsiEyQxliluxDIGuVRRlJ6BMMVBryGv9lGWZDMjUvs4Cj3flv228h
	 7a9LMkoks1JapkBn8hc4t+oNsorzaTsLaIp2AlM+NVf81oGcxlO/N9gscekxh6nitIMD5
	 r3cZNarNnVnK3J8n1oHQzTecniEk0kurzolUfeCbDgMRQ362xmMKms4UZe5iC0N1gAHGl
	 GlWOgKMG08I5CclG92ACF7vFdx7+H0V5ky2Y23+wrrzqLJYNcLef0w4mkQ7y0S0yNMEUg
	 GL9060r2qiUW43V0/Ttjnw6gHzCYeHOgPYGirlz0EgbbxC0oTVRoSj7sQfZxVxRGhhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qiXMIULT;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E65A606A31A
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 20:23:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E65A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qiXMIULT
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a2d6d01ecbso16884495e9.0
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 13:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793046235; x=1793651035; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dgrqIkyT1AWg6HRmyXzx36ddvTTSHAJSFT3GWfCe4Hc=;
        b=qiXMIULTMilEl52GvHDMqPoPym++LhzLyKjb5b2IU+yFy92yJJ2Gb+M00zfq85nNF7
         tp3bwlQSiJd0II1nJjJ4U+xDt7VP7CKfUe0d21Rj+Cu2eZ8WBhZVA8P3fd2k5gTRBDwn
         pzKqrk9C/CfztgqHXNicXUU+toQAiVUb8l/cB4pmzbBCCEy0AjOexuTUecVN3M1nwjbk
         zkWrsxjFw9AADuOUAuWPeNLCRSXOfq9utR77e1aFSlFgmBCyS6T0atL8dizD673I2CiD
         gFOt9Yr9dbsCR2Lk7J5HVmgC/sub6MXUnD9jrkZkQM8mfcofQs1/kllUybaPZrNj1LNv
         VzDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793046235; x=1793651035;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dgrqIkyT1AWg6HRmyXzx36ddvTTSHAJSFT3GWfCe4Hc=;
        b=ugdqrjx8si03yzQRdZfNj1D0wsre8EHts7cUXu6YL2pmof6UmRakn6HWzE7seqSkAq
         k2owOhTb/l6K2bg3N7EOFChZ0cDvwvCP1zpjXTvbeUyl11b7lWtLUOawixs7LB58wk6Z
         wV4eQIshgFg430m1bi/FZMeFeZ940gZuuTtg68BDS7IL4/Kr8gD8/Q/rawhNDzXDqrLa
         Dm0CXzyR/0FjicpUhQfscIMAM6NG+rYStHXtc9/pIpDXkyNjA0mg4Th2e6d9qyYYAwnb
         GETiUE0NZVDXSnpd71dys+3ITzRQ9B0kOE1VvF0boxRf9wtH7s1eiZCZjH4YLOkTul/8
         tJqA==
X-Gm-Message-State: AFq9FYJn0ywBEwxkcq1VfwlfVJRpbDMN6a8frABZI4XAsKgqYrb3pSze
	RujkPOwQRWCAgti1g2ZjZgvJubMPKxvhWPY8+vrx1tLFEN3g0iZ16DCH+6U83agp
X-Gm-Gg: AYBFou1HYXAtQFP6gVO/VCNdi+kszl5n9I2pAKhRmBYjINai144go25Eoublpvr7ATV
	Mglp60d1CumTh76ZaAlhHdZsRkk1U0pn7kpuOyHnkXs5b+6mMa09OphmELh9hth+mP1eVEmhjZN
	j6v4Sl21hCmzoVAg3KkKFFh7aURHEu1X5Vc2DfYvB++LPxHxaq4xGtdfeNx1YwUbu0SkRv4ofHl
	Qzdc776ibnltIesMnWt1+CtBluX8HGDhU2U3thaoOARkgJQX8MK+VFe2/VhpVTFNNiDQqjg9gIE
	6E3Xy855NjA584BruBOtEIEWmlLYCaRUdp8Nu/0rn0rSporhveQKE0PfVpJxH1c98Ly2JtqiCjq
	N2eR5swaHfJl1S0Jx5zmS8gjTQZ8ahvr/ugppGFxjwKaWlgOUFvNJANGqYSv/AnorjsUiFVknOm
	DStzIRyHxXOwJIfPn4kk74I0qbQ3HeXT++9iixulZ5iiI+t32mNTUL3ycypWipbGmFpLhGAxE3u
	rNSJ9O3XIdEyN8+ITQmPNpg+wreZNhhRAyf85Q1JGXP2uLqOdPTVIy/M8jpe55eZ8Q=
X-Received: by 2002:a05:600c:6289:b0:4a1:cfa7:e968 with SMTP id 5b1f17b1804b1-4a35acc8109mr141449025e9.21.1793046234663;
        Mon, 26 Oct 2026 13:23:54 -0700 (PDT)
Received: from unicorn.lan.internal ([2a0d:3341:b894:4600:8f9a:af38:72d6:7c0e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecde7easm18710967f8f.52.2026.10.26.13.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 13:23:54 -0700 (PDT)
From: Giuseppe Piscitelli <ooonea@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: scsi_debug: Drain target cleanup before module exit
Date: Mon, 26 Oct 2026 21:23:41 +0100
Message-ID: <20261026202342.668361-1-ooonea@gmail.com>
X-Mailer: git-send-email 2.54.0
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

Target destruction queues cleanup in an exclusive async domain. The
module loader's async_synchronize_full() does not wait for exclusive
domains. Wait for target cleanup after removing the hosts and before
removing the debugfs root and returning from module exit.

Fixes: b402a0dce64a ("scsi: scsi_debug: Fix create target debugfs failure")
Signed-off-by: Giuseppe Piscitelli <ooonea@gmail.com>
---
OpenAI Codex found this gap during SCSI teardown analysis and wrote the
fix and its local validation.

Earlier validation included a Linux 7.3 build and three ordinary
corrected-module lifecycles. No unpatched race was forced; this gap was
not established as the cause of the original allocation messages. This
base was checked for applicability; no new build or runtime test was run.

 drivers/scsi/scsi_debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 3346562..8aa8652 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8675,6 +8675,7 @@ static void __exit scsi_debug_exit(void)
 
 	sdebug_erase_all_stores(false);
 	xa_destroy(per_store_ap);
+	async_synchronize_full_domain(&sdebug_async_domain);
 	debugfs_remove(sdebug_debugfs_root);
 }
 
base-commit: 6a53f401e671b75c129245e371ca6e9d47fc3c9a
-- 
2.54.0

