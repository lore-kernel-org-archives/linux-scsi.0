From: James Smart <james.smart@avagotech.com>
Subject: Re: [PATCH kernel] commit 4fbdf9cb ("lpfc: Fix for lun discovery
 issue with saturn adapter.")
Date: Wed, 20 May 2015 15:51:57 -0400
Message-ID: <555CE5DD.5030901@avagotech.com>
References: <1430209582-23925-1-git-send-email-aik@ozlabs.ru>	<5548E2C1.3070209@emulex.com> <20150505234659.00003ab7@localhost> <555C0595.9060507@ozlabs.ru> <555C8800.6060609@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:33269 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbbETTwB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 May 2015 15:52:01 -0400
Received: by qcblr10 with SMTP id lr10so28331846qcb.0
        for <linux-scsi@vger.kernel.org>; Wed, 20 May 2015 12:52:00 -0700 (PDT)
In-Reply-To: <555C8800.6060609@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexey Kardashevskiy <aik@ozlabs.ru>, Sebastian Herbszt <herbszt@gmx.de>
Cc: linuxppc-dev@lists.ozlabs.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, "James E . J . Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Smart <james.smart@avagotech.com>

Alexey,

Can you send me boot messages so I can see everything the lpfc driver 
may have done ?
And you're using 10.5.0.0 verbatim ?

-- james


On 5/20/2015 9:11 AM, James Smart wrote:
> Not sure - I'll go look.
>
> -- james
>
>
> On 5/19/2015 11:55 PM, Alexey Kardashevskiy wrote:
>> On 05/06/2015 07:46 AM, Sebastian Herbszt wrote:
>>> James Smart wrote:
>>>>
>>>> Reviewed-By: James Smart <james.smart@emulex.com>
>>>>
>>>>
>>>> Alexey, Sebastian,
>>>>
>>>> Yes - this section needs to be reverted.  This patch is good.
>>>>
>>>> -- james s
>>>
>>> Reviewed-by: Sebastian Herbszt <herbszt@gmx.de>
>>
>>
>> Unfortunately, just this revert is not enough, it fixed one of my 
>> machines but I have another machine with "Emulex Corporation 
>> Saturn-X: LightPulse Fibre Channel Host Adapter (rev 03)" which does 
>> not boot - the booting process stops at "[  OK  ] Reached target 
>> Basic System."
>>
>> Any quick idea what else to revert between 4.0 and current upstream 
>> before I dig further? Thanks!
>>
>>
>>
>

