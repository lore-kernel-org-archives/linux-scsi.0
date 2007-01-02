From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH 2.6.20-rc3] fix broken retval test in sr_block_ioctl
Date: Tue, 02 Jan 2007 17:39:49 -0500
Message-ID: <459ADF35.2060908@rtr.ca>
References: <200701021724.39613.liml@rtr.ca> <459ADD70.9030402@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([64.26.128.89]:4535 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965014AbXABWjr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Jan 2007 17:39:47 -0500
In-Reply-To: <459ADD70.9030402@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Tejun Heo <htejun@gmail.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Mark Lord wrote:
...
>>      ret = cdrom_ioctl(file, &cd->cdi, inode, cmd, arg);
>> -    if (ret != ENOSYS)
>> +    if (ret != -ENOSYS)
> 
> I think Tejun posted the same patch earlier today.

Ahh.. missed it -- could have saved me an hour or two of debugging!

Cheers!

