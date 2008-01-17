From: Bill Adair <adair@gotadsl.co.uk>
Subject: Re: Forcing use of sd driver on Suse 10.3 (2.6.22)
Date: Thu, 17 Jan 2008 10:53:11 +0000
Message-ID: <1200567191.5778.6.camel@desk.ty-rhos-barn>
References: <1200308514.4729.25.camel@desk.ty-rhos-barn>
	 <478BAA8E.7020703@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:52681
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754660AbYAQKwz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jan 2008 05:52:55 -0500
In-Reply-To: <478BAA8E.7020703@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


On Mon, 2008-01-14 at 19:31 +0100, Stefan Richter wrote:
> Bill Adair wrote:
> > Is there any way under Linux of forcing use of the sd driver for a
> > device on the bus instead of sg?
> 
> The INQUIRY data which the SCSI core gets from the device have to
> indicate that the device implements SBC or RBC (is of peripheral device
> type 00h or 0Eh).
I have altered the sd.c file by patching sd_probe to check for the
particular unit I have and accepting pdt 03h (Processor) as a valid
return and the unit works fine. 

I suspect the sd file is considered very important though (and I don't
know how many of these card readers exist) so I assume a patch is not
required ;-). Would there be another approach to creating a "driver" for
my Spyrus RD300 in it's guise as a card reader?

Bill

