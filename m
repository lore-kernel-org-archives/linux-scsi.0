Received: from fhigh3-smtp.messagingengine.com (fhigh3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B9B33C5;
	Sat,  8 Jun 2024 00:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717807959; cv=none; b=cntnIigWMiI5awWt3XjnTYG3Bg9YbhJoybRqzXoHAIhZtXxIaIMnxyiY67zMhHRj6+o9916k4lXiyii9Z9TwlecKXJCbg6tVtqPnwjmYVS+dxtUjmuon6Is3mzntK/q+UT6JAKWspZ/8w0qFigQVAgwBONPf10UPjt4LKYnL/OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717807959; c=relaxed/simple;
	bh=eyfpPJgtOIuG1vIFDolKXcOYY3XJke1VYW8FXO8L9lw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=MhSQ7qNgjbI5CHrN6Uf3HK+TCJu41IftwanSCY0/Hf2p/mfpL8DYjlgiccrkqKMGaSgD+jOyUvNk49XyuMPRfA4E7ENWo8ueOZU0Ua3WCiN2e0pjZSTIWEW3Y3DGTVxvmG0Ln9Kg6zHNfSMIpoT8kuvJwbLvaUUftDiKInaoEVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=idl3dvWV; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="idl3dvWV"
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id BC0DD1140198;
	Fri,  7 Jun 2024 20:52:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 07 Jun 2024 20:52:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1717807955; x=1717894355; bh=/REvkr6D1X9D70grvQc7R30pDYdS
	TCpuO5alixbgfuw=; b=idl3dvWVn5I9w3VyjDNA4Ubxji9+IShx8UWBbSp3dhEM
	uOD2N1vgHND86LvmJBRihlxMeCYK1WzJepAkcxLiWtgXhrTmHwRw34Ih/TCWzS6u
	9ZhLaCYXQbIAWK7Dp5mfFprAllPPt5749QeMLDyWfwASAtlS3hP0kzUzy/Xry6+H
	eYsIHDHvKkgvwQ/LV543zkojg0qhviuwHwF9nSdfdmKB3ZNatIFeeQoSvkw9pbLE
	iUnZyp2h3P0xOOFnW6FF+vIvIPJEmJwicXpI2rEQE6/RRVvg7J6sCnu5BcSIRo4G
	dKoy/nekllowiW68sOkbYj0gQWs5Zwf75fNfFVI1wQ==
X-ME-Sender: <xms:UqtjZgh_5tCr0UUD52YExB7Dmu-rk0SCxgVLAhlI7RAFbmeHBFVQfQ>
    <xme:UqtjZpBim1sa_N1BqSVyXFyan7JSjuo9EEvYDCFIFS3m-G1JkuwkMyH8YwQJc-RMx
    vhP2I717tLzsedCLxw>
X-ME-Received: <xmr:UqtjZoGv1k___eQlePsqXz2yJvGJapPTvsPH5oqtpWf0pJCxiryuwNbthkUGo8E-2O68N1Pmt7C7az7SZsA0Qjd4J_K-6bJmOU0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrfedtvddgfeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevufgjkfhfgggtsehttdertddttddvnecuhfhrohhmpefhihhnnhcu
    vfhhrghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrg
    htthgvrhhnpeelueehleehkefgueevtdevteejkefhffekfeffffdtgfejveekgeefvdeu
    heeuleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hfthhhrghinheslhhinhhugidqmheikehkrdhorhhg
X-ME-Proxy: <xmx:UqtjZhQM5s0kCbeiPk5CsPlJmN7ITTMh8xeiBFxk_JDU9M_OysraDg>
    <xmx:UqtjZtzggBDkc0AysPkaRowYF_gJ4hojVed-FOenIUh21MTTpdEuqQ>
    <xmx:UqtjZv4BnGTTGHp89OAwlx_FBQfsUXkUSpfkcBTIlT8P87DQ0eFzVQ>
    <xmx:UqtjZqye_IxQsC1wIyykMDZd-kOg45Cf_9LW7faBPJH6WOpSiM41Hw>
    <xmx:U6tjZiK-f8KeBmUYH9rnubMuOprY4Mp9NaUXO_JR1a4AWObb5NqDScKX>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 7 Jun 2024 20:52:32 -0400 (EDT)
Date: Sat, 8 Jun 2024 10:52:45 +1000 (AEST)
From: Finn Thain <fthain@linux-m68k.org>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
cc: Khalid Aziz <khalid@gonehiking.org>, 
    "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
    "Martin K. Petersen" <martin.petersen@oracle.com>, 
    Matthew Wilcox <willy@infradead.org>, Hannes Reinecke <hare@suse.com>, 
    Michael Schmitz <schmitzmic@gmail.com>, 
    James Smart <james.smart@broadcom.com>, 
    Ram Vegesna <ram.vegesna@broadcom.com>, 
    Artur Paszkiewicz <artur.paszkiewicz@intel.com>, 
    "Juergen E. Fischer" <fischer@norbit.de>, linux-scsi@vger.kernel.org, 
    linux-kernel@vger.kernel.org, target-devel@vger.kernel.org, 
    kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: add missing MODULE_DESCRIPTION() macros
In-Reply-To: <20240607-md-drivers-scsi-v1-1-17ae31cc4fe5@quicinc.com>
Message-ID: <82cdd602-8faf-5cc0-c0b4-87ff1d820474@linux-m68k.org>
References: <20240607-md-drivers-scsi-v1-1-17ae31cc4fe5@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Fri, 7 Jun 2024, Jeff Johnson wrote:

> diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
> index 742625ac7d99..4eb5770aeef5 100644
> --- a/drivers/scsi/atari_scsi.c
> +++ b/drivers/scsi/atari_scsi.c
> @@ -894,4 +894,5 @@ static struct platform_driver atari_scsi_driver __refdata = {
>  module_platform_driver_probe(atari_scsi_driver, atari_scsi_probe);
>  
>  MODULE_ALIAS("platform:" DRV_MODULE_NAME);
> +MODULE_DESCRIPTION("Atari generic SCSI port driver");
>  MODULE_LICENSE("GPL");

"Atari NCR5380 SCSI driver", please. I don't think the word "generic" 
applies here. It was a reference to the "generic NCR5380 driver by Drew 
Eckhardt" from which specialized drivers like this one were derived.

> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index f6305e3e60f4..1bef131664e0 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -110,6 +110,7 @@ module_param_array(card, int, NULL, 0);
>  MODULE_PARM_DESC(card, "card type (0=NCR5380, 1=NCR53C400, 2=NCR53C400A, 3=DTC3181E, 4=HP C2502)");
>  
>  MODULE_ALIAS("g_NCR5380_mmio");
> +MODULE_DESCRIPTION("Generic NCR5380 driver");
>  MODULE_LICENSE("GPL");
>  
>  static void g_NCR5380_trigger_irq(struct Scsi_Host *instance)

"Generic NCR5380/NCR53C400 SCSI driver" please.

This driver actually describes itself as "generic generic NCR5380 driver" 
which appears to be a joke. The term "generic" was used to mean universal 
i.e. intended to cover every ISA card implementation.

> diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
> index 625fd547ee60..82d8b8f8293f 100644
> --- a/drivers/scsi/initio.c
> +++ b/drivers/scsi/initio.c
> @@ -2939,6 +2939,7 @@ static void initio_remove_one(struct pci_dev *pdev)
>  	pci_disable_device(pdev);
>  }
>  
> +MODULE_DESCRIPTION("Initio 9100U(W) driver");
>  MODULE_LICENSE("GPL");
>  
>  static struct pci_device_id initio_pci_tbl[] = {
> @@ -2961,4 +2962,5 @@ module_pci_driver(initio_pci_driver);
>  
>  MODULE_DESCRIPTION("Initio INI-9X00U/UW SCSI device driver");
>  MODULE_AUTHOR("Initio Corporation");
> +MODULE_DESCRIPTION("TBD");
>  MODULE_LICENSE("GPL");

There are now three MODULE_DESCRIPTION macros here.

> diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
> index a402c4dc4645..f74231ca29e5 100644
> --- a/drivers/scsi/mac_scsi.c
> +++ b/drivers/scsi/mac_scsi.c
> @@ -550,4 +550,5 @@ static struct platform_driver mac_scsi_driver __refdata = {
>  module_platform_driver_probe(mac_scsi_driver, mac_scsi_probe);
>  
>  MODULE_ALIAS("platform:" DRV_MODULE_NAME);
> +MODULE_DESCRIPTION("Generic Macintosh NCR5380 driver");
>  MODULE_LICENSE("GPL");


"Macintosh NCR5380 SCSI driver", please.

> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 7ab000942b97..c4a88f673183 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -68,6 +68,7 @@
>  
>  
>  MODULE_DESCRIPTION("SCSI cdrom (sr) driver");
> +MODULE_DESCRIPTION("TBD");
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_CDROM_MAJOR);
>  MODULE_ALIAS_SCSI_DEVICE(TYPE_ROM);
> @@ -1007,4 +1008,5 @@ static void __exit exit_sr(void)
>  
>  module_init(init_sr);
>  module_exit(exit_sr);
> +MODULE_DESCRIPTION("SCSI CDROM driver");
>  MODULE_LICENSE("GPL");

Three macros here also.
