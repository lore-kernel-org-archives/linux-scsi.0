From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] move ->eh_strategy_handler to the transport class
Date: Sat, 01 Apr 2006 15:16:52 -0500
Message-ID: <442EDFB4.4050201@garzik.org>
References: <20060401172104.GA16921@lst.de> <1143914189.3076.20.camel@laptopd505.fenrus.org> <442EDB68.2060707@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:9694 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932178AbWDAURC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Apr 2006 15:17:02 -0500
In-Reply-To: <442EDB68.2060707@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Stefan Richter wrote:
> Arjan van de Ven wrote:
>> On Sat, 2006-04-01 at 19:21 +0200, Christoph Hellwig wrote:
>>> Overriding the whole EH code is a per-transport, not per-host thing.
>>> Move ->eh_strategy_handler to the transport class, same as
>>> ->eh_timed_out.
>>
>> I like it, nice cleanup and it's fundamentally the right place to do it
> 
> BTW, why are there Scsi_Hosts in (s)ata drivers anyway instead of being 
> hidden by libata? (Think of libata---or a transport class---as a layer.)

Because they shouldn't be hidden by libata.  aic94xx hides it, which is 
the wrong layering.  Each libata driver is a first-class SCSI driver, 
where a lot of the SCSI stuff is handled by common library functions.

	Jeff


