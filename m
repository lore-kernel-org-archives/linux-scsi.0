From: vinayak holikatti <vinholikatti@gmail.com>
Subject: Re: [PATCH 192/493] scsi: remove use of __devinit
Date: Tue, 27 Nov 2012 17:02:51 +0530
Message-ID: <CAKVbJB9wTj9HtXYTW0Le+oHsdMACkuBnf2jSXu-pAx+gPKoBYA@mail.gmail.com>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
	<1353349642-3677-192-git-send-email-wfp5p@virginia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:48056 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab2K0Lcy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Nov 2012 06:32:54 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so12306150oag.19
        for <linux-scsi@vger.kernel.org>; Tue, 27 Nov 2012 03:32:52 -0800 (PST)
In-Reply-To: <1353349642-3677-192-git-send-email-wfp5p@virginia.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bill Pemberton <wfp5p@virginia.edu>
Cc: gregkh@linuxfoundation.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Matthew Wilcox <matthew@wil.cx>, Russell King <linux@arm.linux.org.uk>, Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>, Neela Syam Kolli <megaraidlinux@lsi.com>, GOTO Masanori <gotom@debian.or.jp>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, Geoff Levand <geoff@infradead.org>, Michael Reed <mdr@sgi.com>, Willem Riede <osst@riede.org>, =?ISO-8859-1?Q?Kai_M=E4kisara?= <Kai.Makisara@kolumbus.fi>, Kurt Garloff <garloff@suse.de>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Arvind Kumar <arvindkumar@vmware.com>, VMware PV-Drivers <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, dc395x@twibble.org, iss_storagedev@hp.com, linuxppc-dev@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org, osst-users

>  drivers/scsi/ufs/ufshcd.c                 |  2 +-

Acked-by: Vinayak Holikatti <vinholikatti@gmail.com>

only for drivers/scsi/ufs/ufshcd.c

> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 4a370f8..a79ff87 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1811,7 +1811,7 @@ static int ufshcd_set_dma_mask(struct ufs_hba *hba)
>   *
>   * Returns 0 on success, non-zero value on failure
>   */
> -static int __devinit
> +static int
>  ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  {
>         struct Scsi_Host *host;


-- 
Regards,
Vinayak Holikatti
