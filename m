From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] fix blockdev --getro for sr, sd, ide-floppy devs
Date: Thu, 22 Jan 2004 09:27:33 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040122082733.GD2466@suse.de>
References: <1074548160.3088.11.camel@lintest.iomegacorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:29589 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S266014AbUAVI1i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 03:27:38 -0500
Content-Disposition: inline
In-Reply-To: <1074548160.3088.11.camel@lintest.iomegacorp.com>
List-Id: linux-scsi@vger.kernel.org
To: John McKell <mckellj@iomega.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Jan 19 2004, John McKell wrote:
> This 2.6.1 patch works by setting gendisk->policy to the correct value
> during initialization as the various drivers decide whether or not the
> disk is writeable.  This patch persuades "blockdev --getro ..." to
> correctly report the read-only state of a newly inserted disk.  This
> patch applies to sr.c, sd.c and ide-floppy.c.  ide-cd.c already has
> this functionality built into it.

Patch looks good, thanks.


-- 
Jens Axboe

