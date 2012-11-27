From: vinayak holikatti <vinholikatti@gmail.com>
Subject: Re: [PATCH 097/493] scsi: remove use of __devexit_p
Date: Tue, 27 Nov 2012 12:43:19 +0530
Message-ID: <CAKVbJB9MNYU+Q0kkmLnORQyb6=Ua6JesWqaA+pMm98kE2RXswA@mail.gmail.com>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
	<1353349642-3677-97-git-send-email-wfp5p@virginia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34313 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758065Ab2K0HNU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Nov 2012 02:13:20 -0500
Received: by mail-ob0-f174.google.com with SMTP id wc20so10668339obb.19
        for <linux-scsi@vger.kernel.org>; Mon, 26 Nov 2012 23:13:20 -0800 (PST)
In-Reply-To: <1353349642-3677-97-git-send-email-wfp5p@virginia.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bill Pemberton <wfp5p@virginia.edu>
Cc: gregkh@linuxfoundation.org, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Matthew Wilcox <matthew@wil.cx>, Russell King <linux@arm.linux.org.uk>, Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>, Neela Syam Kolli <megaraidlinux@lsi.com>, GOTO Masanori <gotom@debian.or.jp>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, Michael Reed <mdr@sgi.com>, Willem Riede <osst@riede.org>, =?ISO-8859-1?Q?Kai_M=E4kisara?= <Kai.Makisara@kolumbus.fi>, Kurt Garloff <garloff@suse.de>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Arvind Kumar <arvindkumar@vmware.com>, VMware PV-Drivers <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, dc395x@twibble.org, iss_storagedev@hp.com, osst-users@lists.sourceforge.net

>  drivers/scsi/ufs/ufshcd.c                 | 2 +-

Acked-by: Vinayak Holikatti <vinholikatti@gmail.com>

only for drivers/scsi/ufs/ufshcd.c

> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 58f4ba6..4a370f8 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1947,7 +1947,7 @@ static struct pci_driver ufshcd_pci_driver = {
>         .name = UFSHCD,
>         .id_table = ufshcd_pci_tbl,
>         .probe = ufshcd_probe,
> -       .remove = __devexit_p(ufshcd_remove),
> +       .remove = ufshcd_remove,
>         .shutdown = ufshcd_shutdown,
>  #ifdef CONFIG_PM
>         .suspend = ufshcd_suspend,

Thanks,
Vinayak Holikatti
