From: Jens Axboe <axboe@suse.de>
Subject: Re: "do ata" scsi command?
Date: Fri, 16 May 2003 08:03:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030516060324.GT812@suse.de>
References: <20030515230223.GA516@gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:7376 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S264294AbTEPFuj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2003 01:50:39 -0400
Content-Disposition: inline
In-Reply-To: <20030515230223.GA516@gtf.org>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Thu, May 15 2003, Jeff Garzik wrote:
> In terms of a userspace interface for my ata-over-scsi gadget, I would
> prefer to use /dev/sg instead of inventing a totally new interface.
> That, in turn, implies a need for a "do ata taskfile" scsi command,
> which is sorta like ATAPI in reverse:  we are wrapping a raw ata
> taskfile inside a scsi cdb.
>
> My question is, does an existing standard or spec exist for such an idea?
> 
> If not, I'll just roll my own.

For ATAPI/SCSI like stuff, you have SG_IO. No need to invent yet another
submission interface for that. For ata, you have HDIO_DRIVE_TASKFILE
which is getting to be sane on the kernel side after Bart cleaned it up.

-- 
Jens Axboe

