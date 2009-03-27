From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Next March 25: Boot failure on powerpc [recursive locking
	detected]
Date: Fri, 27 Mar 2009 07:42:08 +0100
Message-ID: <20090327064208.GQ27476@kernel.dk>
References: <20090325191229.0e17eaf6.sfr@canb.auug.org.au> <49CA3BF4.3050801@in.ibm.com> <49CB2200.50703@in.ibm.com> <1238075403.3342.1.camel@localhost.localdomain> <20090327165624.47a29945.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090327165624.47a29945.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Sachin Sant <sachinp@in.ibm.com>, linuxppc-dev@ozlabs.org, linux-next@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 27 2009, Stephen Rothwell wrote:
> Hi all,
> 
> On Thu, 26 Mar 2009 08:50:03 -0500 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >
> > On Thu, 2009-03-26 at 12:04 +0530, Sachin Sant wrote:
> > > Sachin Sant wrote:
> > > > Today's next failed to boot on a powerpc box
> > > > (Power6 blade IBM,7998-61X) with following recursive locking message.
> > > >
> > > > =============================================
> > > > [ INFO: possible recursive locking detected ]
> > > > 2.6.29-next-20090325 #1
> > > After bisecting the failure seems to be because of the following
> > > patch from James ( block: move SCSI timeout check into block )
> > > 
> > > http://patchwork.kernel.org/patch/8017/
> > > 
> > > If i back out the above mentioned patch, the machine boots fine
> > > without any problems.
> > 
> > Yes, that patch already got dropped for other reasons:
> > 
> > http://marc.info/?t=123740773700002
> > 
> > I'm going to see if I can redo it in a better way, since moving this
> > type of timeout checking from scsi to block is a useful generalisation.
> 
> I will revert it from next-20090327 as well as it is still in the
> for-next branch of the block tree.

I'll update for-next, sorry about that. I had dropped it from
for-2.6.30, but forgot to update akpm/next branches.

-- 
Jens Axboe
