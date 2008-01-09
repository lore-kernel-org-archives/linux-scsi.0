From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Number of devices that SCSI can support
Date: Wed, 09 Jan 2008 09:05:52 -0600
Message-ID: <1199891152.3493.6.camel@localhost.localdomain>
References: <404714.86520.qm@web43145.mail.sp1.yahoo.com>
	 <20080109022233.GM16309@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35221 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751746AbYAIPF5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 10:05:57 -0500
In-Reply-To: <20080109022233.GM16309@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Vinay Venkataraghavan <raghavanvinay@yahoo.com>, linux-scsi@vger.kernel.org


On Tue, 2008-01-08 at 19:22 -0700, Matthew Wilcox wrote:
> On Tue, Jan 08, 2008 at 04:55:46PM -0800, Vinay Venkataraghavan wrote:
> > Is there a limit on the number of devices that SCSI supports. In other words, I have a QLogic HBA card, and I am connecting to a SAN which has 64 targets. 
> 
> I've personally had over five hundred LUNs.  You shouldn't be hitting a
> limit here.

I believe the largest test that's been run was the old OSDL CGL
workgroup ... they went up to 4096.

However, LUN support depends on the driver and HBA parameters as well
(some choose to have arbitrary limits).

So, firstly, if the inquiry strings appear (as in you see a scsiX:X:X:64
and above in dmesg) then I'd look at udev issues.  If the inquiry
strings don't appear, it's probably a device or driver programmed limit.

James


