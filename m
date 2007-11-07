From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Add Documentation/DocBook/scsi_midlayer.tmpl and
	update kerneldoc comments and Makefile.
Date: Tue, 06 Nov 2007 22:47:20 -0800
Message-ID: <1194418040.3545.31.camel@localhost.localdomain>
References: <200710262318.01021.rob@landley.net>
	 <200710290512.11549.rob@landley.net>
	 <1194056920.3407.97.camel@localhost.localdomain>
	 <200711031330.39906.rob@landley.net>
	 <20071104100252.c3e08c71.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:56356 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755707AbXKGGrY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Nov 2007 01:47:24 -0500
In-Reply-To: <20071104100252.c3e08c71.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Rob Landley <rob@landley.net>, linux-scsi@vger.kernel.org, "Stephen M.Cameron" <steve.cameron@hp.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>

On Sun, 2007-11-04 at 10:02 -0800, Randy Dunlap wrote:
> On Sat, 3 Nov 2007 13:30:39 -0500 Rob Landley wrote:
> 
> > From: Rob Landley <rob@landley.net>
> > 
> > Add Documentation/DocBook/scsi_midlayer.tmpl, add to Makefile, and update
> > lots of kerneldoc comments in drivers/scsi/*.
> > 
> > Updated with comments from Stefan Richter, Stephen M. Cameron,
> >  James Bottomley and Randy Dunlap.
> > 
> > Signed-off-by: Rob Landley <rob@landley.net>
> > ---
> > 
> >  Documentation/DocBook/Makefile           |    2 
> >  Documentation/DocBook/scsi_midlayer.tmpl |  409 +++++++++++++++++++++
> 
> 
> My only concern with this ATM is its name (SCSI midlayer), but
> chapter 2 is SCSI upper layer, chap 3 is SCSI midlayer, and
> chap 4 is SCSI low-level interfaces.
> 
> Chapters 2 & 4 are mostly stubs or todo list, which is OK, but if
> those chapters remain in this docbook, it looks like the docbook
> name should be changed (maybe later).

How about just scsi.tmpl then?

James


