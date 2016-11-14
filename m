From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 0/2] sd: Fix a deadlock between event checking and device
 removal
Date: Mon, 14 Nov 2016 10:35:07 -0800
Message-ID: <9500e9b2-2d34-099d-aa90-d38fb3feb02e@sandisk.com>
References: <a8f0ee8f-7b40-2375-47a4-52f78af29d8d@sandisk.com>
 <1479016028.17624.16.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0049.outbound.protection.outlook.com ([104.47.41.49]:38284
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932414AbcKNSfS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Nov 2016 13:35:18 -0500
In-Reply-To: <1479016028.17624.16.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 11/12/2016 09:47 PM, James Bottomley wrote:
> On Fri, 2016-11-11 at 16:38 -0800, Bart Van Assche wrote:
>> Hello James and Martin,
>>
>> This short patch series fixes a deadlock that I ran into for the
>> first time several months ago but for which I had not yet had the
>> time to post a fix. As usual, feedback is appreciated.
>
> First question would be why do we need to push highly dm specific
> knowledge into block, like REQ_FAIL_IF_NO_PATH.  Can't we just use
> REQ_FAILFAST_X for this?
>
> Also, I don't quite understand how you've configured multipath
> underneath SCSI.  I thought dm-mp always went on top?

Hello James,

dm-multipath was running on top of SCSI in my setup which means that at 
least the patch description is wrong. Since it was some time ago that I 
ran into this deadlock, I will check first whether I can still reproduce it.

Bart.

