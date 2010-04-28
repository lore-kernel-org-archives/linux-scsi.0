From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 09/11] qla4xxx: Added support for ISP82XX
Date: Wed, 28 Apr 2010 18:25:02 -0500
Message-ID: <1272497102.14756.46.camel@mulgrave.site>
References: <20100428061431.GA11197@sles11sp1b1.qlogic.org>
	 <4BD7D7A1.3040507@cs.wisc.edu>
	 <B065E21A-3DB2-4303-B0DC-FB41F97F0225@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53983 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310Ab0D1XZJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Apr 2010 19:25:09 -0400
In-Reply-To: <B065E21A-3DB2-4303-B0DC-FB41F97F0225@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ravi.anand" <ravi.anand@qlogic.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Karen Higgins <karen.higgins@qlogic.com>, Randy Dunlap <randy.dunlap@oracle.com>

On Wed, 2010-04-28 at 16:11 -0700, ravi.anand wrote:
> On Apr 27, 2010, at 11:37 PM, Mike Christie wrote:
> 
> > On 04/28/2010 01:14 AM, Vikas Chaudhary wrote:
> >> Signed-off-by: Vikas Chaudhary<vikas.chaudhary@qlogic.com>
> >> Signed-off-by: Ravi Anand<ravi.anand@qlogic.com>
> >> Signed-off-by: Karen Higgins<karen.higgins@qlogic.com>
> >> ---
> >>   drivers/scsi/qla4xxx/Kconfig      |    4 +-
> >>   drivers/scsi/qla4xxx/Makefile     |    2 +-
> >>   drivers/scsi/qla4xxx/ql4_def.h    |  145 ++-
> >>   drivers/scsi/qla4xxx/ql4_fw.h     |  144 +++-
> >>   drivers/scsi/qla4xxx/ql4_glbl.h   |  115 ++-
> >>   drivers/scsi/qla4xxx/ql4_init.c   |  190 ++-
> >>   drivers/scsi/qla4xxx/ql4_inline.h |    2 +-
> >>   drivers/scsi/qla4xxx/ql4_iocb.c   |   73 +-
> >>   drivers/scsi/qla4xxx/ql4_isr.c    |  400 +++++-
> >>   drivers/scsi/qla4xxx/ql4_mbx.c    |  185 ++-
> >>   drivers/scsi/qla4xxx/ql4_nvram.c  |    2 +-
> >>   drivers/scsi/qla4xxx/ql4_nvram.h  |    6 +-
> >>   drivers/scsi/qla4xxx/ql4_nx.c     | 2556 ++++++++++++++++++++++++ 
> >> +++++++++++++
> >>   drivers/scsi/qla4xxx/ql4_nx.h     |  703 ++++++++++
> >>   drivers/scsi/qla4xxx/ql4_os.c     |  693 ++++++++---
> >>   15 files changed, 4831 insertions(+), 389 deletions(-)
> >>   create mode 100644 drivers/scsi/qla4xxx/ql4_nx.c
> >
> >
> > I did not review this patch adding new hw support due to waiting on
> > comments about the other patches.
> 
> James,
> 
> Are you going to pull in all the other patches except this one ?
> We can resubmit this one once Mike get a chance to review it.

Um, so I understood the comment to mean that Mike is still waiting for
you to comment on his questions and sugestions for patches 9,8,6,1 of
the original 12 patch series from 6 April ... unless I missed them?

As long as this 11 patch series reviews and applies independently, I'm
fine with dropping this and taking the rest.

> Just trying to understand how to proceed from here.
> 
> >
> >
> > The other patches look ok now. They just have comment about adding a
> > KERN_ in the printks but I think that is ignorable. Add a:
> > Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
> >
> >
> > This patch:
> > [PATCH 08/11] qla4xxx: fix ql4_mbx tcp_source_port_num
> > is already in Linus's tree I think, so it can be dropped by James  
> > if he
> > likes the patches.
> 
> 
> OK. Was not really sure, so pushed it to make sure it gets rolled in.

Yes, will just drop it.

James


