Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3DF1EB193;
	Tue,  2 Dec 2025 15:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691065; cv=none; b=LDim/Mikr8/vyW7LC1wGx4mfednsE/vtcKpiPEVw65GkyCvtCnc/BO16h/waaH3dXWKKqAiTqoePjdLSbqJ10ylk1a+Cc4ZT+z5M0ayn57PHt0DFGiiibvdPHBvnqVEU8yvi6zxSwSCaElSdvqNF7UD9oRH9V71CbvaK7etDA3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691065; c=relaxed/simple;
	bh=tJhqOgr2gUhDdL/Wj3PI4s/APWjYg0ZW39AMgna+9hY=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=t7sJWg512aU9I4yNXvR7XiIBmyhS3sag/LyV6OpXvM6b/pDuo9D6Vt+6mud3h3lucQYaSMz+XOv2c36aPW3dOxaSIqaaeb4a60bmlDBkSsB2lLopbfaAnHoanbMwnX4Z1hGXZPHCmWP0DMKL09fduGXU0z1kVkFdM6fAO6YyDC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=O/jhbqhF; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=aPN8EkLy; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="O/jhbqhF";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="aPN8EkLy"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 8C4857A0184;
	Tue,  2 Dec 2025 10:57:42 -0500 (EST)
Received: from phl-imap-17 ([10.202.2.105])
  by phl-compute-04.internal (MEProxy); Tue, 02 Dec 2025 10:57:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764691062;
	 x=1764777462; bh=kG9nksrF89Nx5W2dulPT+E1xx7iZIXn78AskAV0a8CQ=; b=
	O/jhbqhFpvDd+7hoDM6oeffLlC2UosVmB4Xm8+jz3z93InmkDn50E8gVfPMbCwmW
	LbGwtsZSpYXtdFOrvCpfsnt6hwSlUyQ+tLy8HWgPibc5uY6CgZhXc+qwSYeoX4yF
	6UMsSlW0wb7ejTzsi4BHjifWGeDdxSZqBWxlPmnI+JBMkU+xh7kAQx+no8ex1Cej
	cs/COq0CebmJl2Z06A6RIKmRRQDIUOafAPvN0zzwMSd0ekrujld2Tyca4GvF/0Qq
	cOfYH0kJZXUySK/GPexQMb2A5hSiZZSR04En8MXF+TwQPPgqdWsV2TNflM19DADC
	z8OHlGULqqEbvREIUTEfAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1764691062; x=
	1764777462; bh=kG9nksrF89Nx5W2dulPT+E1xx7iZIXn78AskAV0a8CQ=; b=a
	PN8EkLyvnshi7/wkytCkAeRzlZHQf08FVYokYQ+amJso2OeShgWP6HIuU4wJqAKY
	Cn0mtZzWZfSFEElPD+H1UzA0b61ZHdk7PWYqH1OQQrTnN7vUPd5GoumOQhOySBDm
	zpnssP4ngY0doArEKZjoVZlY9uXT3SQsGTfNYb4PE8DZ2tWKe1cPu389ufJY4l6n
	V2zzpROe93L90xeTtv3MV/A3ODp2z+X5UMG8sK55V6jVigYE9t3fYxsC+5kGE6Gu
	34u96sZWfMlZ4iaFBSjfJW6smZ5jvoWZNe8dXpgDHmgRlAW+kl9GDJQVEhTRMzxL
	sL3mJLIZboaXWCE3HEx8g==
