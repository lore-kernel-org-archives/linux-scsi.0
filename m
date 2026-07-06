Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832B5377EC6;
	Mon,  6 Jul 2026 14:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783346530; cv=none; b=ca7PHLlBwkB29a3Z7f8FYzstbgjnIGEAukp4F9vbeGYU61r/pNAwkjxwEiRU+m4iu4ZnoURe050SBMObGJ4qgq+qXKt9Ds9TRK5tB3xIkPIvPtyv460/0OfFiq1TecL3c19i1jbMWvQ0+VuY+DX3MW4c92kI6Mw2yzqfihthfII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783346530; c=relaxed/simple;
	bh=kR1mcwRu68froGsjeJRT1hkq1H5uQEJ2k2olRMbQmq8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RupyLXaq984Lb4P8AorKCrxItKMNIpJngbhBy05zX8EIqL3lhKt/A4HSYIl6I/UhskDTlfJrKP3NiQ0tplCujTdHcVfaj4nhHq7MfCfVnpkp/hOkvIDAPxMKMVdIsPZe6Y7iGUODDop1TjXPZtB+gmV8UKXUlyfzxYPrOpOM5Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bwUzpgp1; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bwUzpgp1"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gv5dX75Wjz1XM6JQ;
	Mon,  6 Jul 2026 14:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1783346513; x=1785938514; bh=SWQu/Y+XC68Sm5MppnTOFQED
	FDkVGjBC+cLSsIsk2pc=; b=bwUzpgp1uLbCon5o1MbBED+9l+vJSXKRjS7vqFdB
	Vps58b90aV/5Ou/oe2HqwU2q4Ma1JAIs6aUZhpcYy5OFC4l65LqE16uatgXMUq4x
	aUf1Bp0H3eKAfT83gwjkLRkw5LRFFhKJgMBR3OCJz5IJ4C3REVjmhKacEn2waBoA
	s3oJ5IeqPMPA0GLcFiivmIak/rOaijZnKMDMyqy6S1YtXT4OA8sQOwshS/lpa2s1
	suR1jnCrq03rTk+rXVzz47LRnCum+0XMqoAraNR7AEPN5d6suH4Oyg9qXPifImOn
	HTB15MbC1+pAbedC3AbMx8LBi+zg5IHp3NGEUqRDbftAGQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 24qOXGkWAkgZ; Mon,  6 Jul 2026 14:01:53 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gv5d473bZz1XM6J4;
	Mon,  6 Jul 2026 14:01:43 +0000 (UTC)
Message-ID: <f46d7520-bc2e-49f7-9049-ecdba2837b5d@acm.org>
Date: Mon, 6 Jul 2026 07:01:42 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
To: Yixun Lan <dlan@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@sandisk.com>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Philipp Zabel <p.zabel@pengutronix.de>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 linux-riscv@lists.infradead.org, spacemit@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org>
 <20260702-08-k3-ufs-support-v1-2-1a64a3ab128f@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260702-08-k3-ufs-support-v1-2-1a64a3ab128f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 7/1/26 7:31 PM, Yixun Lan wrote:
> +config SCSI_UFS_SPACEMIT
> +	tristate "SpacemiT UFS controller driver"
> +	depends on SCSI_UFSHCD_PLATFORM && ARCH_SPACEMIT

What would break if ARCH_SPACEMIT is left out?

Please make sure that this driver can be compile-tested easily.

> +	u32 host_reg[] = {
> +		(UFS_PHY_MNG_BASE + UFS_MPHY_RST_CTRL),
> +		(UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL),
> +		(UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL),
> +		0xFFF,
> +	};

Can this array be declared 'static const'?

The parentheses in the above array definition are superfluous.
Please remove these.

> +	buf = kzalloc(VENDOR_DUMP_BUF_SIZE, GFP_ATOMIC);

Why GFP_ATOMIC? ufs_spacemit_dump_host_regs() is never called from
atomic context, isn't it?

> +	len += scnprintf(buf + len, VENDOR_DUMP_BUF_SIZE - len, "vendor specific registers:");

This function will be much easier to review and to maintain if a struct
seq_buf instance is created for 'buf' and if seq_buf_printf() would be
used instead of scnprintf().

> +static bool is_fsm_state_valid(u32 state)
> +{
> +	return (state == FSM_STATE_ACTIVE || state == FSM_STATE_LS_BURST);
> +}

"return" is not a function. Please remove the superfluous parentheses.

> +static int ufs_spacemit_mphy_init(struct ufs_hba *hba)
> +{
> +	int ret;
> +
> +	/* reset all mphy logical */
> +	ufshcd_writel(hba, 0x003, UFS_PHY_MNG_BASE + 0x0);
> +	mdelay(1);

Why mdelay() instead of msleep()?

> +static int ufs_spacemit_uniprov1p6_init(struct ufs_hba *hba)
> +{
> +	/* PA_TXHSG1SYNCLENGTH */
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(0x1552), 0x4f);
> +
> +	/* PA_TXHSG1PREPARELENGTH */
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(0x1553), 0xf);

The code in this function is very repetitive. Please convert all the
ufshcd_dme_set() calls into a loop over an array.

> +	/*LCC_DISABLE*/

Here and everywhere else in this source file, please follow the
convention used elsewhere in the Linux kernel and change /*comment*/
into /* comment */.

> +/**
> + * ufs_spacemit_hibern8_notify - Handle hibernate enter/exit
> + * @hba: host controller instance
> + * @cmd: UIC command (HIBER_ENTER or HIBER_EXIT)
> + * @status: notification status
> + *
> + * Manages M-PHY power state during hibernate transitions.
> + */
> +static void ufs_spacemit_hibern8_notify(struct ufs_hba *hba, enum uic_cmd_dme cmd,
> +					enum ufs_notify_change_status status)
> +{
> +	int ret;
> +
> +	dev_dbg(hba->dev, "Hibern8 notify: cmd=%d, status=%d\n", cmd, status);
> +	if (status == PRE_CHANGE) {
> +		if (cmd == UIC_CMD_DME_HIBER_EXIT) {
> +			mdelay(1);
> +
> +			/* Enable reference clock */
> +			ufshcd_writel(hba, MPHY_DEVICE_RESET_DEASSERT,
> +				      UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);
> +			mdelay(1);
> +
> +			/* Power up all */
> +			ufshcd_writel(hba, MPHY_PU_ALL, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
> +			mdelay(1);
> +
> +			/* Assert ana_rx_hb8_reset */
> +			ufshcd_writel(hba, MPHY_PU_WITH_HB8_RESET,
> +				      UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
> +			mdelay(1);
> +
> +			/* Deassert ana_rx_hb8_reset */
> +			ufshcd_writel(hba, MPHY_PU_ALL, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
> +
> +			ret = ufs_spacemit_wait_mphy_pll_lock(hba);
> +			if (ret < 0)
> +				return;
> +
> +			mdelay(1);
> +			ufshcd_dme_set(hba, UIC_ARG_MIB(0xdd), 0x57);
> +			mdelay(1);
> +			ufshcd_dme_set(hba, UIC_ARG_MIB(0xe8), 0x57);
> +		}
> +	}

Please move all the code in this function that is indented by two tabs 
into new functions to improve code readability and to reduce
indentation. This advice comes from the Linux kernel coding style guide.

Thanks,

Bart.
