From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: "do ata" scsi command?
Date: Fri, 16 May 2003 15:31:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC53C84.7020306@pobox.com>
References: <20030515230223.GA516@gtf.org> <3EC53307.5070908@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:52940 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264592AbTEPTSp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2003 15:18:45 -0400
In-Reply-To: <3EC53307.5070908@rogers.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <tluben@rogers.com>
Cc: linux-scsi@vger.kernel.org, axboe@suse.de

Luben Tuikov wrote:
> It seems like you want what the 3ware LLDD is doing.  The format
> and specs are closed, but the implementation is open: ioctl
> and a char device ioctl.
> 
> What you lose is the block/scsi synchronizaion, but if you want
> to support _closed_ vendor extensions, that's what you get.

This is for programming the drive via userspace.  Same purpose as 
HDIO_DRIVE_TASKFILE.  I would rather move non-essential stuff to 
userspace where possible.  Sending taskfiles directly allows one to 
validate the driver without other parts of the kernel getting in the 
way.  That allows me to narrow down problems to my driver, or 
not-my-driver.  :)

But since it's _far_ more contentious than I thought it would be, I'll 
just put it off until later.


> Unless what you want to support has a command mapping already
> in SCSI?  Did you check SBC-2, SMC-2, SCC-2, SES-2?  Wouldn't
> you find any CDB's there which would fit in?  My guess is not.

I would like to create a target that is fully verifyable as SCSI-2, and 
eventually SCSI-3.  So I _do_ want to support such mappings.  But that 
is parallel to the capability of talking directly to the ATA device.

	Jeff



