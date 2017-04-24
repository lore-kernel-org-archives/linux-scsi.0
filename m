From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH 5/9] sd: Cleanup sd_done sense data handling
Date: Mon, 24 Apr 2017 09:23:18 +0900
Message-ID: <a3193390-8b6e-9466-9edd-b63023e64735@wdc.com>
References: <20170421091649.25287-1-damien.lemoal@wdc.com>
 <20170421091649.25287-6-damien.lemoal@wdc.com>
 <1492800068.2550.25.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:63312 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163699AbdDXAXZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Apr 2017 20:23:25 -0400
In-Reply-To: <1492800068.2550.25.camel@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>

Bart,

On 4/22/17 03:41, Bart Van Assche wrote:
> On Fri, 2017-04-21 at 18:16 +0900, damien.lemoal@wdc.com wrote:
>> @@ -1884,8 +1886,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
>>                                else {
>>                                        sdkp->device->no_write_same = 1;
>>                                        sd_config_write_same(sdkp);
>> -
>> -                                     good_bytes = 0;
>>                                        req->__data_len = blk_rq_bytes(req);
>>                                        req->rq_flags |= RQF_QUIET;
>>                                }
> 
> This change looks fine to me but has not been described in the patch
> description? Anyway:
> 
> Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>

Oops. Yes, I forgot to mention that in the commit message.
(for result != 0, good_bytes is already set to 0, so that assignment is
not necessary).
Will resend.

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Research Group,
Western Digital Corporation
Damien.LeMoal@wdc.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.wdc.com, www.hgst.com
