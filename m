From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: I/O write ordering
Date: Thu, 23 Sep 2004 01:11:03 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095865863.6340.7.camel@gaston>
References: <1095789421.2467.414.camel@mulgrave>
	 <200409211409.11095.jbarnes@engr.sgi.com>
	 <20040921190625.GB11708@colo.lackof.org> <20040921210341.GC146363@sgi.com>
	 <20040921211108.GA16153@parcelfarce.linux.theplanet.co.uk>
	 <20040921214302.GG146363@sgi.com>
	 <20040922000211.GE16153@parcelfarce.linux.theplanet.co.uk>
	 <20040922011652.GD147856@sgi.com> <20040922014428.GD20053@colo.lackof.org>
	 <20040922025805.GA148414@sgi.com>
	 <20040922143208.GL16153@parcelfarce.linux.theplanet.co.uk>
	 <1095864485.2143.1.camel@mulgrave>  <1095864709.6297.5.camel@gaston>
	 <1095865892.1715.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:38866 "EHLO gate.crashing.org")
	by vger.kernel.org with ESMTP id S266128AbUIVPPL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2004 11:15:11 -0400
In-Reply-To: <1095865892.1715.5.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Jeremy Higdon <jeremy@sgi.com>, Grant Grundler <grundler@parisc-linux.org>, Jesse Barnes <jbarnes@engr.sgi.com>, Matthew Wilcox <willy@debian.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>, Richard Henderson <rth@twiddle.net>, Paul Mackerras <paulus@samba.org>


> Just to be sure we're talking about the same thing; by cacheable and
> non-cacheable are you thinking about what PCI calls consistent and
> streaming (because your consistent memory is implemented as
> non-cacheable) or is this really the fact that PCI memory space as seen
> by the CPU is all uncacheable?

Set by the CPU as non-cacheable.

Ben.


