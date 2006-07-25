From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/3] scsi : megaraid_{mm,mbox}: 64-bit DMA capability
	checker
Date: Tue, 25 Jul 2006 17:10:42 +0200
Message-ID: <1153840242.8932.33.camel@laptopd505.fenrus.org>
References: <890BF3111FB9484E9526987D912B261932E2CF@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932419AbWGYPKx@vger.kernel.org>
In-Reply-To: <890BF3111FB9484E9526987D912B261932E2CF@NAMAIL3.ad.lsil.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: vvs@sw.ru, James.Bottomley@SteelEye.com, akpm@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@engenio.com>, "Yang, Bo" <Bo.Yang@engenio.com>
List-Id: linux-scsi@vger.kernel.org


> +1.	Fixed a bug in megaraid_init_mbox().
> +	Customer reported "garbage in file on x86_64 platform".
> +	Root Cause: the driver registered controllers as 64-bit DMA
> capable
> +	for those which are not support it.
> +	Fix: Made change in the function inserting identification
> machanism
> +	identifying 64-bit DMA capable controllers.
> +

Hi,

unfortunately your patch has been corrupted by your email program,
and as such can't be applied by the scsi maintainer. It might be 
a good idea to fix your email program and then resend quickly before 
James notices ;)

Greetings,
   Arjan van de Ven
