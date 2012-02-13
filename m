From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: scsi_error: do not allow IO errors with certain ILLEGAL_REQUEST
 sense to be retryable
Date: Mon, 13 Feb 2012 13:59:48 -0500
Message-ID: <20120213185948.GA9229@redhat.com>
References: <1322857889-2623-1-git-send-email-snitzer@redhat.com>
 <yq1zkf5pfx1.fsf@sermon.lab.mkp.net>
 <20111206212704.GB30719@redhat.com>
 <yq1vcptpdch.fsf@sermon.lab.mkp.net>
 <20111206224218.GA31543@redhat.com>
 <20120213162923.GA29578@redhat.com>
 <yq1d39iipra.fsf@sermon.lab.mkp.net>
 <20120213181359.GA5803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120213181359.GA5803@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 13 2012 at  1:13pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Feb 13 2012 at 12:53pm -0500,
> Martin K. Petersen <martin.petersen@oracle.com> wrote:
> 
> > >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> > 
> > Mike> So that makes 3 different _prominent_ storage vendors, that I am
> > Mike> aware of, that are bitten by their broken storage (relative to
> > Mike> discard and properly advertising which variant they actually
> > Mike> support).  I'd much rather deal with the storage vendors (or their
> > Mike> customers) reporting that discards aren't working than mutual
> > Mike> customers reporting that they cannot even install to the storage.
> > 
> > More graceful handling of the sense data aside, we do have a couple of
> > options:
> > 
> >  1. Now that the provisioning portion seems to be stable in SBC-3 we can
> >     nuke the interim spec heuristics and only support devices that
> >     report the right thing. This may disable provisioning for some
> >     existing users whose arrays run non-compliant firmware.
> > 
> >  2. We can add another layer of heuristics based on the RSOC wrapper I
> >     introduced for write same. Maybe you could send me sg_opcodes output
> >     for the arrays in question?
> 
> Yeah, I think that would be welcomed evolution (but as you say,
> independent of improving additional ILLEGAL REQUEST processing).

That was a response to 1 above.

I don't have direct access to the arrays in question to get sg_opcodes.

But I can work on getting them.

Mike
