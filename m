From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3 2/5] scsi: Export blacklist flags to sysfs
Date: Tue, 15 Aug 2017 16:40:11 +0200
Message-ID: <b9248f72-1278-b02c-6835-39d505673c1f@suse.de>
References: <1502461401-94630-1-git-send-email-hare@suse.de>
 <1502461401-94630-3-git-send-email-hare@suse.de>
 <1502807056.2900.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37585 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751665AbdHOO6f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Aug 2017 10:58:35 -0400
In-Reply-To: <1502807056.2900.1.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>

On 08/15/2017 04:24 PM, Bart Van Assche wrote:
> On Fri, 2017-08-11 at 16:23 +0200, Hannes Reinecke wrote:
>> @@ -1138,6 +1220,7 @@ static umode_t scsi_sdev_bin_attr_is_visible(struct kobject *kobj,
>>  	&dev_attr_queue_depth.attr,
>>  	&dev_attr_queue_type.attr,
>>  	&dev_attr_wwid.attr,
>> +	&dev_attr_blacklist.attr,
>>  #ifdef CONFIG_SCSI_DH
>>  	&dev_attr_dh_state.attr,
>>  	&dev_attr_access_state.attr,
> 
> Hello Hannes,
> 
> Wouldn't debugfs be more appropriate for this attribute than sysfs?
> 
I so don't mind.
I just need it somewhere in sysfs/debugfs so that I can validate the
selection logic.

Same goes for hexvalue vs decoded output; I just need to attribute;
contents can be discussed.

Martin?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
