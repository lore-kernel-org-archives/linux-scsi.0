From: Jens Axboe <axboe@suse.de>
Subject: Re: Compile problems in 2.4.20 (fwd)
Date: Wed, 22 Jan 2003 08:57:12 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030122075712.GV20780@suse.de>
References: <Pine.LNX.4.44.0301211409340.27041-100000@wizardsworks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0301211409340.27041-100000@wizardsworks.org>
List-Id: linux-scsi@vger.kernel.org
To: Sir Ace <chandleg@wizardsworks.org>, linux-scsi@vger.kernel.org

On Tue, Jan 21 2003, Sir Ace wrote:
> 
> I am attempting a compile of linus's tree of 2.4.20 on hppa platform
> linux.  I am getting the error below.  I'm not a developer, but after
> looking at the code, it really isn't defined anywhere that I could find.
> 
> make[2]: Entering directory `/usr/src/linux-2.4.20/drivers/scsi'
> make all_targets
> make[3]: Entering directory `/usr/src/linux-2.4.20/drivers/scsi'
> gcc -D__KERNEL__ -I/usr/src/linux-2.4.20/include -Wall -Wstrict-prototypes
> -Wno-trigraphs -O2 -fno-strict-aliasing -fno-common -fomit-frame-pointer
> -D__linux__ -pipe -fno-strength-reduce -mno-space-regs
> -mfast-indirect-calls -mdisable-fpregs -ffunction-sections -march=1.1
> -mschedule=7200   -nostdinc -iwithprefix include
> -DKBUILD_BASENAME=scsi_merge  -c -o scsi_merge.o scsi_merge.c
> scsi_merge.c: In function `__count_segments':
> scsi_merge.c:225: warning: implicit declaration of function `page_to_phys'
> scsi_merge.c: In function `initialize_merge_fn':
> scsi_merge.c:1198: `PCI_DMA_BUS_IS_PHYS' undeclared (first use in this
> function)scsi_merge.c:1198: (Each undeclared identifier is reported only
> once

hppa hasn't been updated to support the required functions to do direct
io to highmem pages. bug the hppa developers :)

-- 
Jens Axboe

