From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v2 2/5] dt-bindings: scsi: ufs: add document for hi3660-ufs
Date: Thu, 22 Jun 2017 14:15:54 +0200
Message-ID: <CAK8P3a1MRx5zRp5-7iDY32+6PGsyHFaOom-bkWmftpLUS=8gBA@mail.gmail.com>
References: <20170616065119.10704-1-butao@hisilicon.com> <20170616065119.10704-3-butao@hisilicon.com>
 <CAK8P3a2aPorzpUzwL=dkUkYNCGkhQMDPOkKRW1-=Hf=yCdvTsQ@mail.gmail.com>
 <0f79aeea-53e3-6bea-ffa6-0e057f2ff83b@huawei.com> <CAK8P3a2z7VbPb95Ltj=Duh1v_Yqxedb_g=ADNPWOrpEz1dCTuw@mail.gmail.com>
 <24438c4d-21c8-6302-acd4-4f0e223232ce@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <24438c4d-21c8-6302-acd4-4f0e223232ce-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bu Tao <butao-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Wei Xu <xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kevin Hilman <khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>, Gregory CLEMENT <gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Thomas Petazzoni <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, Riku Voipio <riku.voipio-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>Linux
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 22, 2017 at 1:58 PM, Bu Tao <butao-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> =E5=9C=A8 2017/6/22 19:51, Arnd Bergmann =E5=86=99=E9=81=93:
>> On Thu, Jun 22, 2017 at 1:44 PM, Bu Tao <butao-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>>> =E5=9C=A8 2017/6/17 5:51, Arnd Bergmann =E5=86=99=E9=81=93:
>>>> On Fri, Jun 16, 2017 at 8:51 AM, Bu Tao <butao-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org> wrote:
>>>
>>> I do not know wheher other SoC need to use the optional properties as
>>> abover. So here the name of the optional properties has "hi3660".
>>
>>
>> They should not have "hi3660" in their names either way, independent
>> of where they are used.
>
>
> Oh, change the "hi3660" to "hisilicon"?
> e.g. ufs-hi3660-use-rate-B  -->  ufs-hisilicon-use-rate-B

No, just 'use-rate-B', no prefix for this.

>>>> (note: this is different from the value of the "compatible" property
>>>> that
>>>> is meant to be as specific as possible".
>>>>
>>>> Also, please clarify how your binding relates to the ufshcd binding
>>>> in Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt: does
>>>> hi3660 implement any registers that are shared with ufshcd, or does
>>>> it use the same physical interface with a different register set?
>>>
>>>
>>> No, only show how to use the dt-binding for hi3660 SoC
>>
>>
>> My question was about the hardware: does hi3660 implement ufshcd
>> or not?
>
>
> YES

Ok, then the properties should be documented as optional in the
Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt file for anything
that has a proper interpretation in the context of the generic ufshcd
driver.

      Arnd
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
