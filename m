From: Daniel Walker <danielwa@cisco.com>
Subject: Re: [PATCH] sd: assign appropriate log level
Date: Mon, 17 Oct 2016 10:22:55 -0700
Message-ID: <5c5e37b1-0058-c1eb-8a4c-c493c7493fd6@cisco.com>
References: <20161017165108.29718-4-davsingl@cisco.com>
 <1476724750.2734.20.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-1.cisco.com ([173.37.142.88]:19770 "EHLO
        alln-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933168AbcJQRce (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2016 13:32:34 -0400
In-Reply-To: <1476724750.2734.20.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, David Singleton <davsingl@cisco.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Shikhar Dogra <shidogra@cisco.com>, xe-kernel@external.cisco.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 10/17/2016 10:19 AM, James Bottomley wrote:
> On Mon, 2016-10-17 at 09:51 -0700, David Singleton wrote:
>> From: Shikhar Dogra <shidogra@cisco.com>
>>
>> Reduce chatter on console for usb hotplug.
>> KERN_ERR is too high severity for these messages, moving them
>> to KERN_WARNING
> It's an error because we have several USB to IDE bridges that have
> write back cache drives but report nothing to the caching mode page.
>   For them this is a serious error because their data integrity is at
> risk.  I'm open to other ways to fix your problem, but downgrading the
> message severity because *you* don't have an issue would mask the
> problem for others, so it's not really viable.

Is there a way to detect when you have a device of the type where this 
is a serious issue ? This typically happen for USB drives, but seems to 
have no effect on them.


Daniel
