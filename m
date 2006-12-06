From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 06 Dec 2006 13:38:49 -0500
Message-ID: <45770E39.9070007@torque.net>
References: <Pine.LNX.4.44L0.0612061105500.3298-100000@iolanthe.rowland.org>	 <1165423635.2810.33.camel@mulgrave.il.steeleye.com>	 <4577029f./DIiz5nuoOKd82Zo%Joerg.Schilling@fokus.fraunhofer.de> <1165427946.2810.46.camel@mulgrave.il.steeleye.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53089 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937086AbWLFSjF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2006 13:39:05 -0500
In-Reply-To: <1165427946.2810.46.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, stern@rowland.harvard.edu, schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, dgilbert@interlog.com

James Bottomley wrote:
> On Wed, 2006-12-06 at 18:49 +0100, Joerg Schilling wrote:
>> Please keep in mind: all CD/DVD burners are SCSI devices.
> 
> This is probably semantics, but nowadays, SCSI means SPI (or parallel
> SCSI).  I think you're trying to say that they're all devices that obey
> the MMC standard?  Which is true, but not really relevant.

James,
SPI is dead. Get used to it. SCSI has not meant SPI for
years. We should be in the business of disabusing people
of that idea, not reinforcing it.

If you went to www.t10.org and looked at draft documents
and the reflector you would be lucky to find any documents
or posts about SPI in the last two years.

Doug Gilbert
