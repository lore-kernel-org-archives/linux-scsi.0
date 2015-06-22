From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH 09/20] [SCSI] mpt3sas: MPI 2.5 Rev J (2.5.5) specification
 and 2.00.34 header files
Date: Mon, 22 Jun 2015 17:48:04 +0530
Message-ID: <CAK=zhgqADi5jT_vQYh6_LLygK=RyD18Y8v-6K+6njRvVqLPDSw@mail.gmail.com>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1434102153-38581-10-git-send-email-Sreekanth.Reddy@avagotech.com>
	<yq1egl7bg04.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:34157 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442AbbFVMSG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2015 08:18:06 -0400
Received: by wgqq4 with SMTP id q4so14758414wgq.1
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2015 05:18:05 -0700 (PDT)
In-Reply-To: <yq1egl7bg04.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Sat, Jun 20, 2015 at 1:57 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:
>
>> @@ -1334,9 +1336,17 @@ typedef struct _MPI2_CONFIG_PAGE_BIOS_1 {
>>       *PTR_MPI2_CONFIG_PAGE_BIOS_1,
>>       Mpi2BiosPage1_t, *pMpi2BiosPage1_t;
>>
>> -#define MPI2_BIOSPAGE1_PAGEVERSION                      (0x05)
>> +#define MPI2_BIOSPAGE1_PAGEVERSION                      (0x06)
>>
>>  /*values for BIOS Page 1 BiosOptions field */
>> +#define MPI2_BIOSPAGE1_OPTIONS_X86_DISABLE_BIOS                  (0x00000400)
>
> Looks like you may have some bad whitespace here ^^^.

Accepted. will post next version of this patch by removing these extra
white spaces.

Thanks,
Sreekanth

>
>> +
>> +#define MPI2_BIOSPAGE1_OPTIONS_MASK_REGISTRATION_UEFI_BSD    (0x00000300)
>> +#define MPI2_BIOSPAGE1_OPTIONS_USE_BIT0_REGISTRATION_UEFI_BSD        (0x00000000)
>> +#define MPI2_BIOSPAGE1_OPTIONS_FULL_REGISTRATION_UEFI_BSD    (0x00000100)
>> +#define MPI2_BIOSPAGE1_OPTIONS_ADAPTER_REGISTRATION_UEFI_BSD (0x00000200)
>> +#define MPI2_BIOSPAGE1_OPTIONS_DISABLE_REGISTRATION_UEFI_BSD (0x00000300)
>
> Otherwise OK.
>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
>
> --
> Martin K. Petersen      Oracle Linux Engineering



-- 

Regards,
Sreekanth
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
