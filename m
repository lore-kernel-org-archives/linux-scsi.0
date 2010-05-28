From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 6/7] scsi: megaraid_sas - Add three times Online controller
 reset - V2
Date: Fri, 28 May 2010 15:31:12 +0200
Message-ID: <4BFFC5A0.5030302@redhat.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C35C6861A5@cosmail02.lsi.com>	 <3A916D859199814BBB666188F96EB165013979165E@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C3CDB80B82@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C3CDB80C32@cosmail02.lsi.com>	 <4BFBF814.5040202@redhat.com> <1274808736.5300.133.camel@mulgrave.site> <4BFD42B4.90207@redhat.com> <4B6A08C587958942AA3002690DD4F8C3D06ADE3F@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3D06ADE3F@cosmail02.lsi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: James Bottomley <James.Bottomley@suse.de>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>
List-Id: linux-scsi@vger.kernel.org

On 05/26/2010 11:08 PM, Yang, Bo wrote:
> Tomas/James,
>
>  =20
>> Also descriptive subjects would be nice (parts I-III may do well for
>> Lord of the Rings ... it's less useful for SCSI patches).
>>  =20
>> This is again a question for the original author. Bo?
>>    =20
> I changed the description and resubmit them already.
>  =20
Thanks Bo. I've noticed=20
[PATCH 1/7] scsi: megaraid_sas - Online Controller Reset - I: Change th=
e Chips related functions and Add the Chip reset functions
[PATCH 2/7] scsi: megaraid_sas - Online controller Reset Support (OCR)-=
II : Driver return RESET in timeout routine

do you want for the part III to stay with the subject 'Online controlle=
r Reset'?


What is more important for me is that in Patch 1/7 you still have space=
s instead=20
of tabs and the patch can't be applied. The same for patch 3/7.=20
You can see the spaces for example here http://www.spinics.net/lists/li=
nux-scsi/msg43842.html

Tomas


> Bo Yang
>
>
>
> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]=20
> Sent: Wednesday, May 26, 2010 11:48 AM
> To: James Bottomley
> Cc: Yang, Bo; 'linux-scsi@vger.kernel.org'; 'akpm@osdl.org'; 'linux-k=
ernel@vger.kernel.org'; Daftardar, Jayant
> Subject: Re: [PATCH 6/7] scsi: megaraid_sas - Add three times Online =
controller reset - V2
>
> On 05/25/2010 07:32 PM, James Bottomley wrote:
>  =20
>> On Tue, 2010-05-25 at 18:17 +0200, Tomas Henzl wrote:
>>  =20
>>    =20
>>> V2: I've cleaned up some coding style issues and removed a variable=
, the functionality shouldn't be changed
>>>
>>> Tomas
>>>
>>> If fw didn't raise the interrupt with the fw state change to driver=
 and fw goes to failure state, driver
>>> Will check the FW state in driver's timeout routine and issue the r=
eset if need.  Driver will do the OCR upto three
>>> Times until kill adapter.  Also driver will issue OCR before driver=
 kill adapter even if fw in operational state.  =20
>>>    =20
>>>      =20
>> So there's supposed to be a replacement for 3/7 (megaraid_sas - Onli=
ne
>> COntroller Reset (OCR) PART-III) as well, isn't there?
>>  =20
>>    =20
> Yes, I think there are some issues that could be removed, on the othe=
r side
> it is mostly coding style related, so I think it could be accepted as=
 it is.
> I hope I could afterwards clean something up. (The patches as they ar=
e now don't
> apply correctly on my system, it's maybe an issue with my mail reader=
=2E)
> =20
>
>  =20
>> Also descriptive subjects would be nice (parts I-III may do well for
>> Lord of the Rings ... it's less useful for SCSI patches).
>>  =20
>>    =20
> This is again a question for the original author. Bo?
>
> Tomas
>
>
>  =20
>> James
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>  =20
>>    =20
> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=
=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=
=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=
=EF=BF=BD=EF=BF=BD"=EF=BF=BD{ay=EF=BF=BD=1D=CA=87=DA=99=EF=BF=BD,j=07=EF=
=BF=BD=EF=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BD=
z=EF=BF=BD=1E=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=0C=EF=BF=BD=EF=BF=BD=
=EF=BF=BDj:+v=EF=BF=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BDj=EF=BF=BDm=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=07=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDzZ+=EF=BF=
=BD=EF=BF=BD=DD=A2j"=EF=BF=BD=EF=BF=BD!tml=3D
