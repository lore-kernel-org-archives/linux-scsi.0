From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: cciss update [2/2] fixes for Steeleye Lifekeeper
Date: 18 Oct 2004 14:45:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098128731.2011.296.camel@mulgrave>
References: <20041013212253.GB9866@beardog.cca.cpqcorp.net>
	<20041014083900.GB7747@infradead.org> <1097764660.2198.11.camel@mulgrave>
	<20041014183948.GA12325@infradead.org> <1097852716.1718.9.camel@mulgrave>
	<20041018163532.GA24511@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:46474 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267708AbUJRTpz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2004 15:45:55 -0400
In-Reply-To: <20041018163532.GA24511@beardog.cca.cpqcorp.net>
List-Id: linux-scsi@vger.kernel.org
To: mikem <mikem@beardog.cca.cpqcorp.net>
Cc: Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>, Jens Axboe <axboe@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-10-18 at 11:35, mikem wrote:
> This patch only registers the controller if no logical drives are configured. It will not result in all possible logical drives being added. I added printk's to the driver to show me what I'm registering.
> What I see is the controller registers every time, and only drives that are phsically configured are registered. That is true for reserved drives, also.

It also looks like this device is always the one used when the array
comes on line, so it's only a shadow for as long as the actual array has
none of it's storage configured.  OK.

The code also seems to imply that we use a single block queue for all of
the array devices ... isn't that a bit inefficient?

James




