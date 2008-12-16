From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Announce]: Target_Core_Mod/ConfigFS and LIO-Target v3.0 work
Date: Tue, 16 Dec 2008 21:45:02 +0300
Message-ID: <4947F72E.7000408@vlnb.net>
References: <1228965271.4153.510.camel@haakon2.linux-iscsi.org>	 <e2e108260812111124j79793adcie106ac2da4f801f3@mail.gmail.com>	 <1229025513.4153.542.camel@haakon2.linux-iscsi.org>	 <e2e108260812112321w2f5b1827xe2593888e44808ae@mail.gmail.com>	 <1229074809.4153.666.camel@haakon2.linux-iscsi.org>	 <54939.1229149205@turing-police.cc.vt.edu>	 <e2e108260812130141o3d21bbbdob9e7c9f95d309a74@mail.gmail.com>	 <1229162907.4153.857.camel@haakon2.linux-iscsi.org>	 <e2e108260812130223q13fd98d8gc1e55881a92b939@mail.gmail.com>	 <1229167118.4153.930.camel@haakon2.linux-iscsi.org>	 <e2e108260812130356y1fe60713xf844a35c775e161d@mail.gmail.com> <1229181896.3258.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:61029 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYLPSov (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Dec 2008 13:44:51 -0500
In-Reply-To: <1229181896.3258.27.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, linux-iscsi-target-dev@googlegroups.com, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Jens Axboe <jens.axboe@oracle.com>, scst-devel <scst-devel@lists.sourceforge.net>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>

James Bottomley wrote:
> On Sat, 2008-12-13 at 12:56 +0100, Bart Van Assche wrote:
>> On Sat, Dec 13, 2008 at 12:18 PM, Nicholas A. Bellinger
>> <nab@linux-iscsi.org> wrote:
>>> Of course I fix bugs when people report them.
>> Things have changed then since the beginning of this year. As anyone
>> can see in the threads I referred to, you have done your best to deny
>> that the crashes and system hangs were caused by LIO, although I had
>> posted exact instructions on how to reproduce the bugs. Regarding
>> kernel integration and subsystem maintainership: one of the important
>> tasks of a maintainer is to verify whether reported bugs are
>> reproducible, and if so, to resolve them. I'm happy none of the
>> current kernel maintainers has the habitude of denying bug reports
>> that are 100% reproducible and which contain exact instructions about
>> how to reproduce the bug.
> 
> OK, All of you on this thread, why don't you take time out to step back
> and think about the effects this descent into trench warfare is having
> on your observers.

James,

I'm sorry you needed to intervene in such a manner. I don't want to 
continue that LIO vs SCST fight, but I see in your message some 
important misunderstandings about SCST, on which, I feel I need to reply 
to clean them up.

>      1. You're both saying the other side isn't production ready ...
>         it's not a stretch for the rest of us to take this at face
>         value ... about both of you.

I listed in http://lkml.org/lkml/2008/12/10/245 the exact things, why 
LIO is far from being production ready and can continue that list. In 
fact, if to call things their real names, LIO is an iSCSI target which 
in past few months in a hurry is being converted to a generic target 
engine and which has a lo-o-ong way to go to complete the conversion. 
I.e., in other words, LIO might be good as an iSCSI target, but as a 
generic iSCSI target engine at the moment it simply *does not exist* yet.

Relating to SCST being not production ready, can Nicholas Bellinger 
support his claims against SCST with something concrete? So far, 
everything he has written was empty words not supported by any real 
facts. For instance, he failed to describe for what all those "missed" 
in SCST features are needed.

>      2. This ideological opposition to features the other side
>         implements tells me that if it came to a choice, by going with
>         either one of you I'd get an incomplete feature set.

There's no ideological opposition between SCST and LIO. Both engines are 
built around basically the same ideology. The opposition is in 
completely different and non-technical area.

>      3. Making obvious partisans of your user base also tells me that if
>         I had to make a choice, whatever it was I'd piss off a large
>         number of people who'd be very vocal about it.

Unfortunately, being based on an Open Source product isn't something 
many people want to be proud of..

But here is the list of companies taken from scst-devel mailing list who 
are working on SCST based products and made contributions in the past 
half a year:

@storwize.com
@open-e.com
@enjellic.com

In the earlier time there were also contributions from @hp.com and 
@systemfabricworks.com.

Also, I've already mentioned Mellanox, who developed SRP target driver 
and now selling based on it product.

Also, there is a target driver development for Marvell SAS hardware by 
an anonymous company, see 
http://sourceforge.net/mailarchive/message.php?msg_id=e938503f0809260211r2d4ec37bt293c75c80960eadd%40mail.gmail.com

If you need more, I'll ask permissions from companies who already 
selling SCST based products (BTW, 2 of them - user space VTLs, which can 
be made on STGT, but those companies chose SCST).

It's worth to note here, that scst-devel mailing list has 134 
subscribers. Many of them are from well known storage related companies. 
Unfortunately, other sf.net statistics permanently loose data, hence not 
trustworthy, so I can't refer to it.

> So stop fighting ... you're not going to backstab your way to inclusion.
> 
> The only identified failing of STGT (and it's theoretical, not
> demonstrated, although I can agree the theory looks correct) is that the
> user space packet processing may cause performance problems on high
> speed networks.  We know from practical tests that these networks have
> to be above 1Gbit because the results were identical for STGT and SCST
> on a 1G network, so it's infiniband or 10Gbit ethernet.

I thought that SRP measurements in http://lkml.org/lkml/2008/12/10/245 
are sufficient to remove all your doubts. If you don't object, I'll 
remind: there was a >50% improvement in IOPS on 4K writes (~150K vs 
~100K), which relates to >200MB/s throughput increase, when, where 
possible, processing was moved from kernel threads to tasklets. For STGT 
any processing can't be moved to tasklets by design and context switches 
between user space threads are a bit heavier, than between kernel 
threads, + STGT has some syscall entry/exit overheads, hence for the 
same processing done in STGT, the difference would be even more.

Thus, those measurements give the low boundary estimation of the 
performance increase. Having such a huge increase on 4K block sizes is a 
big advantage for any latency bound applications, like databases.

What else should we do to convince you?

Also, what I can't understand, why you don't want to count the 
architectural advantages of SCST over STGT. Namely: overall simplicity, 
possibility to implement many impossible for STGT features, like 
complete pass-through and zero-copy cache IO. In fact, one such feature 
has already been implemented: zero-copy transmit in iSCSI target. From 
user space this is impossible, but for kernel I implemented it by very 
small and simple patch.

> So, what it comes down to is that if we had a kernel side protocol
> accelerator for STGT, the project would no longer suffer from this
> theoretical failing.  *Both* of you have such a thing embedded in your
> respective submissions (all 74k LOC of them) so can't you just enhance
> STGT with whichever one is better ... actually, if you'd both bury the
> hatchet and work on the enhancement together taking the best of each
> project, we'd have something that worked much better and a unified user
> base and neither side would be able to claim sole credit ... just a
> thought.

James, just think as if SCST in the current state is STGT in which all 
the possible enhancements are already incorporated. It simply has been 
cooking outside of the kernel for too long, so you didn't see the 
intermediate steps. I'm not joking. I'm absolutely serious. And it is 
true. Developing scst_user module I carefully studied STGT and scst_user 
has everything it could take from it.

When you ask us to improve STGT step by step and implement a kernel side 
protocol accelerator for it, you ask us to go back by 2+ years. For the 
kernel side acceleration STGT needs to move the SCSI target state 
machine and memory management into the kernel, which effectively means 
to convert it to SCST. What should I do to make it clear for you?

Also, current integration of STGT with Linux (initiator) SCSI subsystem 
should have a better design, I explained why in 
http://lkml.org/lkml/2008/12/10/245. SCSI initiator and target has 
almost nothing to share, so they should be separated.

I always open for any possible cooperation. Particularly, I'm always 
willing to make with SCST any necessary changes, which will lead to 
better target engine in Linux. But before doing any change I, as any 
sane engineer, need to have answers on several simple questions. 
Basically, there are 2 such questions:

1. For what the proposed action is needed? I.e., which real life task is 
it going to solve?

2. Why is the proposed change the best one among possible implementation 
alternatives?

If you simply take from 
http://scst.sourceforge.net/patches/scst_combined.patch the combined 
SCST patch, which has all 23 patches I submitted combined in a single 
file (BTW, it has 46K LOC, not 76K), then patch some 2.6.27 tree and 
spend a little time looking at it, you will soon find out that 
converting STGT to SCST is the worst possible alternative. Simply try to 
find out places, where STGT in-kernel core is better, than SCST core, or 
has a feature, which SCST core doesn't have. There is only one such 
feature: OSD support, i.e. bidirectional transfers, large CDBs, etc. It 
wasn't implemented in SCST so far, because there was no demand for it 
(hence, no way to test). But (1) this feature doesn't have any in-kernel 
user, so nobody will be affected if STGT moved to be user space only, 
and (2) there is nothing hard to add that feature to SCST, if there is 
such demand.

I have been closely following development of both STGT and LIO since 
their beginning, so my words based on close examination of their source 
code, not on my rejection to look at it. They both inferior to SCST in 
all main areas. I believe, there is no point to spend time improving 
kernel side of STGT. Better to put effort to better integrate user space 
part of STGT with scst_local SCST module as I described in 
http://lkml.org/lkml/2008/12/10/245. If you don't agree with me, can you 
answer on the question (2) above, please?

 From everything I know SCST at the moment is the best open source SCSI 
target engine in the world and no other target engines, including 
Solaris's COMSTAR, can match it in functionality, performance and 
stability areas.

James, you offered by already *completed* work, where everything 
possible to improve STGT was already done, so why not simply accept it?

I'm an engineer, not a sales man, and there are no sales men in SCST 
team to advertise it. We believe that the source code, its quality, 
performance and feature completeness should speak theirself. It has been 
in Linux so far and we hope will be so in this case. Just let the code 
speak!

Sorry for taking your time by one more huge e-mail. I did my best to be 
as laconic as possible.

Thanks,
Vlad
