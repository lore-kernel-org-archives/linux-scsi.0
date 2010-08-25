From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Wed, 25 Aug 2010 18:45:00 -0400
Message-ID: <20100825224500.GJ4453@thunk.org>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>
 <4C73DA15.2010207@vlnb.net>
 <AANLkTi=m15OJg+QsM76r1O74OWjdxht3tqza1DYEeLVw@mail.gmail.com>
 <201008251820.27293.konrad@darnok.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201008251820.27293.konrad@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Chris Weiss <cweiss@gmail.com>, Vladislav Bolkhovitin <vst@vlnb.net>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 25, 2010 at 06:20:26PM -0400, Konrad Rzeszutek Wilk wrote:
> On Tuesday 24 August 2010 10:51:04 Chris Weiss wrote:
> > On Tue, Aug 24, 2010 at 9:41 AM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> > > James Bottomley, on 08/22/2010 12:43 AM wrote:
> > >> Interface re-use (or at least ABI compatibility) is the whole point,
> > >> it's what makes the solution a drop in replacement.
> > >
> > > I see now. You want ABI compatibility to keep the "contract" that no
> > > kernel changes can break applications binary compatibility for unlimited
> > > time.
> >
> > ok now I'm confused, or maybe I'm not understanding ABI correctly, or
> > maybe you guys are using it in a way that is inconsistent with popular
> 
> You are thinking of the KABI. That changes per each release except
> if you buy a vendor product. Red Hat for example keeps an KABI
> symbol list where they guarantee that those parameters, structures
> ,etc will never change. John Masters wrote a nice paper about how
> they solved this:
> http://dup.et.redhat.com/presentations/DriverUpdateProgramTechnical.pdf

Just to make sure people aren't getting more confused.  What Red Hat
calls the KABI (and SLES and Ubuntu do something similar) is the
Kernel ABI which is presented to kernel modules.  This is important
for companies shipping out-of-tree and proprietary kernel modules.
(And we'll ignore the questions about whether such proprietary kernel
modules violate the GPL or not; contact your favorite lawyer for an
opinion on that subject.  It depends on the facts of the case and your
legal jourisdiction, almost certainly.)

> In terms of ABI, think ioctl calls and its a parameters. They are suppose to 
> stay the same for long long durations.

When we talk about the ABI must be constant, this is the kernel
interface presented to userspace programs, including statically linked
userspace progams.   So system calls, ioctl's, etc.

This is what allows you to download or purchase a userspace program
(including silly things like DB2, or Oracle Database, or Adobe Flash),
and it will work even if you upgrade your kernel.

						- Ted
