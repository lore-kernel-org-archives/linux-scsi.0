From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] improvement of fastfail operation
Date: Thu, 1 Apr 2004 00:12:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040331221241.GR24370@suse.de>
References: <1080696593.2075.120.camel@mulgrave> <Pine.LNX.4.44.0403302108550.7851-200000@dyn319701.beaverton.ibm.com> <20040331220416.GQ24370@suse.de> <1080771068.2071.48.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:46020 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262053AbUCaWMr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2004 17:12:47 -0500
Content-Disposition: inline
In-Reply-To: <1080771068.2071.48.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mike Christie <mikenc@us.ibm.com>, Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Mar 31 2004, James Bottomley wrote:
> On Wed, 2004-03-31 at 17:04, Jens Axboe wrote:
> > So the new patch you sent with this mail is no good. Your previous one
> > should be adopted ;-)
> 
> And the:
> 
> 
> 		if (blk_pc_request(req))
> 			leftover = req->data_len - bytes;
> 
> Since end_that_request chunk won't muck with that, is that OK?

It's a bit messy right now really, but it's up to the drivers to modify
that one. So for partial completions, it should be updated to be

	leftover = req->data_len;

as well.

-- 
Jens Axboe

