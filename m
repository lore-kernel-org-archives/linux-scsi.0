From: "Smith, Hibbard" <Hibbard.Smith@nasdaq.com>
Subject: 53c8xx_2 driver for SymBios SCSI adapters
Date: Thu, 17 Jun 2004 11:31:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <42DB3021E70A164EB14AAD5181F8280D2B8460@mer-exch2.corp.nasdaq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mer-tsm1.nasdaq.com ([206.200.253.23]:23822 "EHLO
	MER-TSM1.NASDAQ.COM") by vger.kernel.org with ESMTP id S266528AbUFQPbu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2004 11:31:50 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: matthew@wil.cx

Is anyone actually maintaining or working on this driver?? Somewhere between 2.4.26 and 2.6.5 it got broken.  It's still broken in 2.6.6 and 2.6.7 rc2.  The MAINTAINERs file lists the maintainer as Matthew Wilcox (email matthew@wil.cx).  Emails to that address bounce.  Articles to this list get no response from anyone.  The last posting in this list from Matthew (that I can find) is back in 2003.  I have previously posted to this list about this problem.

The bug has been reported in this mailing list which, apparently, is the only way to communicate with the developer listed in the MAINTAINERS file.  The bug has also been reported a couple of times in the Fedora Bugzilla for core 2.

When the kernel is initializing, the driver recognizes the SymBios 53c1010-33 chips on the motherboard, goes through several initialization messages and then begins domain validation.  At this point, everything hangs for awhile, then aborts and starts a cycle of SCSI bus resets from which it never recovers.  The system then hangs for up to a half hour.  That's the longest I've let it sit.  I'm sure it's gone for good.

I would be happy to attempt to get more information, if someone could tell me how to get more verbosity from the driver.  The 53c8xx_2.txt file in the Documentation/scsi directory is very old and out of date, and the driver options it talks about appear to no longer work.

Since this is an all SCSI system, and this embedded chipset is the first SCSI adapter the kernel tries to initialize, I can't get to a 2.6.? kernel.  I would really like to do that to take advantage of some of the new features in 2.6.

This system is an ASUS CUV4X-DLS with Via 694/686 chipset, 2 x 1Ghz PIII's and 524 MB of Ram.  Currently the only SCSI adapter is the embedded dual channel 53c1010-33 chipset.  It runs great with a 2.4.26 SMP kernel.

Hibbard T. Smith, JR
smitty@essnjay.com



