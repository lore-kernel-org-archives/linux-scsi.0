From: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH v4 00/14] mpt3sas driver NVMe support:
Date: Wed, 13 Sep 2017 12:45:06 +0530
Message-ID: <CA+RiK64sJZzTcTHODHj0monB2_0xKAkvjrC79rGv2mNUPO87-A@mail.gmail.com>
References: <1503322344-5900-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <yq1lgmbauxt.fsf@oracle.com> <CA+RiK65F0CUNkc7AXN7n-rwvmf=Xm-t6dNvG134hY9yapwgDYg@mail.gmail.com>
 <yq1a82gxwqm.fsf@oracle.com> <CA+RiK67f59U5Ss_Z2=veBRODtBSp1-4VTbosLkHkgaxY9XA6hQ@mail.gmail.com>
 <yq13787w1a3.fsf@oracle.com> <CA+RiK667V9nDEr7RywED2_RoSq97m511HZTpGqPbij9-=vADvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:44296 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751316AbdIMHPH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2017 03:15:07 -0400
Received: by mail-it0-f45.google.com with SMTP id r131so2898785itc.1
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2017 00:15:07 -0700 (PDT)
In-Reply-To: <CA+RiK667V9nDEr7RywED2_RoSq97m511HZTpGqPbij9-=vADvQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Sathya Prakash <Sathya.Prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, linux-kernel@vger.kernel.org, Chaitra Basappa <chaitra.basappa@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-nvme@lists.infradead.org

Hi Martin,

Is there any update on the submitted mpt3sas patches.

Thanks,
Suganath Prabu S

On Fri, Sep 1, 2017 at 2:09 PM, Suganath Prabu Subramani
<suganath-prabu.subramani@broadcom.com> wrote:
> Hi Martin,
>
> On Fri, Sep 1, 2017 at 8:52 AM, Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
>>
>> Hi Suganath,
>>
>>> Let me explain - NVME device fast path is possible in two ways.  IEEE
>>> SGL and PRP SGL. Due to h/w constraint we choose IEEE SGL only for
>>> smaller IO size.  Both above is true h/w Fast Path and no firmware
>>> involvement.
>>
>>> Agree with you. We are planning to see if we can keep only simple Fast
>>> Path using only PRP.
>>
>> That would be great, thank you!
>>
>>> Currently there is no performance issue for UNMAP translation in FW.
>>
>> Good!
>>
>>>> And yet patch 4 circumvents that statement by adding support for
>>>> encapsulated commands to bypass the FW translation...
>>>
>>> This path is not due to performance reason. User wants to interact
>>> with NVME drive in native NVME command for management.
>>
>> Patch 4 states:
>>
>> "This encapsulated NVMe command is used by applications to send direct
>> NVMe commands to NVMe drives or for handling unmap where the translation
>> at controller/firmware level is having performance issues."
>>
>> --
>
> The statement in description of patch 4 is added by mistake, We ll
> correct the description and re sending that.
>
>> Martin K. Petersen      Oracle Linux Engineering
>
> Thanks,
> Suganath Prabu S
