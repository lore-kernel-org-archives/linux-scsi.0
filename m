From: Pedro Pla <pedropla@holidaymarketing.com>
Subject: Re: Problem with Gdt driver under smp?
Date: Thu, 07 Nov 2002 15:34:58 +0800
Sender: linux-smp-owner@vger.kernel.org
Message-ID: <3DCA17A2.1030506@holidaymarketing.com>
References: <3DC0EBB3.9030707@holidaymarketing.com> <20021031120257.GF23217@redhat.com> <3DC71BF8.80100@holidaymarketing.com> <20021105033435.GA16634@redhat.com> <3DC79701.8070802@holidaymarketing.com> <20021105164106.GG16634@redhat.com> <3DC87019.3000504@holidaymarketing.com> <3DC88DD4.2010301@holidaymarketing.com> <3DC9F5BB.287AFAE2@yk.rim.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-smp-owner@vger.kernel.org>
To: Ishikawa <ishikawa@yk.rim.or.jp>
Cc: linux-scsi@vger.kernel.org, linux-smp@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Ishikawa wrote:

>In the earlier post, you mentioned, 
>  
>
>>I've tried 
>>kernels from the 2.2.22 to the 2.4.17-2.4.20-pre10-ac with pre11 patches 
>>applied on top.
>>    
>>
>
>You also mentioned that the hardware is certified by
>Intel and RedHat to be linux-compatible.
>
>May I suggest that you try a version of RedHat linux
>(and its drivers) 
>instead of compiling a kernel yourself?
>Maybe RedHat has applied a patch or something that
>makes the board work with *THEIR* version of
>linux kernel and drivers?
>
I'll try their version of the kernel, downloading it now, however the
one it is certified for (or should we say the one mentioned in the intel
docs to be more correct) is quite a bit older then the existing one, so
I wonder if it's an accumulated bug in the kernel since that version,
and if I get the latest redhat download version if it will still fail..
guess we'll have to wait till my download finishes to install and test it.

>
>(I have a few DELL linux servers at the office and
>they run RedHat linux pre-installed, and I have
>no desire to tinker with OS upgrade
>unless either DELL or RedHat assures that the
>new OS release is compatible with the hardware.
>They are all dual-CPU boxes. Of course, I tinker
>with the kernel upgrade with my home PC all the time.
>It is a single CPU athlon board and I run Debian GNU/Linux
>on it.)
>
I've always used compiled kernels on smp machines with no problems, but
hey, there's always a first time :)

>
>Also, just a hunch, you might want to try
>reducing the amount of memory  (if it is easy
>to do) and see if this changes the behavior.
>A stock kernel might have issues with 1GB - 2GB
>on the said board. Not that I am aware of
>any particular bugs or anything, but you may get
>a different behavior especially if you have
>a bunch of inferior memory sticks and other
>hardware-related problems.
>(In this sense, try removing the memory stick from
>the board if possible instead of just specifying
>the boot parameter to use less memory.)
>
I've reduced it to the lowest amount I can with the simms I have in the
office, I got it down to 1gb ram, all the simms I have are 512mb and
they have to be put in pairs, might go buy some cheap 64mb simms and see
what happens.Just spending a few hundred bucks for testing purposes
won't make the bosses happy after they spent on 6 spanking new machines...

>
>In the earlier post:
>  
>
>>The symptoms are segmentation faults, signal 11's, and occasionally 
>>kernel oops at mem_alloc:89, I have also seen several kernel oops in 
>>journal.c when I tried using ext3, I disactivated that but the faults 
>>remained. It has also froze once and given a kernel oops while loading 
>>the scsi driver at boot, and another time it simply rebooted the machine 
>>when loading the driver. Any ideas? 
>>    
>>
>
>As someone pointed out, this certainly looks to me
>a flakey hardware. What brand of memory 
>boards do you use? What is the chipset of the motherboard?
>
They are all kingston memory chips, I have tried 8 seperate simms, well
in combinations of two, so really there was only 4 different simms in,
and in any different combination. The motherboard chipset is serverworks
(intel scb2 board), I think the problem is in the dma, since it only
occurs when moving files from disk. I know the serverworks ide dma is
flakey in the kernel at the moment, but how could that affect the gdt
(scrmr) scsi? Or is it related?

>
>It may be hard to diagnose if these behavior show up
>only under SMP setup. 
>Do you have a different OS that supports dual CPU operation on
>this motherboard? Solaris for x86 or Windows NT or 2000?
>Running them might help you in figuring out the problem is indeed
>hardware-related, etc. If you don't have either of them, too bad.
>Given the cost of purchase of hardware, though, 
>you might slip in the purchase of Solaris for x86 (media cost only
>if I am not mistaken) as a diagnostic tool :-)
>If you are in USA, I think you can receive the Solaris 
>media rather quickly.
>
I'm seriously considering that, however I am not in the US, let's see if
I can download it. it is definately worth trying if everything else fails.

Thanks for all the ideas :) now to try all the ones I can out :)


