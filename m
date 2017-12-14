From: Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH] scsi: check for device state in __scsi_remove_target()
Date: Thu, 14 Dec 2017 16:05:39 +0800
Message-ID: <5A3230D3.2060302@huawei.com>
References: <1513171297-58020-1-git-send-email-hare@suse.de>
 <1513203795.2413.14.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:53733 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750722AbdLNIGT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Dec 2017 03:06:19 -0500
In-Reply-To: <1513203795.2413.14.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>


On 2017/12/14 6:23, Bart Van Assche wrote:
> On Wed, 2017-12-13 at 14:21 +0100, Hannes Reinecke wrote:
>> As it turned out device_get() doesn't use kref_get_unless_zero(),
>> so we will be always getting a device pointer.
>> So we need to check for the device state in __scsi_remove_target()
>> to avoid tripping over deleted objects.
>>
>> Fixes: fbce4d9 ("scsi: fixup kernel warning during rmmod()")
>
> How about adding Reported-by: Jason Yan? See also
> https://www.spinics.net/lists/linux-scsi/msg115295.html
>
> Anyway:
>
> Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
>

Seems the same as my patch.So how do we plan to fix this issue,
pick this approach up or the approach James Bottomley suggested?
I have sent a patch to change get_device() but Greg seems do not
like this way.
