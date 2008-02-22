From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Marvell 6440 SAS/SATA driver
Date: Fri, 22 Feb 2008 11:26:25 -0500
Message-ID: <47BEF7B1.1090905@garzik.org>
References: <FE3F06125A99254E8D92161AA4569C6F02310B1A@sc-exch02.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:55717 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014AbYBVQ0b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Feb 2008 11:26:31 -0500
In-Reply-To: <FE3F06125A99254E8D92161AA4569C6F02310B1A@sc-exch02.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ke Wei <kewei@marvell.com>
Cc: Ke Wei <kewei.mv@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Michael Wang <qswang@marvell.com>, Jacky Feng <jfeng@marvell.com>, Qun Zhao <qzhao@marvell.com>, Larry Li <lil@marvell.com>, saeed bishara <saeed.bishara@gmail.com>

Ke Wei wrote:
> Added support for Expander. Based on version 0.1 for mvsas.
> 
> 
> Signed-off-by: Ke Wei <kewei@marvell.com>
> ---
> diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
> old mode 100644
> new mode 100755
> index 03638b9..3c7a154
> --- a/drivers/scsi/mvsas.c
> +++ b/drivers/scsi/mvsas.c
> @@ -2,6 +2,7 @@
>  	mvsas.c - Marvell 88SE6440 SAS/SATA support
>  
>  	Copyright 2007 Red Hat, Inc.
> +	Copyright 2008 Marvell. <kewei@marvell.com>
>  
>  	This program is free software; you can redistribute it and/or
>  	modify it under the terms of the GNU General Public License as
> @@ -25,6 +26,13 @@
>  	  structures.  this permits elimination of all the le32_to_cpu()
>  	  and cpu_to_le32() conversions.
>  
> +	Changelog:
> +	2008-02-22	0.5	Added support for Expander.
> +	2008-02-05	0.4	Added support for hotplug and wide port.
> +	2008-01-22	0.3	Added support for SAS HD and SATA Devices.
> +	2008-01-09	0.2	detect SAS disk.
> +	2007-09-25	0.1	rough draft, Initial version.
> +
>   */
>  
>  #include <linux/kernel.h>


Technical content:  looks good, ACK

Patch content:  looks diff'd against correct version, ACK

But we still have one major process problem, and a couple minor problems 
to fix:

1) [minor] please do not include a changelog in the source code.  That's 
what the git repository history is for.

2) [minor] Your patch description (email body) is incorrect.  It should 
describe all changes since version 0.1, the version you diff'd against:

	Convert rough draft Marvell 6440 driver to a working driver.

	Added support for SAS and SATA devices, hotplug, wide port,
	and expanders.

3) [minor] Your email subject should reflect that you are updating 
version 0.1, the version you diff'd against:

	[PATCH] mvsas: convert from rough draft to working driver

4) [major] Your email was encoded in base64, which makes it difficult 
for automated tools to handle, and difficult for some mail clients to 
view and reply-to.

It will require some email configuration on your part to disable this, 
and send the email as a text/plain message.

I've copied Saeed Bishara @ Marvell on this email.  Saeed has been 
successfully sending patch for the sata_mv driver (5040, 6080, 6042, 
etc.)  Maybe Saeed can advise you on his email setup?



In any case, once we fix this last problem -- base64 -- we can finally 
apply your patch and get things moving.

You are very close to having a working Linux kernel development setup, 
thanks for your patience!

	Jeff




