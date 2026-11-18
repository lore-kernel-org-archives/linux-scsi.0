Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794972043;
	b=pVcrcpwJQxdK0v+I1rG32AWxDfyMVkT4rF0b00lN+MbY65lCffUvUqahQVMNFIFXa4Bf
	 eN9ANnMPSOYv4uqPzd9uIEGZfkrUnHZ3ojc5us8BsAtdnsNQFHC/ClEmC3capr78UjtDo
	 deww8gCe0a6YjpCMp4XhMX/dNc/gug+eYT9mk4DseBPh7JpXFexbBiGy77Se1VZ9EJLrM
	 Xc5spNeR7LQBrBzp1S/5Oyd2m2+V4/O2upfEbAXK63oGjWbCQZqci5/MtX1BwFJIVyiIY
	 jqN/eAbo+lXhU+SWRtMR+UgbFqmNCo7k3hgOm78L9cC58M6oYrvwca9wuiWiIY35EvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794972043;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tfYyvg/YEjVnt/i5+VxsYpj+ND/9pcDCTdnckyR2aBA=;
	b=Fmizs1XGcyX6XwYrW5a2Zp5ujHOGuUFiAOWWvGz3qxWOHXoCXpCLeTTaQGZuCZlGnmKA
	 AtCJAcRE/w1dPtMJKEC2gqSSoe7t+CEjKPf6Us+7PWRmgwRQDg7E5Wn1XB6BiIH2DNsxp
	 L72PutjsvrJ8NWO6b6XPV9H0RXcGr2kSVG8J86eDjaD/ipZ4BpuAoQL/aYej/JTGK3BDN
	 o2Cso89OsITuhL6533ft9nhFu26ssc71BiClqdI849hZGayue4OIoREIh1ChE9FnfqtNk
	 RoFjSYofxUESeb1huyZ9diDGdO8EVzfdtudUeURpr6JIe7v2ObeMEHN6dEw5kvNPK5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=DIo4LprT;
	arc=none smtp.remote-ip=111.22.67.137
Received: from cmccmta4.chinamobile.com (cmccmta4.chinamobile.com [111.22.67.137])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4AE5606A32A;
	Wed, 18 Nov 2026 03:20:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4AE5606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=DIo4LprT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=DIo4LprTiGWtO/Cc3WGI6bjrXD0YZrUqSIlDbNbKdC9o3g5Zj00dBkuXdRnhzxjHdmJ+VLF0d2auR
	 rTLrCwj1g0fu+NSSpD5yP9AKqHhveAQmze7fW6Fs7XmXhfwsnZVn6FFxj1sj6lIvQMygwhWIIHwfn0
	 1qRnVGMf6ZFTsgg8=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app08-12008 (RichMail) with SMTP id 2ee86afd1983cbe-af2c0;
	Wed, 18 Nov 2026 11:20:40 +0800 (CST)
X-RM-TRANSID:2ee86afd1983cbe-af2c0
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from DESKTOP-3K8GUTQ (unknown[223.108.79.97])
	by rmsmtp-syy-appsvr09-12009 (RichMail) with SMTP id 2ee96afd19869ab-c74a8;
	Wed, 18 Nov 2026 11:20:39 +0800 (CST)
X-RM-TRANSID:2ee96afd19869ab-c74a8
From: Xiangwu Lai <laixiangwu@cmss.chinamobile.com>
To: sashiko-bot@kernel.org
Cc: Xiangwu Lai <laixiangwu@cmss.chinamobile.com>,
	peter.wang@mediatek.com,
	chaotian.jing@mediatek.com,
	chu.stanley@gmail.com,
	alim.akhtar@samsung.com,
	bvanassche@acm.org,
	stanley.chu@mediatek.com,
	linux-scsi@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs-mediatek: use devm_regulator_get() for the va09 regulator
Date: Wed, 18 Nov 2026 11:20:38 +0800
Message-ID: <20261118032038.492-1-laixiangwu@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
In-Reply-To: <sashiko-outbox-219916@kernel.org>
References: <sashiko-outbox-219916@kernel.org>
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

Thank you for the review of:

  [PATCH] scsi: ufs-mediatek: use devm_regulator_get() for the va09
  regulator
  https://lore.kernel.org/r/20261118014234.424-1-laixiangwu@cmss.chinamobile.com

Both findings are confirmed after checking against the source:

- [Medium] unbalanced va09 enable count on devm regulator release:
  correct, and it is a regression of v1 -- my mistake.  ufs_mtk_init()
  powers the M-PHY on (which enables va09), the variant operations
  have no .exit callback, and ufshcd_pltfrm_remove() only resumes the
  device, so the regulator is still enabled when devm releases it and
  _regulator_put() hits WARN_ON(regulator->enable_count).

- [High] state mismatch on regulator failure in
  ufs_mtk_mphy_power_on(): also correct, and as you noted this one is
  pre-existing (cf137b3ea49a).  When regulator_disable() fails in the
  power-off path, phy_power_off() has already run, but
  host->mphy_powered_on stays set, so the next power-on bails out
  through the !(on ^ host->mphy_powered_on) check without powering
  the M-PHY back on.

Fixes for both have been sent as a new thread:

  [PATCH v2 0/2] scsi: ufs-mediatek: fix va09 regulator lifecycle

  1/2 keeps devm_regulator_get() and adds an .exit callback which
  powers the M-PHY off (same pattern as ufs-exynos and ufs-qcom), so
  the enable count is balanced before the devm release;

  2/2 updates host->mphy_powered_on in the power-off path regardless
  of the va09 disable result, so the next power-on retries the whole
  sequence instead of returning early.

Best regards,
Xiangwu Lai


