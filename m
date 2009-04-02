From: "Ross S. W. Walker" <RWalker@medallion.com>
Subject: RE: [Scst-devel] [Iscsitarget-devel] ISCSI-SCST	performance (with also IET and STGT data)
Date: Thu, 2 Apr 2009 10:06:59 -0400
Message-ID: <E2BB8074E5500C42984D980D4BD78EF9029E3D14@MFG-NYC-EXCH2.mfg.prv>
References: <49D10256.8030307@vlnb.net>	<e2e108260903301106y2b750c23kfab978567f3de3a0@mail.gmail.com>	<49D11096.3070804@vlnb.net>	<e2e108260903301153x38e86097vd29c47507da2879f@mail.gmail.com>	<49D254E4.8050806@vlnb.net>	<E2BB8074E5500C42984D980D4BD78EF9029E3D0B@MFG-NYC-EXCH2.mfg.prv>	<e2e108260903312329u118a54bfn3107fdca4b3e2b1d@mail.gmail.com>	<FA7F6940-CD5C-4460-9777-2F7AE3657B8E@gmail.com>	<1238617423.3318.82.camel@mulgrave.int.hansenpartnership.com> <49D46B8B.5000708@vlnb.net> <49D47F28.3060409@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailgw.nyc.medallion.com ([63.68.220.242]:2614 "EHLO
	mailgw.nyc.medallion.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573AbZDBOHI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2009 10:07:08 -0400
Content-class: urn:content-classes:message
In-Reply-To: <49D47F28.3060409@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, iSCSI Enterprise Target Developer List <iscsitarget-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, Ross Walker <rswwalker@gmail.com>, scst-devel <scst-devel@lists.sourceforge.net>, stgt@vger.kernel.org

Vladislav Bolkhovitin wrote:
> Vladislav Bolkhovitin, on 04/02/2009 11:38 AM wrote:
> > James Bottomley, on 04/02/2009 12:23 AM wrote:
> >> 
> >> SCST explicitly fiddles with the io context to get this to happen.  It
> >> has a hack to block to export alloc_io_context:
> >>
> >> http://marc.info/?t=122893564800003
> > 
> > Correct, although I wouldn't call it "fiddle", rather "grouping" ;)

Call it what you like,

Vladislav Bolkhovitin wrote:
> Ross S. W. Walker, on 03/30/2009 10:33 PM wrote:
> 
> I would be interested in knowing how your code defeats CFQ's extremely
> high latency? Does your code reach into the io scheduler too? If not,
> some code hints would be great.

Hmm, CFQ doesn't have any extra processing latency, especially 
"extremely", hence there is nothing to defeat. If it had, how could it 
been chosen as the default?

----------
List:       linux-scsi
Subject:    [PATCH][RFC 13/23]: Export of alloc_io_context() function
From:       Vladislav Bolkhovitin <vst () vlnb ! net>
Date:       2008-12-10 18:49:19
Message-ID: 49400F2F.4050603 () vlnb ! net

This patch exports alloc_io_context() function. For performance reasons 
SCST queues commands using a pool of IO threads. It is considerably 
better for performance (>30% increase on sequential reads) if threads in 
  a pool have the same IO context. Since SCST can be built as a module, 
it needs alloc_io_context() function exported.

<snip>
----------

I call that lying.

> > But that's not the only reason for good performance. Particularly, it 
> > can't explain Bart's tmpfs results from the previous message, where the 
> > majority of I/O done to/from RAM without any I/O scheduler involved. (Or 
> > does I/O scheduler also involved with tmpfs?) Bart has 4GB RAM, if I 
> > remember correctly, i.e. the test data set was 25% of RAM.
> 
> To remove any suspicions that I'm playing dirty games here I should note 
<snip>

I don't know what games your playing at, but do me a favor, if your too
stupid enough to realize when your caught in a lie and to just shut up
then please do me the favor and leave me out of any further correspondence
from you.

Thank you,

-Ross

______________________________________________________________________
This e-mail, and any attachments thereto, is intended only for use by
the addressee(s) named herein and may contain legally privileged
and/or confidential information. If you are not the intended recipient
of this e-mail, you are hereby notified that any dissemination,
distribution or copying of this e-mail, and any attachments thereto,
is strictly prohibited. If you have received this e-mail in error,
please immediately notify the sender and permanently delete the
original and any copy or printout thereof.

