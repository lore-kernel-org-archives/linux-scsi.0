From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH 7/9] sd_zbc: Rename sd_zbc_setup_write_cmnd
Date: Mon, 24 Apr 2017 09:00:26 +0900
Message-ID: <fcfa160f-46ae-904c-d390-c6fd4ac8bee8@wdc.com>
References: <20170421091649.25287-1-damien.lemoal@wdc.com>
 <20170421091649.25287-8-damien.lemoal@wdc.com>
 <1492794436.2550.13.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:15493 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163580AbdDXAAc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Apr 2017 20:00:32 -0400
In-Reply-To: <1492794436.2550.13.camel@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>

Bart,

On 4/22/17 02:07, Bart Van Assche wrote:
> On Fri, 2017-04-21 at 18:16 +0900, damien.lemoal@wdc.com wrote:
>> Rename sd_zbc_setup_write_cmnd() to sd_zbc_write_lock_zone() to be
>> clear about what the function actually does. To be consistent, also
>> rename sd_zbc_cancel_write_cmnd() to sd_zbc_write_unlock_zone().
>> 
>> [ ... ]
>>        /*
>> -      * resid is optional but mostly filled in.  When it's unused,
>> +      * resid is optional but mostly filled in. When it's unused,
>>         * its value is zero, so we assume the whole buffer transferred
>>         */
> 
> Is this whitespace-only change useful? Otherwise this patch looks fine
> to me. Hence:
> 
> Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>

Ooops... No it is not. I will resend a v2.
Thanks.


-- 
Damien Le Moal,
Western Digital
