From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: SCSI mid layer and high IOPS capable devices
Date: Fri, 14 Dec 2012 17:15:37 +0100
Message-ID: <50CB50A9.1050202@acm.org>
References: <20121211000013.GI23107@beardog.cce.hp.com> <50C9F2B9.4050500@acm.org> <20121213172513.GH20898@beardog.cce.hp.com> <50CA0692.2010903@acm.org> <20121213164912.GA28496@infradead.org> <50CAF502.3070300@acm.org> <20121214164421.GQ20898@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:47894 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508Ab2LNQPi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Dec 2012 11:15:38 -0500
In-Reply-To: <20121214164421.GQ20898@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, dab@hp.com

On 12/14/12 17:44, scameron@beardog.cce.hp.com wrote:
> I expect the flash devices re-order requests as well, simply because
> to feed requests to the things at a sufficient rate, you have to pump
> requests into them concurrently on multiple hardware queues -- a single
> cpu jamming requests into them as fast as it can is still not fast enough
> to keep them busy.  Consequently, they *can't* care about ordering, as the
> relative order requests on different hardware queues are submitted into them
> is not even really controlled, so the OS *can't* count on concurrent requests
> not to be essentially "re-ordered", just because of the nature of the way
> requests get into the device.

Why should a flash device have to reorder write requests ? These devices 
typically use a log-structured file system internally.

Bart.

