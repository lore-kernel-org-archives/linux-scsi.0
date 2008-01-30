From: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: Value of __*{init,exit} anotations?
Date: Wed, 30 Jan 2008 22:50:50 +0000
Message-ID: <20080130225050.GA10013@flint.arm.linux.org.uk>
References: <20080130200336.GN29368@does.not.exist> <1201726817.3292.84.camel@localhost.localdomain> <20080130212011.GA26621@uranus.ravnborg.org> <1201729295.3292.94.camel@localhost.localdomain> <20080130223219.GT29368@does.not.exist> <1201733052.3292.102.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34516 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbYA3Wvr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jan 2008 17:51:47 -0500
Content-Disposition: inline
In-Reply-To: <1201733052.3292.102.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>, davem@davemloft.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>

On Wed, Jan 30, 2008 at 04:44:12PM -0600, James Bottomley wrote:
> On Thu, 2008-01-31 at 00:32 +0200, Adrian Bunk wrote:
> > People at linux-arch (Cc'ed) might be better at explaining how often 
> > CONFIG_HOTPLUG gets used in real-life systems and how big the savings 
> > are there.
> > 
> > That might be a good basis for deciding whether it's worth it.
> 
> I'll certainly buy this.  Perhaps killing everything other than __init
> and __exit (meaning discardable whether the system is hotplug, suspend
> or whatever) might get rid of 90% of the problem while still preserving
> 90% of the benefits.  I think a lot of the issues do come from confusion
> over whether it should be __init, __devinint etc .

Just looking at HOTPLUG on ARM by a simple grep, 57 default configurations
for various machines are hotplug enabled out of 75 - so it's roughly 75%.
Whether that 25% remainder cares or not, I'm not sure.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
