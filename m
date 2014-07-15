From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: ANNOUNCE: SCSI XCOPY support for the kernel and device mapper
Date: Tue, 15 Jul 2014 15:26:10 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1407151523120.14632@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1407151359430.5499@file01.intranet.prod.int.rdu2.redhat.com> <20140715185513.GA5331@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933286AbaGOT0k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2014 15:26:40 -0400
In-Reply-To: <20140715185513.GA5331@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Edward Thornber <thornber@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org



On Tue, 15 Jul 2014, Christoph Hellwig wrote:

> On Tue, Jul 15, 2014 at 02:33:13PM -0400, Mikulas Patocka wrote:
> > Hi
> > 
> > I annouce that I released the first version of a patch set that makes it 
> > possible to use SCSI XCOPY offload for the block layer and device mapper.
> > 
> > The patchset is at 
> > http://people.redhat.com/~mpatocka/patches/kernel/xcopy/series.html It 
> > requires kernel version at least 3.16-rc4. It was tested on target-core 
> > iSCSI implementation.
> 
> Can you send the series to the mainling list(s)?  That makes it a lot
> easier to do a quick review.

I'll post them to the lists.

> > The dm-kcopyd subsystem is modified to use the XCOPY command, so device 
> > mapper targets that use it (mirror, snapshot, thin, cache) take advantage 
> > of copy offload automatically.
> 
> That sounds good, do you have any benchmarking data that shows the
> advantage of using XCOPY?

dm-mirror resynchronization is 4 times faster with XCOPY offload, but it 
is just a benchmark on a network with iSCSI between two slow machines.

I hope that we get some benchmarks on a real hardware.

Mikulas
