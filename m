From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH for-2.6.39] [SCSI] scsi_dh_emc: fix panic when handling
 multiple path failures
Date: Wed, 23 Mar 2011 19:02:59 -0400
Message-ID: <20110323230259.GA3758@redhat.com>
References: <1300737433-11994-1-git-send-email-snitzer@redhat.com>
 <1300737774.10634.37.camel@mulgrave.site>
 <20110321203829.GB12157@redhat.com>
 <1300740249.10634.43.camel@mulgrave.site>
 <20110321231657.GA12902@redhat.com>
 <20110323215826.GA3433@redhat.com>
 <1300917791.15899.39.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932755Ab1CWXDE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Mar 2011 19:03:04 -0400
Content-Disposition: inline
In-Reply-To: <1300917791.15899.39.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Eddie Williams <eddie.williams@steeleye.com>

On Wed, Mar 23 2011 at  6:03pm -0400,
James Bottomley <James.Bottomley@suse.de> wrote:

> On Wed, 2011-03-23 at 17:58 -0400, Mike Snitzer wrote:
> > On Mon, Mar 21 2011 at  7:16pm -0400,
> > Mike Snitzer <snitzer@redhat.com> wrote:
> > 
> > > > It's a bug fix: of course it can.
> > > 
> > > Right, so given scsi_dh_activate()'s {get,put}_device() that wraps the
> > > call to scsi_dh->activate (aka clariion_activate) I'm not seeing how
> > > accessing sdev->sdev_gendev (via sdev_printk) could result in a panic.
> > > So I'll need to dig deeper (hopefully with Eddie's assistance)...
> > 
> > Hi James,
> > 
> > I checked with Eddie and the sdev_printk() panic he saw no longer occurs
> > when commit db422318 is in place.  But he also tested with the patch I
> > provided below.
> > 
> > I still feel this fix is needed and would like to get your feedback on
> > this (relative to 2.6.39):
> 
> So what about the fix you propose in
> 
> Message-id: <20110321231657.GA12902@redhat.com>
> 
> ?  That looks to be the correct one.

Yes, that is the correct fix (that is the same patch I quoted in my mail
preceeding this one).

We'd need it in 2.6.38.y too.

Thanks,
Mike
