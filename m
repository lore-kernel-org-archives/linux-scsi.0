From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device
 structure
Date: Sat, 18 Jun 2011 14:40:17 -0500
Message-ID: <1308426017.2586.1273.camel@mulgrave>
References: <20110616181943.GB1439@kroah.com>
	 <1308256290.2436.143.camel@mulgrave>
	 <BANLkTikfCMR_=5Jp7tLhM_Wr3vxihEL+rA@mail.gmail.com>
	 <1308264321.2436.161.camel@mulgrave>
	 <BANLkTinvfmU0dszQyu4U=Pw3_BtrmOUi_g@mail.gmail.com>
	 <1308320844.2586.14.camel@mulgrave>
	 <BANLkTikMa6vO4m3tk1O2mtj76k6s66f2gQ@mail.gmail.com>
	 <1308322193.2586.30.camel@mulgrave>
	 <BANLkTinywFK3yAxN51O7RDYyqeNRHBRThA@mail.gmail.com>
	 <BANLkTinMzyQWZvxiRw4tvZBwW5xsxvMz-Q@mail.gmail.com>
	 <20110617162247.GA16261@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110617162247.GA16261@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 2011-06-17 at 09:22 -0700, Greg KH wrote:
> On Fri, Jun 17, 2011 at 06:12:14PM +0200, Kay Sievers wrote:
> > On Fri, Jun 17, 2011 at 17:39, Kay Sievers <kay.sievers@vrfy.org> wrote:
> > > On Fri, Jun 17, 2011 at 16:49, James Bottomley
> > 
> > >> So this is subsystem specific.  For the case of a SCSI enclosure, I can
> > >> answer that it's actually burned into the enclosure firmware.  When you
> > >> build an enclosure with labels, the label names are stored in a
> > >> diagnostic page.  We can actually interrogate the enclosure directly or
> > >> use the ses driver to get these names mapped to current devices.
> > >
> > > To me this sounds like a nice name on top of the current bunch of
> > > names, not like a 'preferred' name.
> > >
> > > I still don't like to introduce any new facility to the kernel that
> > > can handle only one single name. Reality the last years has taught us
> > > a very different story, and we've walked a long way to get where we
> > > are. I really don't believe single names will ever work, it's just a
> > > nice theory.
> > 
> > I might need to clarify this a bit.
> > 
> > I have no problem in general to add a 'alias' to every disk, and use
> > that when stuff is logged. Just the same way the netifs have an alias.
> > Sure, it might be useful for some use cases. And if that helps to
> > solve any real problem, we should just do it.
> > 
> > I just want to make clear, that I don't think that it is anywhere near
> > to a solution for the problems which are described here. And that
> > nobody should see this as an excuse not to get their stuff together
> > and work on the problem, which is that we don't have machine-readable
> > error and debug from the kernel and a smart syslog.
> > 
> > If we had that, I'm very sure nobody would even ask for a 'pretty
> > name' in the kernel, and I think that is a good indication that we are
> > not on the right track here.
> 
> And I totally agree here, which is why I don't want to accept this
> change to the driver core to add this, as it's not the correct solution.

OK, fine ... we'll do it as gendisk only then.  I suppose that is the
95% use case anyway.

Thanks,

James
