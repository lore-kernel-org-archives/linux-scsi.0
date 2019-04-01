From: Jan Kotas <jank@cadence.com>
Subject: Re: [PATCH 1/2] dt-bindings: scsi: ufs-cdns: Update Cadence UFS
 compatibility list
Date: Mon, 1 Apr 2019 07:49:24 +0000
Message-ID: <BEE57023-51AA-4513-929E-00855D282DB9@global.cadence.com>
References: <20190327144405.5716-1-jank@cadence.com>
 <20190327144405.5716-2-jank@cadence.com> <20190331025745.GA28612@bogus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190331025745.GA28612@bogus>
Content-Language: en-US
Content-ID: <58C45F487B911442824B33EEA05EF36E@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robh@kernel.org>
Cc: Jan Kotas <jank@cadence.com>, Mark Rutland <mark.rutland@arm.com>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>, "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> On 31 Mar 2019, at 08:42, Rob Herring <robh@kernel.org> wrote:
>=20
> On Wed, Mar 27, 2019 at 02:44:04PM +0000, Jan Kotas wrote:
>> This patch adds a new compatible string description for
>> CDNS UFS HCD + M31 16nm PHY.
>=20
> The phy is not a separate block?=20

In this case PHY is controlled by some extra registers
in the controller's address space, accessible via its
hardware register interface.

Having an extra compatible also makes it consistent with
others controllers, which are already in the kernel.

ufs-qcom.txt:
- compatible        : compatible list, contains one of the following -
			"qcom,ufs-phy-qmp-20nm" for 20nm ufs phy,
			"qcom,ufs-phy-qmp-14nm" for legacy 14nm ufs phy,
			"qcom,msm8996-ufs-phy-qmp-14nm" for 14nm ufs phy
			 present on MSM8996 chipset.

tc-dwc-g210-pltfrm.txt:
- compatible	: compatible list must contain the PHY type & version:
			"snps,g210-tc-6.00-20bit"
			"snps,g210-tc-6.00-40bit"

Regards,
Jan

>=20
>>=20
>> Signed-off-by: Jan Kotas <jank@cadence.com>
>> ---
>> Documentation/devicetree/bindings/ufs/cdns,ufshc.txt | 5 +++--
>> 1 file changed, 3 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt b/Docu=
mentation/devicetree/bindings/ufs/cdns,ufshc.txt
>> index a04a4989e..02347b017 100644
>> --- a/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
>> +++ b/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
>> @@ -5,8 +5,9 @@ Each UFS controller instance should have its own node.
>> Please see the ufshcd-pltfrm.txt for a list of all available properties.
>>=20
>> Required properties:
>> -- compatible	: Compatible list, contains the following controller:
>> -			"cdns,ufshc"
>> +- compatible	: Compatible list, contains one of the following controlle=
rs:
>> +			"cdns,ufshc" - Generic CDNS HCI,
>> +			"cdns,ufshc-m31-16nm" - CDNS UFS HC + M31 16nm PHY
>> 		  complemented with the JEDEC version:
>> 			"jedec,ufs-2.0"
>>=20
>> --=20
>> 2.15.0
>>=20
>=20
