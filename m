From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 1/3]  qla2xxx: Add full firmware(-request) hotplug support for all ISPs.
Date: Fri, 11 Nov 2005 00:08:37 -0800
Message-ID: <20051111080837.GB11653@andrew-vasquezs-powerbook-g4-15.local>
References: <20051109234846.4868.25487.sendpatchset@andrew-vasquezs-powerbook-g4-15.local> <20051109234901.4868.27256.sendpatchset@andrew-vasquezs-powerbook-g4-15.local> <20051110105846.GA9222@infradead.org> <20051111004718.GP5678@andrew-vasquezs-powerbook-g4-15.local> <20051111073002.GA3233@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:51088 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751255AbVKKIIk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Nov 2005 03:08:40 -0500
Content-Disposition: inline
In-Reply-To: <20051111073002.GA3233@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 11 Nov 2005, Christoph Hellwig wrote:

> On Thu, Nov 10, 2005 at 04:47:18PM -0800, Andrew Vasquez wrote:
> > Sure, sounds reasonable -- perhaps we can get some consensus from the
> > list and come up with the date (arbitrary as it may be), at least it
> > would motivate those affected (QLogic)...
> 
> sure.  Does June 2006 sounds reasonable?

Fine with me.

> > I'm inclined to drop the help-text entirely for the firmware-module
> > entries, as I'm not sure one needs more info than the menu-item:
> > 
> > 	[ ] Build QLogic ISP2100 firmware-module
> > 
> > already states.  What were you looking for?
> 
> Dropping the help text makes sense.

done.

> > > I'd say just use this else clause unconditionally.  no need to optimize for
> > > the 1% users using the deprecated builtin-firmware and compile just for
> > > a subsystet of the supported cards.
> > 
> > As this patchset looks to be more 2.6.16 material, I'll redo the
> > patches with this change along with any additional feedback and a few
> > minor bits.
> > 
> > James, would you like me to resubmit now for staging in scsi-misc-2.6
> > for 2.6.16?
> 
> Given that it's needed to support the ISP24xx i'd love to see it in
> 2.6.15

Sending the updated patchset now...

-- 
Andrew Vasquez
