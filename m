From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Marvell 6440 SAS/SATA driver (draft)
Date: Thu, 10 Jan 2008 02:09:00 -0500
Message-ID: <4785C48C.50705@garzik.org>
References: <6b2481670801092253v666e969doe5ec2bd77e10a87e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <6b2481670801092253v666e969doe5ec2bd77e10a87e@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Ke Wei <kewei.mv@gmail.com>
Cc: linux-scsi@vger.kernel.org, kewei@marvell.com, qswang@marvell.com, jfeng@marvell.com, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Ke Wei wrote:
> The 88SE6440 driver :
> 
> The driver is based on bare code from Jeff Garzik. And it can work
> under linux kernel 2.6.23.
> By far, Can discover and find SAS HDD, but SATA is currently
> unsupported. Command queue depth can be above 1.
> Most error handling, and some phy handling code is notably missing.
> 
> 
> contains the following updates:
> 
> --- mvsas_orig.c	2007-12-06 19:21:32.000000000 -0500
> +++ mvsas.c	2008-01-09 04:53:14.000000000 -0500

Fantastic!  I'm delighted to see this is moving, and thanks much for 
getting the driver to that critical "it works" milestone.

We should note for the linux-scsi audience and potential testers that 
the base driver upon which this is based is available on the "sas" branch of

git://git.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

I will give some substantive comments tomorrow (just got back from long 
trip).  Two quick suggestions:

1) To make it easier for people to review and test the driver, I would 
suggest posting a diff against 2.6.24-rc7 (or 2.6.23), ignoring my 
original code.  Thus, it would result in a patch

2) In future patches, include a Signed-off-by: line when you are ready 
for your patch to be included in the kernel.

Thanks!

	Jeff


