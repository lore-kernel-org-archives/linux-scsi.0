From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 3/3] cciss: add put_disk into cleanup routines
Date: Fri, 18 Nov 2005 22:03:00 +0100
Message-ID: <20051118210300.GD25454@suse.de>
References: <20051118174655.GA22116@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:13107 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1161225AbVKRVCA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2005 16:02:00 -0500
Content-Disposition: inline
In-Reply-To: <20051118174655.GA22116@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mikem <mikem@beardog.cca.cpqcorp.net>
Cc: akpm@osdl.org, jgarzick@pobox.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Nov 18 2005, mikem wrote:
> Patch 3 of 3
> 
> Jeff Garzik pointed me to his code to see how to remove a disk from
> the system _properly_. Well, here it is...
> Every place we remove disks we are now testing before calling del_gendisk
> or blk_cleanup_queue and then call put_disk.

Thanks, applied.

-- 
Jens Axboe

