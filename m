From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] QStor SATA/RAID driver for 2.6.9-rc3
Date: Tue, 12 Oct 2004 13:05:26 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20041012170526.GB9274@havoc.gtf.org>
References: <4165A85D.7080704@rtr.ca> <4165AB1B.8000204@pobox.com> <4165ACF8.8060208@rtr.ca> <20041007221537.A17712@infradead.org> <1097241583.2412.15.camel@mulgrave> <4166AF2F.6070904@rtr.ca> <1097249266.1678.40.camel@mulgrave> <4166B37D.8030701@rtr.ca> <1097251299.1928.56.camel@mulgrave> <416C0DC5.2080206@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S266366AbUJLRJe@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <416C0DC5.2080206@rtr.ca>
To: Mark Lord <lkml@rtr.ca>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, Mark Lord <lsml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 12, 2004 at 01:00:53PM -0400, Mark Lord wrote:
> James Bottomley wrote:
> >On Fri, 2004-10-08 at 10:34, Mark Lord wrote:
> >
> >>If those locks are not needed, the scsi.c maintainer really should
> >>nuke'em.
> >
> >I think you can safely assume he has more important things to do.
> 
> I was actually working on the assumption that the lock might be
> there because it is/was necessary for something, like perhaps protecting
> access to the add_timer()/del_timer() calls associated with the scmd?
> 
> If not, no issue -- it can be removed from the driver.


I'll respectfully disagree with James...  I think the most prudent
course of action is to follow the example of SCSI common code.

If the SCSI core is doing something wrong, we should fix that _first_,
not set a precedent of confusing dissociation.

Everyone knows that Linux programmers engineer with their cut-n-paste
feature.

	Jeff
