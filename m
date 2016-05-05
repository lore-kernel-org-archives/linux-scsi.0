From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] Fix a bdi reregistration race, v3
Date: Thu, 5 May 2016 12:58:39 -0700
Message-ID: <572BA5EF.6000702@sandisk.com>
References: <56F9A22F.7020002@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0064.outbound.protection.outlook.com ([65.55.169.64]:22432
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755120AbcEET6r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 May 2016 15:58:47 -0400
In-Reply-To: <56F9A22F.7020002@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/28/2016 02:29 PM, Bart Van Assche wrote:
> Avoid that the sd driver registers a BDI device with a name that
> is still in use. This patch avoids that the following warning gets
> triggered:
>
> [ ... ]

(replying to my own e-mail)

If anyone could review this patch that would be very welcome.

Thanks,

Bart.

