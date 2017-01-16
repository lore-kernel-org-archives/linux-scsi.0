From: ojab <ojab@ojab.ru>
Subject: Re: [PATCH V2] mpt3sas: disable ASPM for MPI2 controllers
Date: Mon, 16 Jan 2017 12:45:34 +0000
Message-ID: <ee6c5a9c-6875-52e7-cce9-069bad30c732@ojab.ru>
References: <20161228110524.7516-1-ojab@ojab.ru> <yq17f69hs1l.fsf@oracle.com>
 <CAK=zhgoocwB_01KT8UjtNXwTwcBQ86zWwMB3R4pjW3STy-7iyg@mail.gmail.com>
 <188a6990-6f10-839f-2846-cc8ae0b2e740@ojab.ru>
 <CAK=zhgo=ZB==pCLYjfM_7V55080Wp86ufgOeL0D0DK+6osN2ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36668 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750998AbdAPMpj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jan 2017 07:45:39 -0500
Received: by mail-lf0-f65.google.com with SMTP id h65so12436258lfi.3
        for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2017 04:45:37 -0800 (PST)
In-Reply-To: <CAK=zhgo=ZB==pCLYjfM_7V55080Wp86ufgOeL0D0DK+6osN2ow@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2017/01/16 12:36, Sreekanth Reddy wrote:
> Ojab,
>
> I am checking internally with our FW team and Architect to known
> whether they aware/observed any issues similar to this (since this
> issue is nothing to do with driver).
>
> Meanwhile is it possible to provide us the PCI config space and FW
> logs when issue occurs?

AFAIU FW log is enabled when `logging_level=0x3f8` is passed to the 
module, right?
Where can I find info about PCI config space?

//wbr ojab
>
> Thanks,
> Sreekanth
>
> On Mon, Jan 16, 2017 at 5:37 PM, ojab <ojab@ojab.ru> wrote:
>> On 2017/01/06 15:48, Sreekanth Reddy wrote:
>>>
>>> On Fri, Jan 6, 2017 at 7:24 AM, Martin K. Petersen
>>> <martin.petersen@oracle.com> wrote:
>>>
>>> Matin, We need some time to review this patch. I will provide my
>>> review comments by end of next week.
>>>
>> ping?
>>
>> //wbr ojab
>>>
>>> Thanks,
>>> Sreekanth
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

