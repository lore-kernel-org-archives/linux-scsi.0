From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 06 Dec 2006 12:50:37 -0600
Message-ID: <1165431037.2810.55.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.44L0.0612061105500.3298-100000@iolanthe.rowland.org>
	 <1165423635.2810.33.camel@mulgrave.il.steeleye.com>
	 <4577029f./DIiz5nuoOKd82Zo%Joerg.Schilling@fokus.fraunhofer.de>
	 <1165427946.2810.46.camel@mulgrave.il.steeleye.com>
	 <45770E39.9070007@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:36375 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S937090AbWLFSvG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2006 13:51:06 -0500
In-Reply-To: <45770E39.9070007@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, stern@rowland.harvard.edu, schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, dgilbert@interlog.com

On Wed, 2006-12-06 at 13:38 -0500, Douglas Gilbert wrote:
> SPI is dead. Get used to it. SCSI has not meant SPI for
> years. We should be in the business of disabusing people
> of that idea, not reinforcing it.

I don't believe I said anything in favour of or against SPI.

I think you'll find the whole point of SAM is separating the command set
from the transport and interconnect.  Saying a device speaks "SCSI" has
no real meaning in that context anymore.  It's commonly taken to mean
SCSI-2 where the whole things was lumped together and SPI centric.

In the SAM context, a modern IDE CD is MMC over an ATAPI or SATAPI
transport. An old SCSI CD is MMC over SPI.  The thing Alan's having
trouble with is MMC over a USB transport.

> If you went to www.t10.org and looked at draft documents
> and the reflector you would be lucky to find any documents
> or posts about SPI in the last two years.

James


