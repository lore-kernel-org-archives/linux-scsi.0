From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 1/3] scsi_dh: Add modalias support for SCSI targets
Date: Wed, 15 Apr 2009 14:52:43 -0700
Message-ID: <1239832363.1196.5.camel@chandra-ubuntu>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>
	 <20090318013621.26548.10529.sendpatchset@chandra-ubuntu>
	 <ac3eb2510903181130s5dd1b1caje579d765fd338f6f@mail.gmail.com>
	 <1237403902.14147.25.camel@chandra-ubuntu>
	 <1237488880.26341.15.camel@chandra-ubuntu>  <49C3DF49.8050408@redhat.com>
	 <1237846429.14853.6.camel@chandra-ubuntu>
	 <1238798590.20924.0.camel@chandra-ubuntu>
	 <1239137973.29492.12.camel@mulgrave>  <49DCBDE6.5000806@redhat.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:45000 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbZDOVwR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Apr 2009 17:52:17 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n3FLmxak006031
	for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2009 15:48:59 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3FLqFIu210132
	for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2009 15:52:16 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3FLqENA011386
	for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2009 15:52:15 -0600
In-Reply-To: <49DCBDE6.5000806@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, Peter Jones <pjones@redhat.com>, Hannes Reinecke <hare@suse.de>

Hi James,

Are your concerns answered ?

Hannes, Kay,

Is the description related to bus notify BIND DEVICE issue clear now ?

Please respond :)

chandra
On Wed, 2009-04-08 at 11:08 -0400, Peter Jones wrote:
> On 04/07/2009 04:59 PM, James Bottomley wrote:
> > On Fri, 2009-04-03 at 15:43 -0700, Chandra Seetharaman wrote:
> >> Hi James,
> >>
> >> Do you still have any concerns (after Peter's response) ?
> > 
> > Yes, the basic concerns still remain:
> > 
> >      1. You're forcing autoload now even if the user isn't running
> >         dm ... this is going to cause problems with non-dm based path
> >         handlers
> 
> (Chandra covered this pretty well, so I'll leave it be.)
> 
> >      2. autoloading in this fashion is essentially trying to work around
> >         a problem in the initrd tools.  The kernel isn't the right place
> >         to implement the fix.
> 
> This seems backwards to me.  It's not trying to work around a problem
> in the initrd tools; it's trying to avoid creating one by making this
> subsystem unlike others.
> 
> The point of having modaliases is to allow the kernel to announce that it's
> got a hardware device and notify the userland that appropriate modules should
> be loaded.  That's exactly what we've done here.  What we're trying to avoid
> in the initrd tools is having to have a special handler for this subsystem;
> instead, we'd much rather use the generic mechanism that already exists for
> this purpose.
> 
> > The risks of this approach seem very high, and the rewards pretty small.
> 
> Can you please explain what the high risks you're thinking of are?  I'm not
> clear on what undesirable behavior you expect to occur.
> 
> The reward is that scsi targets behave exactly like most other types of
> hardware and kernel modules in this regard, without having to write special
> probing for this subsystem in the userland and special handling for loading
> these modules.  That's a pretty big win for maintainability.
> 

