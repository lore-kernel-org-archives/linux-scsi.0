From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] scsi/sata write barrier support
Date: Thu, 27 Jan 2005 18:00:41 -0500
Message-ID: <41F97299.2070909@pobox.com>
References: <200501272242.j0RMgoP5016154@falcon30.maxeymade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:39398 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261262AbVA0XBQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Jan 2005 18:01:16 -0500
In-Reply-To: <200501272242.j0RMgoP5016154@falcon30.maxeymade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@maxeymade.com>, Jens Axboe <axboe@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>, linux-scsi@vger.kernel.org

Doug Maxey wrote:
> On Thu, 27 Jan 2005 13:02:48 +0100, Jens Axboe wrote:
> 
>>Hi,
>>
>>For the longest time, only the old PATA drivers supported barrier writes
>>with journalled file systems. This patch adds support for the same type
>>of cache flushing barriers that PATA uses for SCSI, to be utilized with
>>libata. 
> 
> 
> What, if any mechanism supports changing the underlying write cache?  
> 
> That is, assuming this is common across PATA and SCSI drives, and it is 
> possible to turn the cache off on the IDE drives, would switching the 
> cache underneath require completing the inflight IO?

[ignoring your question, but it made me think...]


I am thinking the barrier support should know if the write cache is 
disabled (some datacenters do this), and avoid flushing if so?

	Jeff


