From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: Add support for injecting
 SCSI_MLQUEUE_HOST_BUSY
Date: Thu, 7 Dec 2017 21:46:36 -0500
Message-ID: <a6f0f8be-772b-c736-e036-97ee067e4495@interlog.com>
References: <20171207225618.3116-1-bart.vanassche@wdc.com>
 <yq18teevug0.fsf@oracle.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:44486 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752105AbdLHCqp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Dec 2017 21:46:45 -0500
In-Reply-To: <yq18teevug0.fsf@oracle.com>
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@wdc.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 2017-12-07 09:12 PM, Martin K. Petersen wrote:
> 
> Bart,
> 
>> Although it is important to be able to trigger the code in the SCSI
>> core for SCSI_MLQUEUE_HOST_BUSY handling, currently it is nontrivial
>> to trigger that code. Hence this patch that adds a new error injection
>> option to the scsi_debug driver for making the .queue_rq()
>> implementation of this driver return SCSI_MLQUEUE_HOST_BUSY.
> 
> This looks good to me. Doug?

Acked-by: Douglas Gilbert <dgilbert@interlog.com>
