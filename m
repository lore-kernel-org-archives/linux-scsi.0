From: Rob Herring <robh@kernel.org>
Subject: =?UTF-8?B?UmU6IOetlOWkjTogW1BBVENIIHY5IDIvNV0gZHQtYmluZGluZ3M6IHNjc2k6IHVmczogYQ==?=
        =?UTF-8?B?ZGQgZG9jdW1lbnQgZm9yIGhpc2ktdWZz?=
Date: Wed, 16 May 2018 08:16:14 -0500
Message-ID: <CAL_JsqLf_r=NHHP2ZNEJOoLORXztF1KnU+tq-+COt4CPMLAsiA@mail.gmail.com>
References: <20180417140814.38098-1-liwei213@huawei.com> <20180417140814.38098-3-liwei213@huawei.com>
 <20180424125827.k2dgeu6uon75wzni@rob-hp-laptop> <1699CE87DE933F49876AD744B5DC140FA5AC86@DGGEMM506-MBS.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1699CE87DE933F49876AD744B5DC140FA5AC86@DGGEMM506-MBS.china.huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "liwei (CM)" <liwei213@huawei.com>
Cc: "mark.rutland@arm.com" <mark.rutland@arm.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "khilman@baylibre.com" <khilman@baylibre.com>, "arnd@arndb.de" <arnd@arndb.de>, "gregory.clement@free-electrons.com" <gregory.clement@free-electrons.com>, "thomas.petazzoni@free-electrons.com" <thomas.petazzoni@free-electrons.com>, "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>, "riku.voipio@linaro.org" <riku.voipio@linaro.org>, "treding@nvidia.com" <treding@nvidia.com>, "krzk@kernel.org" <krzk@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 24, 2018 at 8:54 AM, liwei (CM) <liwei213@huawei.com> wrote:
> Hi, Rob
>
> Thanks for your patience.
>
> Hi, Arnd
>
> From Rob's suggestion, we have to list the properties node in ufs-hisi.tx=
t bingings even if documented in the common binding.
>
> -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> =E5=8F=91=E4=BB=B6=E4=BA=BA: Rob Herring [mailto:robh@kernel.org]
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2018=E5=B9=B44=E6=9C=8824=E6=97=A5 =
20:58
> =E6=94=B6=E4=BB=B6=E4=BA=BA: liwei (CM)
> =E6=8A=84=E9=80=81: mark.rutland@arm.com; catalin.marinas@arm.com; will.d=
eacon@arm.com; vinholikatti@gmail.com; jejb@linux.vnet.ibm.com; martin.pete=
rsen@oracle.com; khilman@baylibre.com; arnd@arndb.de; gregory.clement@free-=
electrons.com; thomas.petazzoni@free-electrons.com; yamada.masahiro@socione=
xt.com; riku.voipio@linaro.org; treding@nvidia.com; krzk@kernel.org; device=
tree@vger.kernel.org; linux-kernel@vger.kernel.org; linux-arm-kernel@lists.=
infradead.org; linux-scsi@vger.kernel.org; zangleigang; Gengjianfeng; guodo=
ng.xu@linaro.org
> =E4=B8=BB=E9=A2=98: Re: [PATCH v9 2/5] dt-bindings: scsi: ufs: add docume=
nt for hisi-ufs
>
> On Tue, Apr 17, 2018 at 10:08:11PM +0800, Li Wei wrote:
>> add ufs node document for Hisilicon.
>>
>> Signed-off-by: Li Wei <liwei213@huawei.com>
>> ---
>>  Documentation/devicetree/bindings/ufs/ufs-hisi.txt | 29 +++++++++++++++=
+++++++
>>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      | 10 +++++---
>>  2 files changed, 36 insertions(+), 3 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/ufs/ufs-hisi.txt
>>
>> diff --git a/Documentation/devicetree/bindings/ufs/ufs-hisi.txt b/Docume=
ntation/devicetree/bindings/ufs/ufs-hisi.txt
>> new file mode 100644
>> index 000000000000..d49ab7d8f31d
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
>> @@ -0,0 +1,29 @@
>> +* Hisilicon Universal Flash Storage (UFS) Host Controller
>> +
>> +UFS nodes are defined to describe on-chip UFS hardware macro.
>> +Each UFS Host Controller should have its own node.
>> +
>> +Required properties:
>> +- compatible        : compatible list, contains one of the following -
>> +                                     "hisilicon,hi3660-ufs", "jedec,ufs=
-1.1" for hisi ufs
>> +                                     host controller present on Hi36xx =
chipset.
>> +- reg               : should contain UFS register address space & UFS S=
YS CTRL register address,
>> +- interrupt-parent  : interrupt device
>> +- interrupts        : interrupt number
>> +- resets            : reset node register, the "arst" corresponds to re=
set the APB/AXI bus.
>
> arst belongs in reset-names.
>
> OK, I will fix it in next patch;
>
>> +- reset-names       : describe reset node register
>
> What happened to clocks? You still have to list which ones apply even if
> documented in the common binding.
>
> OK, I will fix it in next patch;
>
>> +
>> +Example:
>> +
>> +     ufs: ufs@ff3b0000 {
>> +             compatible =3D "hisilicon,hi3660-ufs", "jedec,ufs-1.1";
>> +             /* 0: HCI standard */
>> +             /* 1: UFS SYS CTRL */
>> +             reg =3D <0x0 0xff3b0000 0x0 0x1000>,
>> +                     <0x0 0xff3b1000 0x0 0x1000>;
>> +             interrupt-parent =3D <&gic>;
>> +             interrupts =3D <GIC_SPI 278 IRQ_TYPE_LEVEL_HIGH>;
>> +             /* offset: 0x84; bit: 7  */
>> +             resets =3D <&crg_rst 0x84 7>;
>> +             reset-names =3D "arst";
>> +     };
>> diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/D=
ocumentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> index c39dfef76a18..adcfb79f63f5 100644
>> --- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> +++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> @@ -41,6 +41,8 @@ Optional properties:
>>  -lanes-per-direction : number of lanes available per direction - either=
 1 or 2.
>>                         Note that it is assume same number of lanes is u=
sed both
>>                         directions at once. If not specified, default is=
 2 lanes per direction.
>> +- resets            : reset node register, the "rst" corresponds to res=
et the whole UFS IP.
>> +- reset-names       : describe reset node register
>
> Does your controller have 1 or 2 resets? There's no point in adding this
> here if it doesn't apply to your controller.
>
> There are 2 reset in our soc init, the "rst" corresponds to reset the who=
le UFS IP, and " arst " only reset the APB/AXI bus.
> Discussed with our soc colleagues that "arst" is assert by default and ne=
eds to deassert,but it done in bootloader,so will remove 'arst' in next pat=
ch.
>
> About the 'reset' property=EF=BC=8Cit seems that Arnd Bergmann has differ=
ent suggestion=EF=BC=8Che suggested that add 'rst' to ufshcd-pltfrm because=
 it seems common.
> But it looks like only our soc init needs it. What's your opinion? Does i=
t still needs add to common bindings?

For a single reset, then I'm fine with it being in the common
bindings. If there are multiple then it should be in the specific
bindings as the reset names are likely different.

Rob
