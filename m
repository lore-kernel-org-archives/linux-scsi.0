From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-2.6.23-mm1 crashed
Date: Sun, 14 Oct 2007 12:31:01 -0700
Message-ID: <20071014123101.208b102b.akpm@linux-foundation.org>
References: <2a382c6e0710141145j51286bd0o8a2eb307f7455cd@mail.gmail.com>
	<2a382c6e0710141224n2b8a47c8v1346f1a9dedc7943@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762313AbXJNTbV@vger.kernel.org>
In-Reply-To: <2a382c6e0710141224n2b8a47c8v1346f1a9dedc7943@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Milter <davemilter@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


(please don't top-post!  edited...)

On Sun, 14 Oct 2007 23:24:39 +0400 "Dave Milter" <davemilter@gmail.com> wrote:

> On 10/14/07, Dave Milter <davemilter@gmail.com> wrote:
> > I build linux-2.6.23-mm1 and try to boot it using qemu,
> > and it crashed with trace like this:
> > do_page_fault
> > error_code
> > lock_acquire
> > _spin_lock_irqsave
> > gdth_timeout
> > run_timer_softirq
> > __do_softirq
> > do_softirq
> >
> > I have screenshot, but have no idea, is it legal to include it, if I
> > sent copy to lkml.
> > config of kernel in attachment,
> > I apply all three patches from hot-fixes.
> >
>
> By the way, because of oops happens on early stage of boot,
> you not need any image to reproduce this bug:
> something like this will be enough:
> 1)cd /tmp/ && qemu-img create hda.img 10M
> 2)cd linux/mm/source/code
> 3)qemu -kernel arch/i386/boot/bzImage -hda /tmp/hda.img
> 
> if you add "-s" to qemu options you can after that do:
> gdb vmlinux
> $target remote localhost:1234
> $br gth_timeout
> $continue
> 

I didn't notice that qemu was involved.  Does qemu have an emulator for the
gdth hardware?  
