From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH 2/2] lpfc: support nvmet_fc defer_rcv callback
Date: Wed, 2 Aug 2017 07:32:36 -0700
Message-ID: <fe17a99f-ad17-53ba-7c25-79e4c4545c14@gmail.com>
References: <20170801221240.31723-1-jsmart2021@gmail.com>
 <20170801221240.31723-3-jsmart2021@gmail.com>
 <20170802083220.GE4256@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33384 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751067AbdHBOcj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2017 10:32:39 -0400
Received: by mail-pg0-f66.google.com with SMTP id u185so6678699pgb.0
        for <linux-scsi@vger.kernel.org>; Wed, 02 Aug 2017 07:32:39 -0700 (PDT)
In-Reply-To: <20170802083220.GE4256@linux-x5ow.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-nvme@lists.infradead.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 8/2/2017 1:32 AM, Johannes Thumshirn wrote:
>>   		len += snprintf(buf+len, PAGE_SIZE-len,
>> -				"FCP: Rcv %08x Release %08x Drop %08x\n",
>> +				"FCP: Rcv %08x Defer %08x Release %08x "
>> +				"Drop %08x\n",
> 
> Please don't split the string across lines, it makes grepping hard.
> Checkpatch actually warns you about that.

The indentation and length of the string exceeds the 80 chararacters. so 
has to be split.  lpfc is littered with this in the debug path. It'll be 
one of the things we address in the efct refactoring. For now, this 
style has been grandfathered in.

-- james
