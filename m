From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bugme-new] [Bug 9674] New: Oops during rmmod'ing modeuls sdhci, sr_mod, ricoh_mmc, mmc_core
Date: Wed, 2 Jan 2008 13:21:31 +0100
Message-ID: <200801021321.32039.rjw@sisk.pl>
References: <bug-9674-10286@http.bugzilla.kernel.org/> <20080101181026.38298e13.akpm@linux-foundation.org> <1199244283.3252.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:40839 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbYABMT1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jan 2008 07:19:27 -0500
In-Reply-To: <1199244283.3252.13.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pierre Ossman <drzeus@drzeus.cx>, Jens Axboe <jens.axboe@oracle.com>, gentuu@gmail.com, linux-scsi <linux-scsi@vger.kernel.org>, bugme-daemon@bugzilla.kernel.org

On Wednesday, 2 of January 2008, James Bottomley wrote:
> 
> On Tue, 2008-01-01 at 18:10 -0800, Andrew Morton wrote:
> > On Tue,  1 Jan 2008 14:55:45 -0800 (PST) bugme-daemon@bugzilla.kernel.org wrote:
> > 
> > > http://bugzilla.kernel.org/show_bug.cgi?id=9674
> > > 
> > >            Summary: Oops during rmmod'ing modeuls sdhci, sr_mod, ricoh_mmc,
> > >                     mmc_core
> > 
> > Guys, this is a very recent regression.  Could you please take a look, see
> > if it's due to mmc, block or scsi changes?
> 
> There's not a lot of information to go on.  The stack trace looks bogus,
> so I guess the kernel is compiled without a frame pointer.

The bug report has been updated with a stack trace from a kernel compiled
with a frame pointer.  Please have a look.
