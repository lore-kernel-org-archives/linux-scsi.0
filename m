From: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Subject: Re: Oops in kmem_cache_free() via bioset_exit() (was Re:
 [next-20180601][nvme][ppc] Kernel Oops is triggered when creating lvm
 snapshots on nvme disks)
Date: Tue, 03 Jul 2018 22:09:06 +0530
Message-ID: <1530635946.24245.15.camel@abdul.in.ibm.com>
References: <1530003645.24245.7.camel@abdul.in.ibm.com>
         <87d0wd7jph.fsf@concordia.ellerman.id.au>
         <1530176707.24245.12.camel@abdul.in.ibm.com>
         <87a7rf55vy.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87a7rf55vy.fsf@concordia.ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-next <linux-next@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, sachinp <sachinp@linux.vnet.ibm.com>, sim <sim@linux.vnet.ibm.com>, manvanth <manvanth@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2018-06-29 at 00:42 +1000, Michael Ellerman wrote:
> Kent, Jens,
> 
> This looks like it might be related to the recent bioset changes?
> 
> cheers
> 
> Abdul Haleem <abdhalee@linux.vnet.ibm.com> writes:
> > On Tue, 2018-06-26 at 23:36 +1000, Michael Ellerman wrote:
> >> Abdul Haleem <abdhalee@linux.vnet.ibm.com> writes:
> ...
> > I was able to reproduce again with slub_debug=FZP and DEBUG_INFO enabled
> > on 4.17.0-rc7-next-20180601, but not much traces other than the Oops stack trace
> 
> Are you still testing on that revision? It's nearly a month old.
> 
> Please try to reproduce on mainline or today's linux-next.

Problem is not reproducible on 4.18.0-rc3 mainline and today's next
kernel

-- 
Regard's

Abdul Haleem
IBM Linux Technology Centre
