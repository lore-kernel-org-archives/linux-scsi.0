From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH 6/9] scsi: Improve scsi_get_sense_info_fld
Date: Mon, 24 Apr 2017 08:59:12 +0900
Message-ID: <e00e7dc3-5ff9-25c9-9e3c-0ad5183631e1@wdc.com>
References: <20170421091649.25287-1-damien.lemoal@wdc.com>
 <20170421091649.25287-7-damien.lemoal@wdc.com>
 <1492793923.2550.9.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:42666 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163580AbdDWX7a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Apr 2017 19:59:30 -0400
In-Reply-To: <1492793923.2550.9.camel@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>

Bart,

On 4/22/17 01:58, Bart Van Assche wrote:
> On Fri, 2017-04-21 at 18:16 +0900, damien.lemoal@wdc.com wrote:
>> @@ -2363,42 +2365,32 @@ EXPORT_SYMBOL(scsi_command_normalize_sense);
>>   * Return value:
>>   *   1 if information field found, 0 if not found.
>>   */
>> -int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
>> -                         u64 * info_out)
>> +bool scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
>> +                          u64 * info_out)
> 
> Hello Damien,
> 
> If you have to repost this patch please address the checkpatch complaints
> of the following category triggered by the above declaration:
> 
> ERROR: "foo * bar" should be "foo *bar"
> 
> Otherwise this patch looks fine to me. Hence:
> 
> Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>

OK. Will do.

-- 
Damien Le Moal,
Western Digital
