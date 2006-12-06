From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 06 Dec 2006 15:04:45 -0500
Message-ID: <4577225D.1090601@torque.net>
References: <Pine.LNX.4.44L0.0612061105500.3298-100000@iolanthe.rowland.org>	 <1165423635.2810.33.camel@mulgrave.il.steeleye.com>	 <4577029f./DIiz5nuoOKd82Zo%Joerg.Schilling@fokus.fraunhofer.de>	 <1165427946.2810.46.camel@mulgrave.il.steeleye.com>	 <45770E39.9070007@torque.net> <1165431037.2810.55.camel@mulgrave.il.steeleye.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:41707 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937589AbWLFUFC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2006 15:05:02 -0500
In-Reply-To: <1165431037.2810.55.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, stern@rowland.harvard.edu, schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, dgilbert@interlog.com

James Bottomley wrote:
> On Wed, 2006-12-06 at 13:38 -0500, Douglas Gilbert wrote:
>> SPI is dead. Get used to it. SCSI has not meant SPI for
>> years. We should be in the business of disabusing people
>> of that idea, not reinforcing it.
> 
> I don't believe I said anything in favour of or against SPI.

James,
My objection, and I believe Joerg's objection, is how
people would interpret this statement by you:
"This is probably semantics, but nowadays, SCSI means
SPI (or parallel SCSI)."

One could deduce from that statement, falsely, that the
linux SCSI subsystem was the linux SPI subsystem. Hence
we should mark it as legacy (and stop libata and the new
ATA subsystem from using it).

> I think you'll find the whole point of SAM is separating the command set
> from the transport and interconnect.  Saying a device speaks "SCSI" has
> no real meaning in that context anymore.  It's commonly taken to mean
> SCSI-2 where the whole things was lumped together and SPI centric.

SCSI is a storage architecture, a group of command sets and a
group of transports. The original SCSI transport, now considered
"legacy" (a horribly non-technical word) is SPI.

> In the SAM context, a modern IDE CD is MMC over an ATAPI or SATAPI
> transport. An old SCSI CD is MMC over SPI.  The thing Alan's having
> trouble with is MMC over a USB transport.

Agreed. And USB mass storage would probably be the most
used "SCSI" transport nowadays. Folks can and have written
their own subsystems for handling USB mass storage but
sooner or later they are going to be looking at read
capacity, sense buffers and mode pages. That is why the
SCSI subsystem continues to be relevant.


Doug Gilbert
