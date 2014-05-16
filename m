From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI "staging" tree for linux-next?
Date: Fri, 16 May 2014 15:01:16 -0700
Message-ID: <1400277676.16968.2.camel@dabdike.int.hansenpartnership.com>
References: <20140515052645.GA26266@infradead.org>
	 <537614CC.6020602@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <537614CC.6020602@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-05-16 at 15:38 +0200, Hannes Reinecke wrote:
> On 05/15/2014 07:26 AM, Christoph Hellwig wrote:
> > Hi James,
> >
> > we're past -rc5 and no SCSI patches have been collected for 3.16 yet,
> > despite a lot of patches including a lot of reviewed ones pending on the
> > list.
> >
> > I'd really love to get at least some testing for all the work that
> > sometimes has been pending for months in linux-next and would offer to
> > put together a tree of reviewed patches for linux-next.  Is this fine
> > with you?
> >
> Seconded. Having a staging tree would make my life _so_ much easier.

OK, I think we can do this easily.  Send me your staging branches and
I'll pull them into a global staging branch and merge it with for-next
in linux-scsi ... this will ensure we don't get yelled at for duplicate
commits causing merge rejections in linux-next.  Since staging will be
volatile and for the purposes of testing patches on upstream track, we
don't need signed tags or anything.

James