X-ME-Sender: <xms:dQwvaQjhRl3j-2bIFZgVX7d6-NW-c5rddVUFtzFps8GT1MP4cSvAEA>
    <xme:dQwvaT3USaQR4_BToEWWJ81fc8Q_myrsQEbktjtwkIstT83O_50rZ-MpaAjvm-BwG
    KBOxloR-8KyugzcVddvgbFELCI8PpMz3XYItiATo3C6XNSnLWZO3xY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegrihhl
    ohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpe
    foggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcuuegv
    rhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrhhnpe
    efhfehteffuddvgfeigefhjeetvdekteekjeefkeekleffjeetvedvgefhhfeihfenucff
    ohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvgdpnhgspghrtghpthht
    ohepudegpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegsvhgrnhgrshhstghhvg
    esrggtmhdrohhrghdprhgtphhtthhopehlkhhpsehinhhtvghlrdgtohhmpdhrtghpthht
    ohepsggvrghnhhhuohesihhokhhpphdruggvpdhrtghpthhtohepjhgvnhhsrdifihhklh
    grnhguvghrsehlihhnrghrohdrohhrghdprhgtphhtthhopehulhhfrdhhrghnshhsohhn
    sehlihhnrghrohdrohhrghdprhgtphhtthhopehjvghjsgeslhhinhhugidrihgsmhdrtg
    homhdprhgtphhtthhopegsvggrnhhhuhhosehmihgtrhhonhdrtghomhdprhgtphhtthho
    pehmrghrthhinhdrphgvthgvrhhsvghnsehorhgrtghlvgdrtghomhdprhgtphhtthhope
    gtrghnrdhguhhosehoshhsrdhquhgrlhgtohhmmhdrtghomh
X-ME-Proxy: <xmx:dQwvaUwZMzvOdzN-PZnF6K2lprJjgn41gtDPqILeII1IS_lxOvt7-A>
    <xmx:dQwvaSoiwd7xoztxZrCvMysJSZmtAN1eYy0DB5_s3o12ilkuUUCFAw>
    <xmx:dQwvacfna_Tn5D8xeSQbI0Re4y515D-4cRNw5QAJdGVitbuEqL85Zg>
    <xmx:dQwvadqdCV2xTokvnJENHhpUzljJzBGFOITkyygytQSPTNYGkMaZ9Q>
    <xmx:dgwvacBm8kcEZwUkM7ws4lWMXKg-Tpcmx102rX1zdeiT-6YcZ1r1aZbu>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 2CFD2C4006B; Tue,  2 Dec 2025 10:57:41 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AGZqLRzYUuFF
Date: Tue, 02 Dec 2025 16:57:20 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Bean Huo" <beanhuo@iokpp.de>, "Avri Altman" <avri.altman@wdc.com>,
 avri.altman@sandisk.com, "Bart Van Assche" <bvanassche@acm.org>,
 "Alim Akhtar" <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>, can.guo@oss.qualcomm.com,
 "Ulf Hansson" <ulf.hansson@linaro.org>, "Bean Huo" <beanhuo@micron.com>,
 "Jens Wiklander" <jens.wiklander@linaro.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 "kernel test robot" <lkp@intel.com>
Message-Id: <c8656f51-a683-4943-ae6e-d310217897a9@app.fastmail.com>
In-Reply-To: <20251202155138.2607210-1-beanhuo@iokpp.de>
References: <20251202155138.2607210-1-beanhuo@iokpp.de>
Subject: Re: [PATCH v1] scsi: ufs: Fix RPMB link error by reversing Kconfig
 dependencies
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, Dec 2, 2025, at 16:51, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
>
> When CONFIG_SCSI_UFSHCD=y and CONFIG_RPMB=m, the kernel fails to link
> with undefined references to ufs_rpmb_probe() and ufs_rpmb_remove():
>
> ld: drivers/ufs/core/ufshcd.c:8950: undefined reference to `ufs_rpmb_probe'
> ld: drivers/ufs/core/ufshcd.c:10505: undefined reference to `ufs_rpmb_remove'
>
> The issue is that RPMB depends on its consumers (MMC, UFS) in Kconfig, which
> is backwards. This prevents proper module dependency handling when the library
> is modular but consumers are built-in.
>
> Fix by reversing the dependency:
> - Remove 'depends on MMC || SCSI_UFSHCD' from RPMB Kconfig
> - Add 'depends on RPMB || !RPMB' to SCSI_UFSHCD Kconfig
>
> This allows RPMB to be an independent library while ensuring correct
> linking in all module/built-in combinations.
>
> Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for 
> UFS devices")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: 
> https://lore.kernel.org/oe-kbuild-all/202511300443.h7sotuL0-lkp@intel.com/
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Jens Wiklander <jens.wiklander@linaro.org>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Bean Huo <beanhuo@micron.com>

Looks good to me,

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
