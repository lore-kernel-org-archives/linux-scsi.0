From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 03/13] block: Move queue limits to an embedded struct
Date: Mon, 18 May 2009 14:52:34 -0400
Message-ID: <20090518185233.GB839@redhat.com>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com> <1242362435-11953-4-git-send-email-martin.petersen@oracle.com> <20090518185007.GA839@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59406 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbZERSxe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 May 2009 14:53:34 -0400
Content-Disposition: inline
In-Reply-To: <20090518185007.GA839@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: rwheeler@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, agk@redhat.com

On Mon, May 18 2009 at  2:50pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Fri, May 15 2009 at 12:40am -0400,
> Martin K. Petersen <martin.petersen@oracle.com> wrote:
> 
> > From: Martin K. Petersen <martin.petersen@oracle.com>
> > 
> > To accommodate stacking drivers that do not have an associated request
> > queue we're moving the limits to a separate, embedded structure.
> 
> Given DM motivated this change, any reason you held off including the
> associated DM changes (in a separate patch in the series)?  Your initial
> DM patch looked reasonable.

I forgot to reference the patch in question:
http://mkp.net/code/topology/dm-topology.patch
