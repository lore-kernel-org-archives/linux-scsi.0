From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] scsi: mpt3sas: Add missing breaks in switch statements
Date: Thu, 28 Feb 2019 14:03:42 -0600
Message-ID: <0e5dded0-6219-5a4d-e99c-d3eedcb0afae@embeddedor.com>
References: <20190215215414.GA10944@embeddedor> <yq1lg219u1i.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1lg219u1i.fsf@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-scsi@vger.kernel.org



On 2/27/19 8:37 AM, Martin K. Petersen wrote:
> 
> Gustavo,
> 
>> Fix the following warnings by adding the proper missing breaks:
>>
>> drivers/scsi/mpt3sas/mpt3sas_base.c: In function ‘_base_display_OEMs_branding’:
>> drivers/scsi/mpt3sas/mpt3sas_base.c:3548:4: warning: this statement may fall thr
> 
> Applied to 5.1/scsi-queue, thanks.
> 

Thank you, Martin.

There many patches in this series:

https://lore.kernel.org/patchwork/project/lkml/list/?series=374317

that never were acked/reviewed even after I have
pinged twice.

I wonder if you could apply them.

Thanks
--
Gustavo
