From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 6/9] block: Add 'zoned' sysfs queue attribute
Date: Fri, 15 Apr 2016 11:42:19 -0700
Message-ID: <5711360B.90309@sandisk.com>
References: <1459764020-126038-1-git-send-email-hare@suse.de>
 <1459764020-126038-7-git-send-email-hare@suse.de>
 <571128C7.1060107@sandisk.com> <57112CDE.2080303@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0082.outbound.protection.outlook.com ([157.56.110.82]:42816
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751108AbcDOSmY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2016 14:42:24 -0400
In-Reply-To: <57112CDE.2080303@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>

On 04/15/2016 11:03 AM, Hannes Reinecke wrote:
> On 04/15/2016 07:45 PM, Bart Van Assche wrote:
>> Additionally, have you considered to create one sysfs directory per zone
>> instead of one sysfs attribute with all zone information? From
>> Documentation/filesystems/sysfs.txt: "Attributes should be ASCII text
>> files, preferably with only one value per file."
>
> Yes, I have considered it.
> But doing so would require me to add about 20k sysfs attributes.
> For no apparent gain.
> So I've settled on this condensed approach here.

Hello Hannes,

My understanding is that the one-value-per-file rule was introduced for 
sysfs to make it easy for software, e.g. shell scripts, to process that 
information. If multiple values occur in the same sysfs file sometimes 
complicated code is needed in shell scripts to parse these values. If 
one value is present in each sysfs file it becomes much easier for 
software to process that sysfs information.

Bart.
