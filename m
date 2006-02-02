From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 1/1] blk: Fix SG_IO ioctl failure retry looping
Date: Thu, 2 Feb 2006 18:40:32 +0100
Message-ID: <20060202174032.GB4215@suse.de>
References: <200602021729.k12HTtmg018944@d03av02.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:65374 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1750831AbWBBRiZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2006 12:38:25 -0500
Content-Disposition: inline
In-Reply-To: <200602021729.k12HTtmg018944@d03av02.boulder.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Feb 02 2006, Brian King wrote:
> 
> When issuing an SG_IO ioctl through sd that resulted
> in an unrecoverable error, a nearly infinite retry loop
> was discovered. This is due to the fact that the block
> layer SG_IO code is not setting up rq->retries. This
> patch also fixes up the sg_scsi_ioctl path.

Looks good, applied. Thanks!

-- 
Jens Axboe

