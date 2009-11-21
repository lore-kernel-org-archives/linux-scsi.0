From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] libata: add TRIM support
Date: Sat, 21 Nov 2009 01:09:49 -0500
Message-ID: <yq1einss91u.fsf@sermon.lab.mkp.net>
References: <20091116154343.GA6672@infradead.org> <4B02AD86.8010304@rtr.ca>
	<20091117143507.GC588@infradead.org>
	<20091117145239.768072c9@lxorguk.ukuu.org.uk>
	<20091117150012.GA10748@infradead.org> <4B04BD01.5090706@rtr.ca>
	<20091119102346.3c656b99@lxorguk.ukuu.org.uk>
	<4B0554A2.9060404@rtr.ca> <4B05DE00.3020707@gmail.com>
	<20091120001829.354abfc0@lxorguk.ukuu.org.uk>
	<4B05E3D1.1000904@pobox.com>
	<20091120124624.63ac0b9a@lxorguk.ukuu.org.uk>
	<4B076DB7.3040303@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:60379 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbZKUGLA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Nov 2009 01:11:00 -0500
In-Reply-To: <4B076DB7.3040303@rtr.ca> (Mark Lord's message of "Fri, 20 Nov
	2009 23:33:59 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jgarzik@pobox.com>, Robert Hancock <hancockrwd@gmail.com>, Christoph Hellwig <hch@infradead.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Matthew Wilcox <willy@wil.cx>


Mark> The sata_mv driver will choke the chipset if the TRIM command
Mark> involves more than one sector of TRIM data.

We never issue more than a single sector.

-- 
Martin K. Petersen	Oracle Linux Engineering
