From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: lsscsi-0.17 released
Date: Wed, 22 Feb 2006 21:22:19 +0100
Message-ID: <20060222202219.GA25121@merlin.emma.line.org>
References: <43FBA4CD.6000505@torque.net> <m34q2r93q2.fsf@merlin.emma.line.org> <43FC7CCB.4090508@torque.net> <20060222160602.GB17473@merlin.emma.line.org> <43FC90E4.10805@torque.net> <20060222163426.GG28587@parisc-linux.org> <20060222171438.GA20272@kroah.com> <20060222180015.GB20880@merlin.emma.line.org> <20060222183226.GA12542@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1422664AbWBVUXF@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060222183226.GA12542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 22 Feb 2006, Greg KH wrote:

> On Wed, Feb 22, 2006 at 07:00:15PM +0100, Matthias Andree wrote:

> > OK, just post an announcement to l-k when sysfs has stabilized enough to
> > be worth bothering.
> 
> Um, this was a "bugfix".

Granted.

> The kernel was creating multiple symlinks with
> the same name, in the same directory, pointing to different locations.
> How do you expect us to fix that in a format that does not change the
> name of the symlink?
> 
> People sure are grumpy this morning...

If you say so. I'd call it pure pragmatism: if the sysfs interface
still changes every other week or so, it's just annoying to chase these
changes in applications, so it seems just practical to wait until all
the bug fixes that require interface changes are in and the rate of
incompatible changes is well below 2/year -- and all the interesting
stuff is there.

-- 
Matthias Andree
