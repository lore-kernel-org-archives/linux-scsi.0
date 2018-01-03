From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2.2] sd: Micro-optimize READ / WRITE CDB encoding
Date: Wed, 3 Jan 2018 16:27:17 -0500
Message-ID: <412b3828-7da9-ac4e-bf58-de7bdad96ab9@interlog.com>
References: <20171026050603.14856-1-dgilbert@interlog.com>
 <yq11slqifmo.fsf@oracle.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:55176 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750912AbeACV1X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Jan 2018 16:27:23 -0500
In-Reply-To: <yq11slqifmo.fsf@oracle.com>
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Bart.VanAssche@wdc.com, jejb@linux.vnet.ibm.com, hch@lst.de, hare@suse.com, jthumshirn@suse.de

On 2017-10-26 02:31 AM, Martin K. Petersen wrote:
> 
> Doug,
> 
>> The sd_setup_read_write_cmnd() function is on the "fast path" for
>> block system access to SCSI devices (logical units). Rewrite this
>> function to improve speed and readability.
> 
> Please do any optimizations on top of my scsi-work branch which has the
> sd_setup_read_write_cmnd() rewrite. I'm at kernel summit this week but
> will rebase when time permits.

The most recent patch I can see on sd.c and specifically the function
sd_setup_read_write_cmnd() is May last year. Until it gets rebased
it is not useful for building further patches on.

Doug Gilbert
