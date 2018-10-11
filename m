From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mptfusion: Remove unnecessary parentheses and simplify null checks
Date: Wed, 10 Oct 2018 22:14:58 -0400
Message-ID: <yq1o9c12pr1.fsf@oracle.com>
References: <20180915063645.31295-1-natechancellor@gmail.com>
        <CAK8P3a3PaWgieA0_HBJJ-FVeBO+iAdN8_kv5YUbpKURJ3gsoaQ@mail.gmail.com>
        <20181002150704.GA444@flashbox>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181002150704.GA444@flashbox> (Nathan Chancellor's message of
        "Tue, 2 Oct 2018 08:07:04 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-scsi@vger.kernel.org


Nathan,

>> The exact same code also exists in drivers/scsi/mpt3sas/. I had a similar
>> patch for both drivers, but saw that yours now got merged for fusion.
>> 
>> If you don't mind, could you fix mpt3sas_base.c the same way?
>> 
>>      Arnd
>
> Hi Arnd,
>
> I did sent a patch for this a little bit later:
> https://lore.kernel.org/lkml/20180920201002.23979-1-natechancellor@gmail.com/
>
> I am still waiting for it to be merged.

I generally don't merge patches for drivers that are actively maintained
unless the driver maintainer explicitly acks the change. However, this
was trivial enough. Applied to 4.20/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
