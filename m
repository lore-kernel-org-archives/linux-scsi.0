From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH] scsi: pm8001: build in relevant functions and code on PM8001_USE_MSIX
Date: Thu, 23 Mar 2017 10:17:46 +0100
Message-ID: <CAMGffEm6cvJ121K9ME6Tgk_uYSRJQgMq=bvKyYzKuQZP=sNwow@mail.gmail.com>
References: <20170322185004.1012-1-colin.king@canonical.com> <58D3889B.7030400@bfs.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <58D3889B.7030400@bfs.de>
Sender: kernel-janitors-owner@vger.kernel.org
To: wharms@bfs.de
Cc: Colin King <colin.king@canonical.com>, lindar_liu <lindar_liu@usish.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, pmchba@pmcs.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 23, 2017 at 9:34 AM, walter harms <wharms@bfs.de> wrote:

>> @@ -4613,15 +4616,15 @@ static int pm8001_chip_phy_ctl_req(struct pm8001=
_hba_info *pm8001_ha,
>>
>>  static u32 pm8001_chip_is_our_interupt(struct pm8001_hba_info *pm8001_h=
a)
>>  {
>> -     u32 value;
>>  #ifdef PM8001_USE_MSIX
>>       return 1;
>> -#endif
>> -     value =3D pm8001_cr32(pm8001_ha, 0, MSGU_ODR);
>> +#else
>> +     u32 value =3D pm8001_cr32(pm8001_ha, 0, MSGU_ODR);
>> +
>>       if (value)
>>               return 1;
>>       return 0;
>> -
>> +#endif
>>  }
>>
>
> This is a bit strange, why do this function return u32 ?
>
> re,
>  wh
>
>>  /**

Hi Walter,

Feel free to submit a patch to change it to bool.

Thanks

--=20
Jinpu Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss
