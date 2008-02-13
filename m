From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] 2.6.25-rc1-git2: GDT SCSI: change drivers/scsi/gdth.c
 into using pci_get device
Date: Wed, 13 Feb 2008 10:57:37 +0200
Message-ID: <47B2B101.3090106@panasas.com>
References: <47B1ADCE.40202@larces.uece.br>	 <1202833354.3137.19.camel@localhost.localdomain>	 <47B1CF45.5070407@panasas.com>  <47B23033.1080100@larces.uece.br> <1202861823.3137.170.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:11395 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756009AbYBMI5y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Feb 2008 03:57:54 -0500
In-Reply-To: <1202861823.3137.170.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sergio Luis <sergio@larces.uece.br>, Achim Leubner <achim_leubner@adaptec.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>

On Wed, Feb 13 2008 at 2:17 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Tue, 2008-02-12 at 20:48 -0300, Sergio Luis wrote:
>> reposting an updated version of it. Please check if it's ok.
> 
> Looks fine, thanks!  You added an extra space at the end of 
> 
> while ((pdev = pci_get_device(vendor, device, pdev)) 
> 
> Which I fixed.  Unfortunately checkpatch isn't very helpful for this
> driver since it uses spaces not tabs everywhere, which checkpatch really
> hates.
> 
> James
> 
> 
James hi
This patch is now obsolete. After Jeff's patch to convert it to 
hot plug API. Jeffs patch looks very good to me. I will try
to push it through the testers.

I still don't have a card for testing myself. Again anyone
wants to send me a card. Intel people anybody home?

I will add the missing Kconfig hunk to jeff's patch and will
push it after it is tested.

Thanks
Boaz
