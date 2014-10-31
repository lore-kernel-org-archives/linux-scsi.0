From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/18] SCSI XCOPY support for the kernel and
 device mapper
Date: Fri, 31 Oct 2014 08:36:14 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1410310833370.29662@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1410220913280.31351@file01.intranet.prod.int.rdu2.redhat.com> <544CD24B.2020505@acm.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <544CD24B.2020505@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Edward Thornber <thornber@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On Sun, 26 Oct 2014, Bart Van Assche wrote:

> On 10/22/14 15:24, Mikulas Patocka wrote:
> > I uploaded the new version of SCSI/device-mapper XCOPY patches here:
> > http://people.redhat.com/~mpatocka/patches/kernel/xcopy/series.html
> > 
> > I am also sending the patches in the following emails.
> 
> Hello Mikulas,
> 
> Which is the base commit of this patch series ? Patch 5/18 fails to apply on
> top of kernel v3.18-rc1 + patches 1..4.
> 
> Thanks,
> 
> Bart.

Hi

I have just tried it and it applies, on 3.18-rc1, 3.18-rc2 or current git 
head.

# quilt push
Applying patch scsi-xcopy-2bios.patch
patching file block/blk-lib.c
patching file include/linux/blk_types.h
patching file block/bio.c
Hunk #2 succeeded at 567 (offset 35 lines).
Hunk #3 succeeded at 1752 (offset 35 lines).
Hunk #4 succeeded at 1799 (offset 35 lines).
patching file block/blk-core.c
patching file drivers/scsi/sd.c

Now at patch scsi-xcopy-2bios.patch

Mikulas
