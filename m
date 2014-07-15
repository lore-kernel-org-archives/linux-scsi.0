From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ANNOUNCE: SCSI XCOPY support for the kernel and device mapper
Date: Tue, 15 Jul 2014 11:55:13 -0700
Message-ID: <20140715185513.GA5331@infradead.org>
References: <alpine.LRH.2.02.1407151359430.5499@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41928 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932826AbaGOSzQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jul 2014 14:55:16 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1407151359430.5499@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Edward Thornber <thornber@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jul 15, 2014 at 02:33:13PM -0400, Mikulas Patocka wrote:
> Hi
> 
> I annouce that I released the first version of a patch set that makes it 
> possible to use SCSI XCOPY offload for the block layer and device mapper.
> 
> The patchset is at 
> http://people.redhat.com/~mpatocka/patches/kernel/xcopy/series.html It 
> requires kernel version at least 3.16-rc4. It was tested on target-core 
> iSCSI implementation.

Can you send the series to the mainling list(s)?  That makes it a lot
easier to do a quick review.

> The dm-kcopyd subsystem is modified to use the XCOPY command, so device 
> mapper targets that use it (mirror, snapshot, thin, cache) take advantage 
> of copy offload automatically.

That sounds good, do you have any benchmarking data that shows the
advantage of using XCOPY?

