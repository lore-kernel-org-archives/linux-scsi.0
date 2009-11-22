From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH] libata: add TRIM support
Date: Sat, 21 Nov 2009 21:39:54 -0500
Message-ID: <4B08A47A.3030001@rtr.ca>
References: <20091116154343.GA6672@infradead.org> <4B02AD86.8010304@rtr.ca>	<20091117143507.GC588@infradead.org>	<20091117145239.768072c9@lxorguk.ukuu.org.uk>	<20091117150012.GA10748@infradead.org> <4B04BD01.5090706@rtr.ca>	<20091119102346.3c656b99@lxorguk.ukuu.org.uk>	<4B0554A2.9060404@rtr.ca> <4B05DE00.3020707@gmail.com>	<20091120001829.354abfc0@lxorguk.ukuu.org.uk>	<4B05E3D1.1000904@pobox.com>	<20091120124624.63ac0b9a@lxorguk.ukuu.org.uk>	<4B076DB7.3040303@rtr.ca> <yq1einss91u.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <yq1einss91u.fsf@sermon.lab.mkp.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jgarzik@pobox.com>, Robert Hancock <hancockrwd@gmail.com>, Christoph Hellwig <hch@infradead.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Matthew Wilcox <willy@wil.cx>
List-Id: linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
> Mark> The sata_mv driver will choke the chipset if the TRIM command
> Mark> involves more than one sector of TRIM data.
> 
> We never issue more than a single sector.
..

Today.

:)

