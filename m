From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] improvement of fastfail operation
Date: 31 Mar 2004 17:11:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080771068.2071.48.camel@mulgrave>
References: <1080696593.2075.120.camel@mulgrave>
	<Pine.LNX.4.44.0403302108550.7851-200000@dyn319701.beaverton.ibm.com>
	<20040331220416.GQ24370@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:22710 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261939AbUCaWLS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2004 17:11:18 -0500
In-Reply-To: <20040331220416.GQ24370@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Mike Christie <mikenc@us.ibm.com>, Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-03-31 at 17:04, Jens Axboe wrote:
> So the new patch you sent with this mail is no good. Your previous one
> should be adopted ;-)

And the:


		if (blk_pc_request(req))
			leftover = req->data_len - bytes;

Since end_that_request chunk won't muck with that, is that OK?

James


