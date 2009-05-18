From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 03/13] block: Move queue limits to an embedded struct
Date: Mon, 18 May 2009 14:50:08 -0400
Message-ID: <20090518185007.GA839@redhat.com>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com> <1242362435-11953-4-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1242362435-11953-4-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: rwheeler@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, agk@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Fri, May 15 2009 at 12:40am -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> From: Martin K. Petersen <martin.petersen@oracle.com>
> 
> To accommodate stacking drivers that do not have an associated request
> queue we're moving the limits to a separate, embedded structure.

Given DM motivated this change, any reason you held off including the
associated DM changes (in a separate patch in the series)?  Your initial
DM patch looked reasonable.

On some level leaving that patch out of the series prevents reviewers
the opportunity to really see why a separate 'queue_limits' structure is
even needed.  The follow-up question being: is the topology
infrastructure adequately equipped to support DM?  I think so
but having others' review would be nice.

Are you looking for such DM changes to be submitted through Alasdair's
tree _after_ your changes go upstream through Jens' tree?

Regards,
Mike
