From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 0/16]  qla2xxx: update qla2xxx driver to 8.01.02-k.
Date: Fri, 21 Oct 2005 14:07:46 -0700
Message-ID: <20051021210746.GK6488@plap.qlogic.org>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com> <20051019174209.GP9087@plap.qlogic.org> <1129852064.3115.18.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:53756 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751015AbVJUVHt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Oct 2005 17:07:49 -0400
Content-Disposition: inline
In-Reply-To: <1129852064.3115.18.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 20 Oct 2005, James Bottomley wrote:

> On Wed, 2005-10-19 at 10:42 -0700, Andrew Vasquez wrote:
> > Given all the activity promted with this patchset, could you provide
> > some insight on which patches you have queued for inclusion into
> > scsi-misc?
> > 
> > The scsi-misc-2.6 GIT tree has been dormant for some time and I would
> > like to have some direction on which patches I should cherrypick and
> > rebase given a number of updates to linux-2.6.git for the qla2xxx
> > driver as well as the rport interface updates proposed by James S.
> 
> Actually, none at the moment.  When a patch set comes as a list of
> patches, I generally tend to assume that they are all interdependent
> (although sometimes if there's objection to only a single component
> patch, I will pull that out if possible).
> 
> So for the monolithic set, I'll put them in when all the objections are
> worked out on the list.  If there are pieces I can apply now which
> everyone's happy with, tell me what they are.

Ok, how about I rework my patchset based off linux-2.6.git with
scsi-misc-2.6.git merged and the rport interface updates proposed by
James S:

[PATCH - repost] update fc_transport for removal of block/unblock functions
http://marc.theaimsgroup.com/?l=linux-scsi&m=112965152011520&w=2


that would seem like a reasonable base to begin with, no?

--
Andrew Vasquez
