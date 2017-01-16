From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH V2] mpt3sas: disable ASPM for MPI2 controllers
Date: Mon, 16 Jan 2017 19:01:41 +0530
Message-ID: <CAK=zhgqM_b7=wG3zgBb=wxOwLknYyimZiX+TfsrX3=T1EuOnsw@mail.gmail.com>
References: <20161228110524.7516-1-ojab@ojab.ru> <yq17f69hs1l.fsf@oracle.com>
 <CAK=zhgoocwB_01KT8UjtNXwTwcBQ86zWwMB3R4pjW3STy-7iyg@mail.gmail.com>
 <188a6990-6f10-839f-2846-cc8ae0b2e740@ojab.ru> <CAK=zhgo=ZB==pCLYjfM_7V55080Wp86ufgOeL0D0DK+6osN2ow@mail.gmail.com>
 <ee6c5a9c-6875-52e7-cce9-069bad30c732@ojab.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:34783 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751346AbdAPNbs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jan 2017 08:31:48 -0500
Received: by mail-qk0-f178.google.com with SMTP id a20so118965629qkc.1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2017 05:31:48 -0800 (PST)
In-Reply-To: <ee6c5a9c-6875-52e7-cce9-069bad30c732@ojab.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ojab <ojab@ojab.ru>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Jan 16, 2017 at 6:15 PM, ojab <ojab@ojab.ru> wrote:
> On 2017/01/16 12:36, Sreekanth Reddy wrote:
>>
>> Ojab,
>>
>> I am checking internally with our FW team and Architect to known
>> whether they aware/observed any issues similar to this (since this
>> issue is nothing to do with driver).
>>
>> Meanwhile is it possible to provide us the PCI config space and FW
>> logs when issue occurs?
>
>
> AFAIU FW log is enabled when `logging_level=0x3f8` is passed to the module,
> right?

This is a driver logging_level. Firmware logs can be collected using UART logs.

> Where can I find info about PCI config space?

You can get PCI config space info from lspci command.

>
> //wbr ojab
>>
>>
>> Thanks,
>> Sreekanth
>>
>> On Mon, Jan 16, 2017 at 5:37 PM, ojab <ojab@ojab.ru> wrote:
>>>
>>> On 2017/01/06 15:48, Sreekanth Reddy wrote:
>>>>
>>>>
>>>> On Fri, Jan 6, 2017 at 7:24 AM, Martin K. Petersen
>>>> <martin.petersen@oracle.com> wrote:
>>>>
>>>> Matin, We need some time to review this patch. I will provide my
>>>> review comments by end of next week.
>>>>
>>> ping?
>>>
>>> //wbr ojab
>>>>
>>>>
>>>> Thanks,
>>>> Sreekanth
>>>
>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
