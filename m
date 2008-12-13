From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Announce]: Target_Core_Mod/ConfigFS and LIO-Target v3.0 work
Date: Sat, 13 Dec 2008 09:24:56 -0600
Message-ID: <1229181896.3258.27.camel@localhost.localdomain>
References: <1228965271.4153.510.camel@haakon2.linux-iscsi.org>
	 <e2e108260812111124j79793adcie106ac2da4f801f3@mail.gmail.com>
	 <1229025513.4153.542.camel@haakon2.linux-iscsi.org>
	 <e2e108260812112321w2f5b1827xe2593888e44808ae@mail.gmail.com>
	 <1229074809.4153.666.camel@haakon2.linux-iscsi.org>
	 <54939.1229149205@turing-police.cc.vt.edu>
	 <e2e108260812130141o3d21bbbdob9e7c9f95d309a74@mail.gmail.com>
	 <1229162907.4153.857.camel@haakon2.linux-iscsi.org>
	 <e2e108260812130223q13fd98d8gc1e55881a92b939@mail.gmail.com>
	 <1229167118.4153.930.camel@haakon2.linux-iscsi.org>
	 <e2e108260812130356y1fe60713xf844a35c775e161d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43520 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975AbYLMPY5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Dec 2008 10:24:57 -0500
In-Reply-To: <e2e108260812130356y1fe60713xf844a35c775e161d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: linux-iscsi-target-dev@googlegroups.com, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Jens Axboe <jens.axboe@oracle.com>, Vladislav Bolkhovitin <vst@vlnb.net>

On Sat, 2008-12-13 at 12:56 +0100, Bart Van Assche wrote:
> On Sat, Dec 13, 2008 at 12:18 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > Of course I fix bugs when people report them.
> 
> Things have changed then since the beginning of this year. As anyone
> can see in the threads I referred to, you have done your best to deny
> that the crashes and system hangs were caused by LIO, although I had
> posted exact instructions on how to reproduce the bugs. Regarding
> kernel integration and subsystem maintainership: one of the important
> tasks of a maintainer is to verify whether reported bugs are
> reproducible, and if so, to resolve them. I'm happy none of the
> current kernel maintainers has the habitude of denying bug reports
> that are 100% reproducible and which contain exact instructions about
> how to reproduce the bug.

OK, All of you on this thread, why don't you take time out to step back
and think about the effects this descent into trench warfare is having
on your observers.

     1. You're both saying the other side isn't production ready ...
        it's not a stretch for the rest of us to take this at face
        value ... about both of you.
     2. This ideological opposition to features the other side
        implements tells me that if it came to a choice, by going with
        either one of you I'd get an incomplete feature set.
     3. Making obvious partisans of your user base also tells me that if
        I had to make a choice, whatever it was I'd piss off a large
        number of people who'd be very vocal about it.

Since we have a working target solution in the kernel already (STGT),
why on earth would I be stupid enough to want to even consider either of
you, coming as you do with the above mentioned baggage?

So stop fighting ... you're not going to backstab your way to inclusion.

The only identified failing of STGT (and it's theoretical, not
demonstrated, although I can agree the theory looks correct) is that the
user space packet processing may cause performance problems on high
speed networks.  We know from practical tests that these networks have
to be above 1Gbit because the results were identical for STGT and SCST
on a 1G network, so it's infiniband or 10Gbit ethernet.

So, what it comes down to is that if we had a kernel side protocol
accelerator for STGT, the project would no longer suffer from this
theoretical failing.  *Both* of you have such a thing embedded in your
respective submissions (all 74k LOC of them) so can't you just enhance
STGT with whichever one is better ... actually, if you'd both bury the
hatchet and work on the enhancement together taking the best of each
project, we'd have something that worked much better and a unified user
base and neither side would be able to claim sole credit ... just a
thought.

James


