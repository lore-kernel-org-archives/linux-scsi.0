From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Announce]: Target_Core_Mod/ConfigFS and LIO-Target v3.0 work
Date: Sat, 13 Dec 2008 04:33:17 -0800
Message-ID: <1229171597.4153.981.camel@haakon2.linux-iscsi.org>
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
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:31817 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754305AbYLMMdU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Dec 2008 07:33:20 -0500
In-Reply-To: <e2e108260812130356y1fe60713xf844a35c775e161d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: linux-iscsi-target-dev@googlegroups.com, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

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

Heh, so I guess that means that you cannot show me where in
lio-core-2.6.git that the issues still exist.  Why am I not suprised..? 

Can you at least even back up your claim that the 10 month old BUGs you
posted have not been fixed, or was that just handwaving as well. Again
Bart, the only reason took a bit of extra time responding to you
because:

1) I was busy helping other people, and
2) The of the disrespectful tone of your emails turns me off

If this is the reasoning you cite for ignoring and badmouthing
Target_Core_Mod/ConfigFS, LIO-Target v3.0 and myself to the kernel
community at large, and making false claims about LIO stability (without
looking at an code, by your own admission!?), all I can say is:  WoW!!

> 
> > "Zero-copy means that data is copied as few times as possible".
> >
> > when I was attempting to explain the finer pointers of
> > Target_Core_Mod/ConfigFS design to you and Vlad.  Remember that one..?
> >
> > http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/8cff61671cd2de6b/37ade00e607dd8c8
> 
> You are going off topic -- the above statement has nothing to do with
> this thread.
> 

Heh, and posting URLs to 10 month old BUGs that have been fixed 10
months ago in v2.9 on-topic for the Target_Core_Mod/ConfigFS v3.0
discussion..?

Like I said, if you would spend a fraction of the time you use trying to
discredit LIO code on trying to understand ConfigFS, or my points why I
decided not to use SCST as a base for Target_Core_Mod, perhaps you would
be apple to make real comments on worthwhile comments here, instead of
just your usual handwaving.

> Regarding the statement itself: it's incorrect to quote that sentence
> out of its context. In that thread, as anyone can see who looks up the
> URL, I was using the word copies to refer to transfers between
> hardware and RAM, not to copying data from RAM to RAM. Looking at that
> statement now I agree that that was misleading, and that I should have
> written that statement in another way.
> 

The point is that neither you nor Vlad would acknowledge any of the
issues on that thread, or communicate with me in a professional manner
without the handwaving.  How do you expect me to work with you if you
can't even acknowledge the short comings, or offer me a roadmap to get
them resolved when all you guys do is handwave..?

> Do you think people like it to discuss with you when you try to make
> them appear ridiculous all the time ?
> 

I think that your definition of Zero-copy as "data is copied as few
times as possible" speaks for itself.  I don't exactly know how that can
be taken out of context.  Of course, that was just the tip of the
iceberg on that thread.  Lets not even get into how you claimed RDMA
meant only userspace ops on virtual memory addresses using a vendor
specific API, or that RDMA using virtual addresses would be
communicating with drivers/scsi or block/ (which obviously use struct
page).

So honestly, I was much more concerned about the responses I got from
you and Vlad about core SCST core lacking important functionality for
$FABRIC_MODs using generic target infrastructure, and your inability to
acknowledge anything that you cannot or do not want to understand when
it comes to interface with linux storage subsystems  in the context on
generic target mod.

Do you actually think people care about hearing that it look me an extra
day to address your issue 10 months ago..?  :-) If you honestly think me
talking an extra day to address your issue (while I was busy with other
things at the same time) has any relivance to the upstream code
discussion, your are sorely mistaken.

> And what I do not understand is that you are playing games with the CC
> list all of the time. It's considered impolite to leave out people
> from a CC list unless someone asked explicitly to be left out.
> 

Bart, no one wants to hear us argue, that is why I am saving them the
pain and removing them from the CC list.  Any until you can start
showing me some real techincal content in a professional manner, I am
going to simply ignore your clumsy attempts at attacking me and m work.

--nab

> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

