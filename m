From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Lsf] Preliminary Agenda and Activities for LSF
Date: Wed, 30 Mar 2011 18:05:08 -0600
Message-ID: <20110331000508.GV13806@parisc-linux.org>
References: <1301373398.2590.20.camel@mulgrave.site> <4D91BF90.8070909@redhat.com> <1301445210.2731.14.camel@mingming-laptop> <20110330021742.GL3008@dastard> <1301521798.7449.65.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1301521798.7449.65.camel@mingming-laptop>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Cc: Dave Chinner <david@fromorbit.com>, Ric Wheeler <rwheeler@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, lsf@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 30, 2011 at 02:49:58PM -0700, Mingming Cao wrote:
> > Direct IO semantics have always been that the application is allowed
> > to overlap IO to the same range if it wants to. The result is
> > undefined (just like issuing overlapping reads and writes to a disk
> > at the same time) so it's the application's responsibility to avoid
> > overlapping IO if it is a problem.
> 
> I was thinking along the line to provide finer granularity lock to allow
> concurrent direct IO to different offset/range, but to same offset, they
> have to be serialized. If it's undefined behavior, i.e. overlapping is
> allowed, then concurrent dio implementation is much easier. But not sure
> if any apps currently using DIO aware of the ordering has to be done at
> the application level. 

Yes, they're aware of it.  And they consider it a bug if they ever do
concurrent I/O to the same sector.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
