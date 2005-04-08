From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [OOPS] 2.6.11 - NMI lockup with CFQ scheduler
Date: Fri, 08 Apr 2005 09:04:09 -0400
Message-ID: <1112965449.5838.9.camel@mulgrave>
References: <20050406175838.GC15165@suse.de>
	 <1112811607.5555.15.camel@mulgrave> <20050406190838.GE15165@suse.de>
	 <1112821799.5850.19.camel@mulgrave> <20050407064934.GJ15165@suse.de>
	 <1112879919.5842.3.camel@mulgrave> <20050407132205.GA16517@infradead.org>
	 <1112880658.5842.10.camel@mulgrave> <20050407133222.GJ1847@suse.de>
	 <1112881183.5842.13.camel@mulgrave>  <20050407144557.GK1847@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:11702 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262808AbVDHNEW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2005 09:04:22 -0400
In-Reply-To: <20050407144557.GK1847@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Rankin <rankincj@yahoo.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2005-04-07 at 16:45 +0200, Jens Axboe wrote:
> So clear ->request_queue instead.


Will do.  Did you want me to look after your patch and add this, or do
you want to send it to Linus (after the purdah is over)?

James


