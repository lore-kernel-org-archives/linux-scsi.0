From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Mon, 06 Sep 2010 14:55:35 -0700
Message-ID: <1283810135.556.238.camel@haakon2.linux-iscsi.org>
References: <4C76CA57.3050405@vlnb.net>
	 <1282857806.32007.175.camel@haakon2.linux-iscsi.org>
	 <4C79484B.3090607@vlnb.net>
	 <1283028468.32007.357.camel@haakon2.linux-iscsi.org>
	 <4C7C18CE.5020103@vlnb.net>
	 <1283204792.32007.448.camel@haakon2.linux-iscsi.org>
	 <4C7FFD1A.8090509@vlnb.net>
	 <1283459158.5598.143.camel@haakon2.linux-iscsi.org>
	 <20100905201802.GC18411@core.coreip.homeip.net>
	 <1283723447.556.133.camel@haakon2.linux-iscsi.org>
	 <20100905234134.GA17212@core.coreip.homeip.net>
	 <1283731194.556.147.camel@haakon2.linux-iscsi.org>
	 <1283769578.15944.1293.camel@mulgrave.site>  <4C85617E.2080603@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp105.sbc.mail.gq1.yahoo.com ([67.195.14.108]:44903 "HELO
	smtp105.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752661Ab0IFV7e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2010 17:59:34 -0400
In-Reply-To: <4C85617E.2080603@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: James Bottomley <James.Bottomley@suse.de>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>, Chetan Loke <generationgnu@yahoo.com>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Tue, 2010-09-07 at 01:47 +0400, Vladislav Bolkhovitin wrote:
> James Bottomley, on 09/06/2010 02:39 PM wrote:
> >>>> Anyways, if we are going to compare SCM distributed vs. centralized
> >>>> workflow in terms of kernel projects, lets please at least compare
> >>>> apples to apples here.
> >>>
> >>> No, we should not be comparing SCMs at all here but rather 2 competing
> >>> implementations based on quality of the code. You tried to bring SMC
> >>> angle in and I am saying that it is BS.
> >>
> >> Again, without getting into another pointless flamewar,  I think the
> >> main point here is that a open source project using a distributed
> >> workflow (like git) has major advantages when it comes to working with a
> >> larger group of developers than a centralized model (like SVN) does.
> >>
> >> Because being a subsystem maintainer typically involves this type of
> >> complex workflow involving lots of different parties, git is a tool that
> >> was created (originally) expressely for a kernel workflow, and for those
> >> types of people it works really, really well.
> >
> > Oh, for god's sake children.  Why does every LIO vs SCST discussion turn
> > into a pointless flameware over stuff no-one really cares about?  If
> > none of you has anything substantive to say: don't say it.
> 
> James, sorry, but you can't blame us. I keep asking for clear rules and 
> don't receive much. So, there are speculations and pseudo-rules, which 
> sometimes go to the absurd, as in this SVN vs Git case. No surprise 
> then, that people have risen against this absurd (thanks a lot to them 
> for support!).
> 
> Frankly, in all the situation around Linux SCSI targets I for quite a 
> long time feeling myself as a hero of a Kafka novel. Supposed to be 
> goals are to have the best code doing its job the best, but on practice 
> nobody cares about technical arguments and figuring out which subsystem 
> is the best. Instead, everything lives it own incomprehensible life, 
> where doesn't matter what you are doing, all already long ago decided 
> behind your back and you will never be told why. All accurate statements 
> not heard or, at best, called "handwaving", but dirty public opinion 
> manipulations based on half- and less-than-half- truth have very warn 
> welcome. This atmosphere is unhealthy, really.

Sorry Vlad, but this is simply not the truth.  You have had ample time
to comment on the hundreds of TCM/LIO patches posted to linux-scsi and
lkml over the last years, but you have chosen never to comment on a
*single* one then, or even on a single one now of the dozens that have
been posted in the last 3 weeks while this thread has been lumbering
forward..

So at this point, I will once again to refrain from any non technical
interaction with yourself.  If you have geninue concerns about any of
the TCM/LIO v4 code, then I suggest that you and your devels make them
known from within threads containing [PATCH] and [RFC] tags, because I
will not be bothering with anything that does not contain comments on
creating new or improving existing design and code.

Best,

--nab

