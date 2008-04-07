From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: mptsas problem
Date: Sun, 6 Apr 2008 21:04:53 -0400
Message-ID: <20080407010453.GA1952@animx.eu.org>
References: <47F95F5C.500@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from animx.eu.org ([216.98.75.249]:60384 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755501AbYDGBE7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Apr 2008 21:04:59 -0400
Content-Disposition: inline
In-Reply-To: <47F95F5C.500@sauce.co.nz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-scsi@vger.kernel.org

Richard Scobie wrote:
> > I recall seeing some of this problem on the list a few days ago, but 
> I > can't remember what the subject was and was unable to find the thread.
> 
> You are perhaps thinking of this:
> 
> http://marc.info/?l=linux-scsi&m=120696978819085&w=2

Yes.

> but it seems to be a different issue.

Ok.

> From the message you posted, it looks as though there may be a problem 
> with sda.

It's working fine with /sys/block/sd[abc]/device/queue_depth = 1 (on boot up,
as stated before, it's 64)

I performed the same copy again with queue_depth=1 after the array rebuilt.
It worked fine then.  No errors.

> Does smartctl -a -d ata /dev/sda show any obvious problems?

smartctl doesn't work on sd[a-d] at all:
# smartctl -a -d ata /dev/sdd
smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

Smartctl: Device Read Identity Failed (not an ATA/ATAPI device)

A mandatory SMART command failed: exiting. To continue, add one or more '-T
permissive' options.
# smartctl -a -d ata -T permissive /dev/sdd
smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

Smartctl: Device Read Identity Failed (not an ATA/ATAPI device)

=== START OF INFORMATION SECTION ===
Device Model:     [No Information Found]
Serial Number:    [No Information Found]
Firmware Version: [No Information Found]
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   1
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Sun Apr  6 21:02:45 2008 EDT
SMART is only available in ATA Version 3 Revision 3 or greater.
We will try to proceed in spite of this.
SMART support is: Ambiguous - ATA IDENTIFY DEVICE words 82-83 don't show if SMART supported.
                  Checking for SMART support by trying SMART ENABLE command.
Error SMART Enable failed: Invalid argument
                  SMART ENABLE failed - this establishes that this device lacks SMART functionality.
A mandatory SMART command failed: exiting. To continue, add one or more '-T permissive' options.
# 

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
