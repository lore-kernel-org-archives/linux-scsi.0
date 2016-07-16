From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: PR API fixes for multipathing
Date: Sat, 16 Jul 2016 14:25:59 -0400
Message-ID: <20160716182559.GA15221@redhat.com>
References: <1467980631-18945-1-git-send-email-hch@lst.de>
 <yq1y452iuzp.fsf@sermon.lab.mkp.net>
 <20160716010844.GA29087@lst.de>
 <20160716181007.GA14215@redhat.com>
 <1468692889.13349.17.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbcGPS0B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Jul 2016 14:26:01 -0400
Content-Disposition: inline
In-Reply-To: <1468692889.13349.17.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org

On Sat, Jul 16 2016 at  2:14pm -0400,
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Sat, 2016-07-16 at 14:10 -0400, Mike Snitzer wrote:
> > On Fri, Jul 15 2016 at  9:08pm -0400,
> > Christoph Hellwig <hch@lst.de> wrote:
> > 
> > > On Fri, Jul 15, 2016 at 03:03:54PM -0400, Martin K. Petersen wrote:
> > > > > > > > > "Christoph" == Christoph Hellwig <hch@lst.de> writes:
> > > > 
> > > > Christoph> I was a bit overeager to thing ALL_TG_PT would solve
> > > > all our
> > > > Christoph> multipathing woes in respect to persistent
> > > > reservation.
> > > > Christoph> Turns out that there are lots of possible setups where
> > > > it
> > > > Christoph> doesn't work, and we'll have to ask device mapper to
> > > > register
> > > > Christoph> all underlying devices instead.
> > > > 
> > > > Should I queue the sd patch or let Mike take both through the DM
> > > > tree?
> > > 
> > > I think having both in the same tree would be very useful.  I don't 
> > > care which one that is.
> > 
> > I've picked both of them up.  Staged for 4.8 merge and in linux-next 
> > via linux-dm.git's 'for-next'.
> > 
> > (I added Martin's Acked-by to the sd patch header, Martin: if not OK, 
> > or if you'd prefer Reviewed-by just let me know)
> 
> You are actually missing the reviewed by tags from Mike Christie on
> this, which should be added.

Added, thanks!
