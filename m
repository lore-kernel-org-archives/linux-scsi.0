From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] gdth: don't map zero-length requests
Date: Sun, 5 Feb 2006 19:43:39 +0100
Message-ID: <20060205184338.GB5124@suse.de>
References: <20060205153623.GA14143@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:55391 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1751207AbWBESmv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Feb 2006 13:42:51 -0500
Content-Disposition: inline
In-Reply-To: <20060205153623.GA14143@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Sun, Feb 05 2006, Christoph Hellwig wrote:
> From: Jenx Axboe <axboe@suse.de>
> 
> Don't map zero-length requests in gdth, zome architectures don't like
> that in their dma mapping routines.
> 
> [ I'm pretty sure Jens posted this before, but for some reason it got
>   forgotten  --hch ]

Thanks for reposting Christoph, James can you please pick this up?


-- 
Jens Axboe

