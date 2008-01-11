From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 1/1] blktrace: Add blktrace ioctls to SCSI generic devices
Date: Fri, 11 Jan 2008 10:11:42 +0100
Message-ID: <20080111091142.GL6258@kernel.dk>
References: <20080107074556.114594000@de.ibm.com> <20080107074647.784615000@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:19693 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722AbYAKJLp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2008 04:11:45 -0500
Content-Disposition: inline
In-Reply-To: <20080107074647.784615000@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-btrace@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Jan 07 2008, Christof Schmitt wrote:
> From: Christof Schmitt <christof.schmitt@de.ibm.com>
> 
> Since the SCSI layer uses the request queues from the block layer, blktrace can
> also be used to trace the requests to all SCSI devices (like SCSI tape drives),
> not only disks. The only missing part is the ioctl interface to start and stop
> tracing.
> 
> This patch adds the SETUP, START, STOP and TEARDOWN ioctls from blktrace to the
> sg device files. With this change, blktrace can be used for SCSI devices like
> for disks, e.g.: blktrace -d /dev/sg1 -o - | blkparse -i -
> 
> Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>

Looks fine to me, queued up for 2.6.25.


-- 
Jens Axboe

