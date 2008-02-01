From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Fri, 01 Feb 2008 02:39:24 -0800
Message-ID: <1201862364.11265.267.camel@haakon2.linux-iscsi.org>
References: <adazluoe2t3.fsf@cisco.com>
	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
	 <20080130195635T.tomof@acm.org>
	 <1201785938.7280.105.camel@haakon2.linux-iscsi.org>
	 <e2e108260802010011n7c539a0bk2aa3c1d0aa6c00a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:23245 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754975AbYBAKjw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2008 05:39:52 -0500
In-Reply-To: <e2e108260802010011n7c539a0bk2aa3c1d0aa6c00a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: FUJITA Tomonori <tomof@acm.org>, fujita.tomonori@lab.ntt.co.jp, rdreier@cisco.com, James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Mike Mazarick <mazarick@bellsouth.net>

On Fri, 2008-02-01 at 09:11 +0100, Bart Van Assche wrote:
> On Jan 31, 2008 2:25 PM, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> >
> > The PyX storage engine supports a scatterlist linked list algorithm that
> > ...
> 
> Which parts of the PyX source code are licensed under the GPL and
> which parts are closed source ? A Google query for PyX + iSCSI showed
> information about licensing deals. Licensing deals can only be closed
> for software that is not entirely licensed under the GPL.
> 

I was using the name PyX to give an historical context to the
discussion.  :-)  In more recent times, I have been using the name "LIO
Target Stack" and "LIO Storage Engine" to refer to Traditional RFC-3720
Target statemachines, and SCSI Processing engine implementation
respectively.  The codebase has matured significantly from the original
codebase, as the Linux SCSI, ATA and Block subsystems envolved from
v2.2, v2.4, v2.5 and modern v2.6, the LIO stack has grown (and sometimes
shrunk) along with the following requirement;  To support all possible
storage devices on all subsystems on any hardware platform that Linux
could be made to boot.  Interopt with other non Linux SCSI subsystems
was also an issue early in development.. If you can imagine a Solaris
SCSI subsystem asking for T10 EVPD WWN information from a Linux/iSCSI
Target with pre libata SATA drivers, you can probably guess just how
time was spent looking at packet captures to figure out to make OS
dependent (ie: outernexus) multipath to play nice.

Note that PyX Target Code for Linux v2.6 has been available in source
and binary form for a diverse array of Linux devices and environments
since September 2007.  Right around this time, the Linux-iSCSI.org
Storage and Virtualization stack went online for the first time using
OCFS2, PVM, HVM, LVM, RAID6 and of course, traditional RFC-3720 on 10
Gb/sec and 1 Gb/sec fabric.  There have also been world's first storage
research work and prototypes that have been developed with the LIO code.
Information on these topics is available from the homepage, and a few
links deep there are older projects and information about features
inherent to the LIO Target and Storage Engine.  One of my items for the
v2.9 codebase in 2008 is start picking apart the current code and
determining which pieces should be sent upstream for review.  I have
also been spending alot of time recently looking at the other available
open source storage transport and processing stacks and seeing how
Linux/iSCSI, and other projects can benefit from our large pool of
people, knowledge, and code.

Speaking of the LIO Target and SE code, it today runs the production
services for Linux-iSCSI.org and it's storage and virtualization
clusters on x86_64.  It also also provides a base for next generation
and forward looking projects that exist (or soon to exist :-) within the
Linux/iSCSI ecosystem.  There have been lots of time and resources put
into the codebase, and having a real live working RFC-3720 stack that
supports optional features that give iSCSI (and hence designed into
iSER) the flexibility and transparentness to operate as the original
designers intended.

Many thanks for your most valuable of time,

--nab

> Bart Van Assche.
> 

