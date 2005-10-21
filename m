From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Thu, 20 Oct 2005 22:16:47 -0400
Message-ID: <43584F8F.4070403@pobox.com>
References: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com> <4358497E.6070107@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:37297 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S964843AbVJUCRA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 22:17:00 -0400
In-Reply-To: <4358497E.6070107@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, Luben Tuikov <luben_tuikov@adaptec.com>, Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> Just a suggestion if you want to bring /dev/sg into
> the picture for a SMP (and even a STP) passthrough.

Yep.  That's another possibility, that falls into the 'block driver' 
category [see list of categories in my 'ioctl' email], since it is 
translated into a 'special' block request, and then sent to a normal 
request_queue.

Jens Axboe's bsg[1] has also been mentioned in the context of SMP.

	Jeff


[1] http://lwn.net/Articles/96547/

