From: ojab <ojab@ojab.ru>
Subject: Re: [PATCH V2] mpt3sas: disable ASPM for MPI2 controllers
Date: Mon, 16 Jan 2017 22:43:56 +0000
Message-ID: <44e649a7-850a-e083-eed8-7b40e8f6b300@ojab.ru>
References: <20161228110524.7516-1-ojab@ojab.ru> <yq17f69hs1l.fsf@oracle.com>
 <CAK=zhgoocwB_01KT8UjtNXwTwcBQ86zWwMB3R4pjW3STy-7iyg@mail.gmail.com>
 <188a6990-6f10-839f-2846-cc8ae0b2e740@ojab.ru>
 <CAK=zhgo=ZB==pCLYjfM_7V55080Wp86ufgOeL0D0DK+6osN2ow@mail.gmail.com>
 <ee6c5a9c-6875-52e7-cce9-069bad30c732@ojab.ru>
 <CAK=zhgqM_b7=wG3zgBb=wxOwLknYyimZiX+TfsrX3=T1EuOnsw@mail.gmail.com>
 <16f1d8a1-12c1-25b9-6b33-85ef203ab4e3@ojab.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34686 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750990AbdAPWoB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jan 2017 17:44:01 -0500
Received: by mail-lf0-f67.google.com with SMTP id q89so14258956lfi.1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2017 14:43:59 -0800 (PST)
In-Reply-To: <16f1d8a1-12c1-25b9-6b33-85ef203ab4e3@ojab.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2017/01/16 14:03, ojab wrote:
> On 2017/01/16 13:31, Sreekanth Reddy wrote:
>> On Mon, Jan 16, 2017 at 6:15 PM, ojab <ojab@ojab.ru> wrote:
>>> On 2017/01/16 12:36, Sreekanth Reddy wrote:
>>>>
>>>> Ojab,
>>>>
>>>> I am checking internally with our FW team and Architect to known
>>>> whether they aware/observed any issues similar to this (since this
>>>> issue is nothing to do with driver).
>>>>
>>>> Meanwhile is it possible to provide us the PCI config space and FW
>>>> logs when issue occurs?
>>>
>>>
>>> AFAIU FW log is enabled when `logging_level=0x3f8` is passed to the
>>> module,
>>> right?
>>
>> This is a driver logging_level. Firmware logs can be collected using
>> UART logs.
>
> According to the user guide (from
> https://www.broadcom.com/products/storage/host-bus-adapters/sas-9217-8i#documentation)
> my 9217-8i requires 1.8V UART which I don't have at hand, I'll try to do
> something on the weekend.
> Is anything needed except connecting UART to gather required info?
…actually I have compatible USB UART here. What should be done to get FW 
log? I've tried to reboot with UART connected (9600N1) but got no output.

//wbr ojab


>
> Anyway, right now various MPI2 HBAs doesn't work with ASPM enabled, so
> can this patch be applied in the meantime while we're debugging the
> issue further? Even if this issue can be properly fixed by FW update,
> this workaround will be needed for HBAs with affected FW versions.
>
> //wbr ojab
>
>
>>
>>> Where can I find info about PCI config space?
>>
>> You can get PCI config space info from lspci command.
>>
>>>
>>> //wbr ojab
>>>>
>>>>
>>>> Thanks,
>>>> Sreekanth
>>>>
>>>> On Mon, Jan 16, 2017 at 5:37 PM, ojab <ojab@ojab.ru> wrote:
>>>>>
>>>>> On 2017/01/06 15:48, Sreekanth Reddy wrote:
>>>>>>
>>>>>>
>>>>>> On Fri, Jan 6, 2017 at 7:24 AM, Martin K. Petersen
>>>>>> <martin.petersen@oracle.com> wrote:
>>>>>>
>>>>>> Matin, We need some time to review this patch. I will provide my
>>>>>> review comments by end of next week.
>>>>>>
>>>>> ping?
>>>>>
>>>>> //wbr ojab
>>>>>>
>>>>>>
>>>>>> Thanks,
>>>>>> Sreekanth
>>>>>
>>>>>
>>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-scsi" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

