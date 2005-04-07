From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [OOPS] 2.6.11 - NMI lockup with CFQ scheduler
Date: Thu, 07 Apr 2005 09:30:58 -0400
Message-ID: <1112880658.5842.10.camel@mulgrave>
References: <20050329115405.97559.qmail@web52909.mail.yahoo.com>
	 <20050329120311.GO16636@suse.de> <1112804840.5476.16.camel@mulgrave>
	 <20050406175838.GC15165@suse.de> <1112811607.5555.15.camel@mulgrave>
	 <20050406190838.GE15165@suse.de> <1112821799.5850.19.camel@mulgrave>
	 <20050407064934.GJ15165@suse.de> <1112879919.5842.3.camel@mulgrave>
	 <20050407132205.GA16517@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:57765 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262467AbVDGNbI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Apr 2005 09:31:08 -0400
In-Reply-To: <20050407132205.GA16517@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@suse.de>, Chris Rankin <rankincj@yahoo.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2005-04-07 at 14:22 +0100, Christoph Hellwig wrote:
> Do we really need the sdev_lock pointer?  There's just a single place
> where we're using it and the code would be much more clear if it had just
> one name.

Humour me for a while.  I don't believe we have any way the lock can be
used after calling queue free, but nulling the sdev_lock pointer will
surely catch them.  If nothing turns up after a few kernel revisions,
feel free to kill it.

James


