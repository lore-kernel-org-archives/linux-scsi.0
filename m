From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [RFC 1/2] target: Add support for fabric IRQ completion
Date: Mon, 29 Jun 2015 12:51:31 +0300
Message-ID: <55911523.2090307@dev.mellanox.co.il>
References: <1432281446-31080-1-git-send-email-nab@daterainc.com>
 <1432281446-31080-2-git-send-email-nab@daterainc.com>
 <20150609072720.GA10758@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34170 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbbF2JvS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2015 05:51:18 -0400
Received: by wicnd19 with SMTP id nd19so93842979wic.1
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2015 02:51:17 -0700 (PDT)
In-Reply-To: <20150609072720.GA10758@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

On 6/9/2015 10:27 AM, Christoph Hellwig wrote:
>> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
>> index 3fbb0d4..aa08d6b 100644
>> --- a/drivers/target/target_core_tpg.c
>> +++ b/drivers/target/target_core_tpg.c
>> @@ -37,6 +37,7 @@
>>
>>   #include <target/target_core_base.h>
>>   #include <target/target_core_backend.h>
>> +#include <target/target_core_configfs.h>
>>   #include <target/target_core_fabric.h>
>>
>>   #include "target_core_internal.h"
>
> This hunk look unrelated.

Nic, can you remove that - it breaks compilation...

Thanks,
Sagi.
