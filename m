From: Ishikawa <ishikawa@yk.rim.or.jp>
Subject: Re: Problem with Gdt driver under smp?
Date: Thu, 07 Nov 2002 14:10:19 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DC9F5BB.287AFAE2@yk.rim.or.jp>
References: <3DC0EBB3.9030707@holidaymarketing.com> <20021031120257.GF23217@redhat.com> <3DC71BF8.80100@holidaymarketing.com> <20021105033435.GA16634@redhat.com> <3DC79701.8070802@holidaymarketing.com> <20021105164106.GG16634@redhat.com> <3DC87019.3000504@holidaymarketing.com> <3DC88DD4.2010301@holidaymarketing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yk.rim.or.jp (really [127.0.0.1]) by yk.rim.or.jp
	via smail with esmtp
	id <m189ew7-000GyXC@standard.erephon> (Debian Smail3.2.0.114)
	for <linux-scsi@vger.kernel.org>; Thu, 7 Nov 2002 14:10:35 +0900 (JST)
List-Id: linux-scsi@vger.kernel.org
To: Pedro Pla <pedropla@holidaymarketing.com>
Cc: linux-scsi@vger.kernel.org, linux-smp@vger.kernel.org

Pedro Pla wrote:
> 
> Just to eliminate the possibility of a faulty cpu in up mode I swapped
> cpus and it continues to run flawlessly in up, not sure how to eliminate
> the possibility of it being the cache controller or the ram since all
> simms tested so far failed in mp and ran flawlessly in up, could it be a
> bios issue? I think I'm just trying anything and everything to locate
> the exact problem now. Any test ideas that could help me pinpoint it?

Hmm, the woes of sysadmins. You have my sympathy.

In the earlier post, you mentioned, 
> I've tried 
> kernels from the 2.2.22 to the 2.4.17-2.4.20-pre10-ac with pre11 patches 
> applied on top.

You also mentioned that the hardware is certified by
Intel and RedHat to be linux-compatible.

May I suggest that you try a version of RedHat linux
(and its drivers) 
instead of compiling a kernel yourself?
Maybe RedHat has applied a patch or something that
makes the board work with *THEIR* version of
linux kernel and drivers?

(I have a few DELL linux servers at the office and
they run RedHat linux pre-installed, and I have
no desire to tinker with OS upgrade
unless either DELL or RedHat assures that the
new OS release is compatible with the hardware.
They are all dual-CPU boxes. Of course, I tinker
with the kernel upgrade with my home PC all the time.
It is a single CPU athlon board and I run Debian GNU/Linux
on it.)

Also, just a hunch, you might want to try
reducing the amount of memory  (if it is easy
to do) and see if this changes the behavior.
A stock kernel might have issues with 1GB - 2GB
on the said board. Not that I am aware of
any particular bugs or anything, but you may get
a different behavior especially if you have
a bunch of inferior memory sticks and other
hardware-related problems.
(In this sense, try removing the memory stick from
the board if possible instead of just specifying
the boot parameter to use less memory.)

In the earlier post:
> The symptoms are segmentation faults, signal 11's, and occasionally 
> kernel oops at mem_alloc:89, I have also seen several kernel oops in 
> journal.c when I tried using ext3, I disactivated that but the faults 
> remained. It has also froze once and given a kernel oops while loading 
> the scsi driver at boot, and another time it simply rebooted the machine 
> when loading the driver. Any ideas? 

As someone pointed out, this certainly looks to me
a flakey hardware. What brand of memory 
boards do you use? What is the chipset of the motherboard?

It may be hard to diagnose if these behavior show up
only under SMP setup. 
Do you have a different OS that supports dual CPU operation on
this motherboard? Solaris for x86 or Windows NT or 2000?
Running them might help you in figuring out the problem is indeed
hardware-related, etc. If you don't have either of them, too bad.
Given the cost of purchase of hardware, though, 
you might slip in the purchase of Solaris for x86 (media cost only
if I am not mistaken) as a diagnostic tool :-)
If you are in USA, I think you can receive the Solaris 
media rather quickly.
