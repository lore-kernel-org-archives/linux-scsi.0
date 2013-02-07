From: Zach Brown <zab@redhat.com>
Subject: Re: [LSF/MM TOPIC][ATTEND] protection information and userspace
Date: Thu, 7 Feb 2013 09:27:35 -0800
Message-ID: <20130207172735.GR14246@lenny.home.zabbo.net>
References: <20130206195122.GA30652@sgi.com>
 <20130206202444.GA4771@blackbox.djwong.org>
 <20DAFDEA-0C44-478E-B406-C5B08BC67FBC@oracle.com>
 <20130207094012.GA28047@localhost>
 <20130207100139.GB4773@blackbox.djwong.org>
 <51138FA0.1080507@suse.de>
 <51139940.3000902@panasas.com>
 <x497gmkgkpc.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <x497gmkgkpc.fsf@segfault.boston.devel.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Hannes Reinecke <hare@suse.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Chuck Lever <chuck.lever@oracle.com>, Ben Myers <bpm@sgi.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 07, 2013 at 11:19:59AM -0500, Jeff Moyer wrote:
> Boaz Harrosh <bharrosh@panasas.com> writes:
> >> 
> >> For aio we just need to add additional fields to an existing structure.
> >> 
> >> So yeah, I'd be interested in that discussion as well.
> 
> Sure, it's easy to start there, but then you eventually end up having to
> add a non-aio interface as well.  Let's not take the latter off the
> table.

I agree that a sync variant should't be ignored, but needing a sync
interface with PI arguments also shouldn't get in the way of adding
support to the aio+dio path.  Simply because it's what people use :/.

> I'm not sure how that's directly related to aio, but ok.  If we're going
> to rewrite the aio code, I think Zach's acall would be a good start, at
> least on the API front:
>   http://lwn.net/Articles/316806/

Yeah, I'm happy to chat about this stuff if people are interested.  I
think I'd do things differently today than what was done in that aged
acall prototype.

- z
