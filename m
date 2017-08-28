From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 17/30] scsi: Define usercopy region in scsi_sense_cache
 slab cache
Date: Mon, 28 Aug 2017 14:52:10 -0700
Message-ID: <CAGXu5jKuuJ9o0rJWExknajKBNTsnfmsJAmhK4jq5v+VTRZo9gQ@mail.gmail.com>
References: <1503956111-36652-1-git-send-email-keescook@chromium.org>
 <1503956111-36652-18-git-send-email-keescook@chromium.org> <1503956551.2841.70.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503956551.2841.70.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "dave@nullcore.net" <dave@nullcore.net>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 28, 2017 at 2:42 PM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Mon, 2017-08-28 at 14:34 -0700, Kees Cook wrote:
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index f6097b89d5d3..f1c6bd56dd5b 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -77,14 +77,15 @@ int scsi_init_sense_cache(struct Scsi_Host *shost)
>>       if (shost->unchecked_isa_dma) {
>>               scsi_sense_isadma_cache =
>>                       kmem_cache_create("scsi_sense_cache(DMA)",
>> -                     SCSI_SENSE_BUFFERSIZE, 0,
>> -                     SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA, NULL);
>> +                             SCSI_SENSE_BUFFERSIZE, 0,
>> +                             SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA, NULL);
>>               if (!scsi_sense_isadma_cache)
>>                       ret = -ENOMEM;
>
> All this part of this patch does is to change source code indentation. Should
> these changes really be included in this patch?

I can certainly drop that hunk, but the existing alignment is really
ugly. :) Happy to do whatever.

-Kees

-- 
Kees Cook
Pixel Security
