From: Olaf Hering <olh@suse.de>
Subject: Re: 2.6.3 CONFIG_SCSI_AIC7 X X X Kconfig bug
Date: Thu, 11 Mar 2004 13:53:33 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040311125333.GC19457@suse.de>
References: <20040308211148.08cd89ff.rddunlap@xenotime.net> <20040311124646.GG2148@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:58051 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S261244AbUCKMxg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2004 07:53:36 -0500
Content-Disposition: inline
In-Reply-To: <20040311124646.GG2148@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: "Randy.Dunlap" <rddunlap@xenotime.net>, linux-scsi@vger.kernel.org, jejb <james.bottomley@steeleye.com>, gibbs@scsiguy.com

 On Thu, Mar 11, Matthew Wilcox wrote:

> =20
>  config SCSI_SATA
>  	bool "Serial ATA (SATA) support"
> -	depends on SCSI && EXPERIMENTAL
> +	depends on EXPERIMENTAL
>  	help
>  	  This driver family supports Serial ATA host controllers
>  	  and devices.
> @@ -397,7 +397,7 @@ config SCSI_SATA
> =20
>  config SCSI_SATA_SVW
>  	tristate "ServerWorks Frodo / Apple K2 SATA support (EXPERIMENTAL)"
> -	depends on SCSI_SATA && PCI && EXPERIMENTAL
> +	depends on SCSI_SATA && PCI && (X86 || PPC) && EXPERIMENTAL

how do you handle the SCSI=3Dm here? sata remains =3Dy. I havent tried =
to
load scsi_mod and sd_mod, is SCSI=3Dm supposed to work for SATA?

--=20
USB is for mice, FireWire is for men!

sUse lINUX ag, n=C3=9CRNBERG
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
