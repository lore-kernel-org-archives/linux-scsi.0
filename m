From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [LSF/MM TOPIC][ATTEND] protection information and userspace
Date: Fri, 8 Feb 2013 01:38:21 -0800
Message-ID: <20130208093820.GC2733@localhost>
References: <20130206202444.GA4771@blackbox.djwong.org>
 <20DAFDEA-0C44-478E-B406-C5B08BC67FBC@oracle.com>
 <20130207094012.GA28047@localhost>
 <20130207100139.GB4773@blackbox.djwong.org>
 <51138FA0.1080507@suse.de>
 <51139940.3000902@panasas.com>
 <x497gmkgkpc.fsf@segfault.boston.devel.redhat.com>
 <20130207172735.GR14246@lenny.home.zabbo.net>
 <20130207173639.GB29575@localhost>
 <20130207210436.GC6398@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:53387 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161046Ab3BHJii (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2013 04:38:38 -0500
Content-Disposition: inline
In-Reply-To: <20130207210436.GC6398@fieldses.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Zach Brown <zab@redhat.com>, Jeff Moyer <jmoyer@redhat.com>, Boaz Harrosh <bharrosh@panasas.com>, Hannes Reinecke <hare@suse.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Chuck Lever <chuck.lever@oracle.com>, Ben Myers <bpm@sgi.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Thu, Feb 07, 2013 at 04:04:36PM -0500, J. Bruce Fields wrote:
> On Thu, Feb 07, 2013 at 09:36:39AM -0800, Joel Becker wrote:
> > Dear LSF committee,
> > 	I'd like to explicitly request attendance for this discussion
> > :-)
> 
> http://marc.info/?l=linux-fsdevel&m=135894412908342&w=2
> 
> 	"Also, the way I compile the list of requests is from thread
> 	heads ...  that means don't send your attendee request as a
> 	reply to something else either otherwise it might get missed."

Ack.  Send as such.

Thanks,
Joel

> 
> --b.
> 
> > 
> > Joel
> > 
> > On Thu, Feb 07, 2013 at 09:27:35AM -0800, Zach Brown wrote:
> > > On Thu, Feb 07, 2013 at 11:19:59AM -0500, Jeff Moyer wrote:
> > > > Boaz Harrosh <bharrosh@panasas.com> writes:
> > > > >> 
> > > > >> For aio we just need to add additional fields to an existing structure.
> > > > >> 
> > > > >> So yeah, I'd be interested in that discussion as well.
> > > > 
> > > > Sure, it's easy to start there, but then you eventually end up having to
> > > > add a non-aio interface as well.  Let's not take the latter off the
> > > > table.
> > > 
> > > I agree that a sync variant should't be ignored, but needing a sync
> > > interface with PI arguments also shouldn't get in the way of adding
> > > support to the aio+dio path.  Simply because it's what people use :/.
> > > 
> > > > I'm not sure how that's directly related to aio, but ok.  If we're going
> > > > to rewrite the aio code, I think Zach's acall would be a good start, at
> > > > least on the API front:
> > > >   http://lwn.net/Articles/316806/
> > > 
> > > Yeah, I'm happy to chat about this stuff if people are interested.  I
> > > think I'd do things differently today than what was done in that aged
> > > acall prototype.
> > > 
> > > - z
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > -- 
> > 
> > "You can get more with a kind word and a gun than you can with
> >  a kind word alone."
> >          - Al Capone
> > 
> > 			http://www.jlbec.org/
> > 			jlbec@evilplan.org
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

"You look in her eyes, the music begins to play.
 Hopeless romantics, here we go again."

			http://www.jlbec.org/
			jlbec@evilplan.org
