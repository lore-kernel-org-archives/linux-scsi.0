From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SCSI target subsystem
Date: Sat, 3 May 2008 07:28:46 -0600
Message-ID: <20080503132846.GA14976@parisc-linux.org>
References: <200805021638.42972.bart.vanassche@gmail.com> <20080502153306.GB7376@infradead.org> <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com> <20080502155525.GA16353@infradead.org> <e2e108260805020906w7f5e92bev46b8d0f96aa7b4d6@mail.gmail.com> <1209745084.3121.39.camel@localhost.localdomain> <481B5AB8.5030108@vlnb.net> <e2e108260805030241w216363dbt4b5f6b2105ad267b@mail.gmail.com> <20080503095314.GX14976@parisc-linux.org> <e2e108260805030339q4fcaedf7t34e737c14801e788@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:50158 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbYECN2r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 May 2008 09:28:47 -0400
Content-Disposition: inline
In-Reply-To: <e2e108260805030339q4fcaedf7t34e737c14801e788@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: FUJITA Tomonori <tomof@acm.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>

On Sat, May 03, 2008 at 12:39:19PM +0200, Bart Van Assche wrote:
> To answer your question: as you noticed, I did not yet contribute any
> code to the SCST project. I'm an iSCSI/iSER/SRP user. I'd like to have
> a SCSI target framework available on Linux that is as fast as
> possible, as reliable as possible, as standards compliant as possible,
> well maintained and for which all kernel code is integrated in the
> mainstream Linux kernel. I'm probably sharing this desire with all
> STGT, IET, SCST and LIO users. Do you consider the opinion of SCSI
> target framework users irrelevant in this discussion ?

Yes.

Once Vladislav is ready for his project to be merged, let him approach
us and ask.  I don't know if he considers his project ready for merging.
Did he ask you for his help?  It's generally considered rather rude to
merge someone else's code without their consent.  The way you tried to
get it merged was unhelpful and, if Vladislav were less skillful a
communicator, could have actively hindered getting it merged.

The correct way to have done this would have been to start a thread on
the scst mailing list asking whether the developers felt it ready to
merge.  Then *leave it to them*.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
