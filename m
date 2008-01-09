From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Number of devices that SCSI can support
Date: Wed, 9 Jan 2008 07:49:33 -0800
Message-ID: <20080109154933.GC29564@plap3.qlogic.org>
References: <404714.86520.qm@web43145.mail.sp1.yahoo.com> <20080109022233.GM16309@parisc-linux.org> <1199891152.3493.6.camel@localhost.localdomain> <20080109153601.GR16309@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:14603 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbYAIPtj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 10:49:39 -0500
Content-Disposition: inline
In-Reply-To: <20080109153601.GR16309@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vinay Venkataraghavan <raghavanvinay@yahoo.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

On Wed, 09 Jan 2008, Matthew Wilcox wrote:

> On Wed, Jan 09, 2008 at 09:05:52AM -0600, James Bottomley wrote:
> > On Tue, 2008-01-08 at 19:22 -0700, Matthew Wilcox wrote:
> > > On Tue, Jan 08, 2008 at 04:55:46PM -0800, Vinay Venkataraghavan wrote:
> > > > Is there a limit on the number of devices that SCSI supports. In other words, I have a QLogic HBA card, and I am connecting to a SAN which has 64 targets. 
> > > 
> > > I've personally had over five hundred LUNs.  You shouldn't be hitting a
> > > limit here.
> > 
> > I believe the largest test that's been run was the old OSDL CGL
> > workgroup ... they went up to 4096.
> > 
> > However, LUN support depends on the driver and HBA parameters as well
> > (some choose to have arbitrary limits).
> 
> I was using a qlogic HBA for my tests, so I don't think this is the
> problem -- although the original poster claims to have 64 targets, and I
> had only one target with 128 luns (attached 4 times).
> 
> -- 
> Intel are signing my paycheques ... these opinions are still mine
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."

Not sure what's going on as well, perhaps some logs could help... But
the inbox qla2xxx driver in RHEL4 set's an HBA's scsi_host->max_id
count to 512 (also verified with several test rings), so there
shouldn't be a problem handling 64 distinct targets (FC ports).
