From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_dh_alua: suppress errors from unsupported devices
Date: Mon, 7 Aug 2017 08:07:10 +0200
Message-ID: <990a352f-e21b-4d71-288e-9165b9ce8dd3@suse.de>
References: <1501828660-89497-1-git-send-email-hare@suse.de>
 <20170805113523.GC16313@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60264 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751795AbdHGGHN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Aug 2017 02:07:13 -0400
In-Reply-To: <20170805113523.GC16313@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 08/05/2017 01:35 PM, Christoph Hellwig wrote:
>>  	error = scsi_dh_add_device(sdev);
>> -	if (error)
>> -		/*
>> -		 * device_handler is optional, so any error can be ignored
>> -		 */
>> -		sdev_printk(KERN_INFO, sdev,
>> -				"failed to add device handler: %d\n", error);
>> +	/* device_handler is optional, so any error can be ignored */
> 
> In that case it should return void.
> 
Okay, will be updating the patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
