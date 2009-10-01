From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] drivers/scsi/mvsas: mvsas driver supported device list
 to inlcude Adaptec ASC-1045/1405 SAS/SATA Controllers
Date: Thu, 01 Oct 2009 15:27:21 +0000
Message-ID: <1254410841.3885.6.camel@mulgrave.site>
References: <4CA9DA403FFEC64AA62B3C295F8D47B7212674D868@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42069 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597AbZJAP1Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Oct 2009 11:27:24 -0400
In-Reply-To: <4CA9DA403FFEC64AA62B3C295F8D47B7212674D868@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yugendranath R Singh <yugendranath.s@hcl.in>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andy Yan <ayan@marvell.com>, Ke Wei <kewei@marvell.com>

On Thu, 2009-10-01 at 20:35 +0530, Yugendranath R Singh wrote:
> Please find the patch below which adds the Adaptec ASC 1045/1405
> controllers to mvsas driver supported device list, for kernel version
> 2.6.31.1.

I think you need to read Documentation/SubmittingPatches first.

I need a Signed-off-by line

The patch also should be generated against either upstream or one of the
SCSI git trees.  Backporting to a stable tree is something that gets
done after the patch is upstream. (doesn't really matter in this case,
since the code is unchanged).

> -----
> diff -uprN a/linux-2.6.31.1/drivers/scsi/mvsas/mv_init.c b/linux-2.6.31.1/drivers/scsi/mvsas/mv_init.c
> --- a/linux-2.6.31.1/drivers/scsi/mvsas/mv_init.c       2009-09-24 21:15:25.000000000 +0530
> +++ b/linux-2.6.31.1/drivers/scsi/mvsas/mv_init.c       2009-10-02 00:03:53.000000000 +0530
> @@ -653,6 +653,7 @@ static struct pci_device_id __devinitdat
>         { PCI_VDEVICE(MARVELL, 0x6485), chip_6485 },
>         { PCI_VDEVICE(MARVELL, 0x9480), chip_9480 },
>         { PCI_VDEVICE(MARVELL, 0x9180), chip_9180 },
> +       { PCI_VDEVICE(ADAPTEC2, 0x0450), chip_6440 },
> 
>         { }     /* terminate list */
>  };

This patch actually won't apply (try it from the email list).  Your
mailer has converted the tabs to spaces and done other text mangling.
We have a file: Documentation/email-clients.txt that tries to advise on
the various mailer settings to make this work.  However, if you have
outlook, there's apparently nothing that can be done and you'll need to
attach the patch instead of inlining it.

James


