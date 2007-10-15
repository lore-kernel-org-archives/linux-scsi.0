From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 07:44:19 +0200
Message-ID: <4712FE33.3000400@s5r6.in-berlin.de>
References: <200710112011.22000.rob@landley.net> <4711AF18.3030201@davidnewall.com> <471255E4.3070009@s5r6.in-berlin.de> <200710141836.55211.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:38455 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbXJOFpE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 01:45:04 -0400
In-Reply-To: <200710141836.55211.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: David Newall <david@davidnewall.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

Rob Landley wrote:
> I was at least attempting to ask a serious question.
...
> Actually, I was going through Documentation/block thinking about making a 
> 00-INDEX for it, but my earlier questions of the scsi guys left me with the 
> impression that the block layer is _not_ used by the SCSI layer.

Ah, so it was about your documentation work.  I already forgot the
context of your previous inquiries.  Alas the tone of them already did
some damage, leading to responses like these.

...
> since 
> every non-embedded modern storage device I'm aware of has been consumed by 
> the SCSI layer (despite none of them actually having a discernably closer 
> relationship to SCSI than ATA did)
...

The Linux SCSI subsystems don't consume, they provide services; nowadays
not only for SCSI hardware and SCSI protocols but also for a number of
subsystems whose tasks are similar enough to SCSI subsystems to make the
SCSI core and upper SCSI layer useful to them too.

BTW:
| Now that IDE disks have been rerouted through the scsi layer, SATA goes
| through the scsi layer, USB goes through the scsi layer, firewire goes
| through the scsi layer...

As a side note, SBP-2 is a SCSI transport protocol, hence ieee1394/sbp2
and firewire/fw-sbp2 are Linux SCSI low-level drivers.  Anything else
would be just wrong and infeasible in this particular case.
-- 
Stefan Richter
-=====-=-=== =-=- -====
http://arcgraph.de/sr/
