From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: hisi_sas: select CONFIG_RAS
Date: Fri, 3 Nov 2017 11:19:50 +0100
Message-ID: <CAK8P3a3fvRQ+oUg=EUuWxdyyyMGHiL7sQMLhCY53sfCRyinOAA@mail.gmail.com>
References: <20171102165059.213216-1-arnd@arndb.de> <bdb263f7-7e1f-47ab-881b-2feeeeccfbf5@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <bdb263f7-7e1f-47ab-881b-2feeeeccfbf5@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Xiang Chen <chenxiang66@hisilicon.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>, Shiju Jose <shiju.jose@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 3, 2017 at 11:14 AM, John Garry <john.garry@huawei.com> wrote:
> + Shiju, who authored the original patch
>

>> index d42f29a5eb65..6ad8a6251d21 100644
>> --- a/drivers/scsi/hisi_sas/Kconfig
>> +++ b/drivers/scsi/hisi_sas/Kconfig
>> @@ -4,6 +4,7 @@ config SCSI_HISI_SAS
>>         depends on ARM64 || COMPILE_TEST
>>         select SCSI_SAS_LIBSAS
>>         select BLK_DEV_INTEGRITY
>> +       select RAS
>
>
> My impression is that we don't want this. Correction: shouldn't want this.
>
> Do you have the .config for the broken build? I couldn't recreate this by
> turning off CONFIG_RAS.

Uploaded to https://pastebin.com/A1rJYhDr
Maybe you were missing support for tracing in your configuration?

      Arnd
