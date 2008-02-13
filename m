From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] enclosure: add support for enclosure services
Date: Wed, 13 Feb 2008 12:17:09 -0600
Message-ID: <1202926629.3109.63.camel@localhost.localdomain>
References: <1202172065.3096.154.camel@localhost.localdomain>
	 <922945.25870.qm@web31811.mail.mud.yahoo.com>
	 <20080212102244.32869382@appleyard>
	 <1202841935.3137.94.camel@localhost.localdomain>
	 <20080212110752.21840627@appleyard>
	 <1202844495.3137.120.camel@localhost.localdomain>
	 <20080213094502.4112d5e5@appleyard>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932521AbYBMSRe@vger.kernel.org>
In-Reply-To: <20080213094502.4112d5e5@appleyard>
Sender: linux-kernel-owner@vger.kernel.org
To: kristen.c.accardi@intel.com
Cc: ltuikov@yahoo.com, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, jeff@garzik.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2008-02-13 at 09:45 -0800, Kristen Carlson Accardi wrote:
> I don't think I'm arguing whether or not your solution may work, what I
> am arguing is really a more philosophical point.  Not "can we do it
> this way", but "should we do it way".  I am of the opinion that
> management belongs in userspace.  I also am of the opinion that if you
> can successfully accomplish something in user space, you should.  I
> also believe that even if you provide this basic interface, all system
> vendors are going to provide libraries on top of that to customize it,
> so you've not added much value to just a simple message passing
> interface.

I'm not necessarily arguing against that.  However, what you're
providing is slightly more than just a userspace tap into the enclosure.
You're adding a file to display and control the enclosure state
(sw_activity).  This constitutes an ad-hoc sysfs interface.  I'm not
telling you not to do it, but I am pleading that if we have to have all
these sysfs interfaces, lets at least do it in a uniform way.

Enclosures are such nasty beasts, that even the job of getting a tap
into them is problematic, so if we have a different tap infrastructure
for every different enclosure type and connection it's still going to be
pretty unmanageable to a userspace interface.

> So, I'm happy to defer to Jeff's judgement call here - I just want to
> do what's right for our customers and get an enclosure management
> interface for SATA exposed, preferrably in time for the 2.6.26 merge
> window.  If he prefers your design, I'll disagree, but commit to his
> decision and try to get this to work for SATA. If he'd rather see
> something along the lines of what I proposed, then since it is 100% self
> contained in the SATA subsystem, it shouldn't impact whatever you
> want to do in the SCSI subsystem.

James
