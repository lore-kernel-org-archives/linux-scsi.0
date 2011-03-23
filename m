From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH for-2.6.39] [SCSI] scsi_dh_emc: fix panic when handling
 multiple path failures
Date: Wed, 23 Mar 2011 17:03:11 -0500
Message-ID: <1300917791.15899.39.camel@mulgrave.site>
References: <1300737433-11994-1-git-send-email-snitzer@redhat.com>
	 <1300737774.10634.37.camel@mulgrave.site>
	 <20110321203829.GB12157@redhat.com>
	 <1300740249.10634.43.camel@mulgrave.site>
	 <20110321231657.GA12902@redhat.com>  <20110323215826.GA3433@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207Ab1CWWDR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Mar 2011 18:03:17 -0400
In-Reply-To: <20110323215826.GA3433@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, Eddie Williams <eddie.williams@steeleye.com>

On Wed, 2011-03-23 at 17:58 -0400, Mike Snitzer wrote:
> On Mon, Mar 21 2011 at  7:16pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > > It's a bug fix: of course it can.
> > 
> > Right, so given scsi_dh_activate()'s {get,put}_device() that wraps the
> > call to scsi_dh->activate (aka clariion_activate) I'm not seeing how
> > accessing sdev->sdev_gendev (via sdev_printk) could result in a panic.
> > So I'll need to dig deeper (hopefully with Eddie's assistance)...
> 
> Hi James,
> 
> I checked with Eddie and the sdev_printk() panic he saw no longer occurs
> when commit db422318 is in place.  But he also tested with the patch I
> provided below.
> 
> I still feel this fix is needed and would like to get your feedback on
> this (relative to 2.6.39):

So what about the fix you propose in

Message-id: <20110321231657.GA12902@redhat.com>

?  That looks to be the correct one.

James


