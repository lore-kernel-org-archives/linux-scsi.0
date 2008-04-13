From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: mptsas problem
Date: Sun, 13 Apr 2008 13:06:44 -0400
Message-ID: <20080413170644.GA1234@animx.eu.org>
References: <47F95F5C.500@sauce.co.nz> <20080407010453.GA1952@animx.eu.org> <1208097071.4707.21.camel@localhost.localdomain> <20080413164800.GA23094@animx.eu.org> <1208105925.4707.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from animx.eu.org ([216.98.75.249]:40931 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309AbYDMRGu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Apr 2008 13:06:50 -0400
Content-Disposition: inline
In-Reply-To: <1208105925.4707.27.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Richard Scobie <richard@sauce.co.nz>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Sun, 2008-04-13 at 12:48 -0400, Wakko Warner wrote:
> > > Actually, I'd say this is a signal for NCQ errors with the drive.
> > 
> > Unless it's this specific drive firmware, I'd have to disagree.  I have 6 of
> > the exact same drives (can't confirm firmware is the same though) in raid5
> > on an aic9410 sas controller w/o problems.  The queue_depth for those are
> > 31.  I considered setting that value to the ones I'm having problems with,
> > but I really don't want to go through another 4 hour rebuild.
> 
> Well, yes, different revs of the firmware can behave differently.  The
> libata-core blacklist includes the firmware version as part of the
> pattern matching.

> There's an easy way to verify:  smartctl -i will print the firmware
> version string.

The aic sas one shows 3.AAE
The lsi mptsas can't be queried:
# smartctl -d scsi -i /dev/sdc
smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

Serial number:             3QD076X8
Device type: disk
Local Time is: Sun Apr 13 13:02:36 2008 EDT
Device supports SMART and is Enabled
Temperature Warning Disabled or Not Supported
#

I tried -d ata, -d sat and not using -d, provided no information.  -T
permissive didn't work either.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
