From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] libata: add TRIM support
Date: Thu, 19 Nov 2009 10:23:46 +0000
Message-ID: <20091119102346.3c656b99@lxorguk.ukuu.org.uk>
References: <20091116154343.GA6672@infradead.org>
	<4B02AD86.8010304@rtr.ca>
	<20091117143507.GC588@infradead.org>
	<20091117145239.768072c9@lxorguk.ukuu.org.uk>
	<20091117150012.GA10748@infradead.org>
	<4B04BD01.5090706@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4B04BD01.5090706@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@mkp.net>, Matthew Wilcox <willy@wil.cx>
List-Id: linux-scsi@vger.kernel.org

> I imagine some sort of port or host flag, that the LLD could set
> to indicate that it can correctly handle TRIM.  Or not handle TRIM.
> 
> Tejun is pretty good at these flag things.. I wonder what he might suggest?

As I said - just error it in your driver qc_issue function. If you are
feeling really arty you can hook do_identify and mask the bit in the
ident data as well. See it821x 'smart' RAID mode for both of those in
pata_it821x.c

Alan
