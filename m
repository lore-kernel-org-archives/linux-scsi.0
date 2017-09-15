From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH V3 05/12] scsi: sd_zbc: Fix comments and indentation
Date: Sat, 16 Sep 2017 07:48:44 +0900
Message-ID: <e1d986ca-80f9-725f-5b51-b788f52c582b@wdc.com>
References: <20170915100645.17999-1-damien.lemoal@wdc.com>
 <20170915100645.17999-6-damien.lemoal@wdc.com>
 <fc5f811e-423a-3cf9-4f96-63acae37264d@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:49692 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750871AbdIOWth (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2017 18:49:37 -0400
In-Reply-To: <fc5f811e-423a-3cf9-4f96-63acae37264d@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

On 9/15/17 19:44, Hannes Reinecke wrote:
> On 09/15/2017 12:06 PM, Damien Le Moal wrote:
>> Fix comments style (do not use documented comment style) and add some
>> comments to clarify some functions. Also fix some functions signature
>> indentation and remove a useless blank line in sd_zbc_read_zones().
>>
>> No functional change is introduced by this patch.
>>
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
>> ---
>>  drivers/scsi/scsi_lib.c |  5 +++-
>>  drivers/scsi/sd_zbc.c   | 67 ++++++++++++++++++++++++++++++++++++-------------
>>  2 files changed, 53 insertions(+), 19 deletions(-)
>>
> Actually you should've used kernel-doc style to format the comments;
> just to keep the 0-day bot happy....

I thought that comments to functions with the kernel-doc format was only
if you want the function to be documented. That generally includes at
least all the exported functions.
In this case, the functions are mostly local to sd_zbc.c... I thought
the documentation of those was not very useful.

I can revert though. No problem at all.

Thanks !

-- 
Damien Le Moal
Western Digital Research
