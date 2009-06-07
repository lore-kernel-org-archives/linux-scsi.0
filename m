From: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: 2.6.30-rc8 Oops whilst booting
Date: Mon, 08 Jun 2009 04:01:21 +0530
Message-ID: <1244413881.18742.31.camel@ht.satnam>
References: <200906061959.55592.chris2553@googlemail.com>
	 <200906062215.30571.chris2553@googlemail.com>
	 <1244381140.30664.12.camel@ht.satnam>
	 <c6b1100b0906071138g2c46fb34vc1a2beb9438f1f1e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:57485 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbZFGWaK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Jun 2009 18:30:10 -0400
In-Reply-To: <c6b1100b0906071138g2c46fb34vc1a2beb9438f1f1e@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Clayton <chris2553@googlemail.com>
Cc: linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, scsi <linux-scsi@vger.kernel.org>, NeilBrown <neilb@suse.de>, Tejun Heo <tj@kernel.org>

On Sun, 2009-06-07 at 19:38 +0100, Chris Clayton wrote:
> 2009/6/7 Jaswinder Singh Rajput <jaswinder@kernel.org>:
> > Hello Chris,
> >
> 
> Hello Jaswinder
> 
> and thanks for the reply.
> 
> > On Sat, 2009-06-06 at 22:15 +0100, Chris Clayton wrote:
> >> Sorry, I've just realised what a poor report my earlier email was. I should also have said that the
> >> kernel has booted succesfully. At the time of reporting I had had two panics. I've just done
> >> another git pull, so the kernel is bang up to date with kernel.org, but after building and
> >> installing, a reboot resulted in another panic. The system then booted OK after switch off and on
> >> again.
> >>
> >> Please cc me to any reply, I'm not subscribed.
> >>
> >>
> >> On Saturday 06 June 2009, Chris Clayton wrote:
> >> > Hi,
> >> >
> >> > After a git pull earlier today, I've had oopsen whilst booting the system
> >> > twice today: A photo of the oops message can be viewed at:
> >> >
> >> > http://img231.imageshack.us/img231/8931/dscn0610.jpg
> >> >
> >> > I haven't used the 2.6.30-rc kernels very much, so I don't have a clue when
> >> > the problem was introduced. I have no problems at all with 2.6.29.4.
> >> >
> >
> > Can you provide your .config and dmesg of working and non-working
> > kernel.
> >
> > Thanks,
> > --
> > JSR
> >
> >
> 
> Sorry for delay in replying - I've been bisecting but ended up with:
> 
> commit 60a0cd528d761c50d3a0a49e8fbaf6a87e64254a
> Merge: e25e092 8e35961
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Commit: Linus Torvalds <torvalds@linux-foundation.org>
> 
>     Merge branch 'merge' of
> git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc
> 
>     * 'merge' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc:
>       powerpc/mm: Fix broken MMU PID stealing on !SMP
> 

Based on this I added some CCs.

> which seems wrong given I have and x86 machine. I guess I didn't try
> enough reboots before reporting a kernel as good.
> 
> However, I did get two bad boots. The dmesg for a good boot and config
> are attached. As I don't get to user space on a bad boot, I can't
> provide a dmesg, but a photograph of the panic can be viewed at
> http://img99.imageshack.us/my.php?image=dscn0617b.jpg
> 

Error message will be in previous screen, can you do some page up and
capture the output.

And .config is same for Good and Bad.

--
JSR


