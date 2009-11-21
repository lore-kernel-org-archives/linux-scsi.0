From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH] libata: add TRIM support
Date: Fri, 20 Nov 2009 23:33:59 -0500
Message-ID: <4B076DB7.3040303@rtr.ca>
References: <20091116154343.GA6672@infradead.org>	<4B02AD86.8010304@rtr.ca>	<20091117143507.GC588@infradead.org>	<20091117145239.768072c9@lxorguk.ukuu.org.uk>	<20091117150012.GA10748@infradead.org>	<4B04BD01.5090706@rtr.ca>	<20091119102346.3c656b99@lxorguk.ukuu.org.uk>	<4B0554A2.9060404@rtr.ca>	<4B05DE00.3020707@gmail.com>	<20091120001829.354abfc0@lxorguk.ukuu.org.uk>	<4B05E3D1.1000904@pobox.com> <20091120124624.63ac0b9a@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:45880 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbZKUEd5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2009 23:33:57 -0500
In-Reply-To: <20091120124624.63ac0b9a@lxorguk.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jgarzik@pobox.com>, Robert Hancock <hancockrwd@gmail.com>, Christoph Hellwig <hch@infradead.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@mkp.net>, Matthew Wilcox <willy@wil.cx>

Alan Cox wrote:
>>> For those that pee themselves you don't need a host flag, you need a
>>> qc_issue hook - you need that hook for the purpose of actually making the
>>> command work, so in the short term making it just return AC_ERR_DEV isn't
>>> exactly hard. Not having the flag and fixing those odd few drivers would
>>> be far more productive.
>> We are talking about chips whose command set is essentially fixed at 
>> manufacture time.
> 
> There are only two of those I know of
> - IT821x which already uses qc_issue to filter.
> - pata_st412, which uses qc_issue and isn't in tree anyway and probably
>   never will be.
..

The sata_mv driver will choke the chipset if the TRIM command
involves more than one sector of TRIM data.

Cheers
