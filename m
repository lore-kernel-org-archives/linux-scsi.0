From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Marvell 6440 SAS/SATA driver (draft)
Date: Thu, 10 Jan 2008 02:21:08 -0500
Message-ID: <4785C764.3070407@garzik.org>
References: <6b2481670801092253v666e969doe5ec2bd77e10a87e@mail.gmail.com> <4785C48C.50705@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4785C48C.50705@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Ke Wei <kewei.mv@gmail.com>
Cc: linux-scsi@vger.kernel.org, kewei@marvell.com, qswang@marvell.com, jfeng@marvell.com, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> 1) To make it easier for people to review and test the driver, I would 
> suggest posting a diff against 2.6.24-rc7 (or 2.6.23), ignoring my 
> original code.  Thus, it would result in a patch

Er, that sentence was incomplete.  Continuing...


Thus it would result in a patch that adds a new file 
drivers/scsi/mvsas.c to the 2.6.24-rc7 kernel, and modifies 
drivers/scsi/Makefile and drivers/scsi/Kconfig to enable this new driver.

That is the format that developers and users are most familiar with, 
when reviewing (and testing) a new driver.

But of course this is a draft, so these guidelines are certainly loose...

	Jeff



