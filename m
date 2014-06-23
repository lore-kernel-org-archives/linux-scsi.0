From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: sd_setup_discard_cmnd: BUG: unable to handle kernel NULL pointer dereference at (null)
Date: Mon, 23 Jun 2014 15:37:03 -0400
Message-ID: <yq1vbrrh0yo.fsf@sermon.lab.mkp.net>
References: <53A28B21.7070500@profihost.ag>
	<yq1ionwjn15.fsf@sermon.lab.mkp.net>
	<20140620155321.GA24389@soda.linbit>
	<yq1wqcbil0c.fsf@sermon.lab.mkp.net>
	<20140620182956.GB24389@soda.linbit>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48676 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945AbaFWThg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jun 2014 15:37:36 -0400
In-Reply-To: <20140620182956.GB24389@soda.linbit> (Lars Ellenberg's message of
	"Fri, 20 Jun 2014 20:29:56 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, JBottomley@parallels.com, Jens Axboe <axboe@kernel.dk>, konrad.wilk@oracle.com, elder@linaro.org, Josh Durgin <josh.durgin@inktank.com>, Greg KH <gregkh@linuxfoundation.org>

>>>>> "Lars" == Lars Ellenberg <lars.ellenberg@linbit.com> writes:

Lars,

Thanks for fixing this. 

I'd still like to see you use the lib call instead like you do for
zeroout. I have some patches in the pipeline for multi-range discard
support and things are going to break for drbd if you manually roll
bios.

Lars> linux upstream DRBD also does blk_queue_max_write_same_sectors(q,
Lars> 0) and blk_queue_max_discard_sectors(q, DRBD_MAX_DISCARD_SECTORS)

Great!

-- 
Martin K. Petersen	Oracle Linux Engineering
