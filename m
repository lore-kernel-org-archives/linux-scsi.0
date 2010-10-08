From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 2/5] scsi: megaraid_sas - support devices update flag
Date: Fri, 08 Oct 2010 18:02:40 +0200
Message-ID: <4CAF40A0.5020506@redhat.com>
References: <AANLkTim3OKvhov1uCj5g6YgmOzR1rDogLmtJMTkbYq5V@mail.gmail.com> <1286490947.23573.3.camel@mulgrave.site> <4B6A08C587958942AA3002690DD4F8C30100F54C90@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C30100F54C90@cosmail02.lsi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: James Bottomley <James.Bottomley@suse.de>, bo yang <boyang1288@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>
List-Id: linux-scsi@vger.kernel.org

On 10/08/2010 03:47 PM, Yang, Bo wrote:
> James,
>
> Thanks for getting the online controller reset in.  I downloaded patc=
h 2/5 from  http://marc.info/?l=3Dlinux-scsi&m=3D128521127203199&w=3D2 =
and I can apply it without errors.
>
> Can you try it again?  otherwise I need to re-attach it.
>  =20
I've tried it (http://marc.info/?l=3Dlinux-scsi&m=3D128521127203199&w=3D=
2) and it is broken.
If you look at the end of the patche there should be 3 lines of the ori=
ginal code after=20
the last + sign.

tomash

Broken:
+	driver_remove_file(&megasas_pci_driver.driver,
 			   &driver_attr_release_date);
 	driver_remove_file(&megasas_pci_driver.driver, &driver_attr_version);
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n

Works for me:
+	driver_remove_file(&megasas_pci_driver.driver,
 			   &driver_attr_release_date);
 	driver_remove_file(&megasas_pci_driver.driver, &driver_attr_version);
 <- this line is missing in your patch
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n



> Thanks,
>
> Bo Yang   =20
>
> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@suse.de]=20
> Sent: Thursday, October 07, 2010 6:36 PM
> To: bo yang
> Cc: Yang, Bo; linux-scsi@vger.kernel.org; akpm@osdl.org; linux-kernel=
@vger.kernel.org
> Subject: Re: [PATCH 2/5] scsi: megaraid_sas - support devices update =
flag
>
> On Wed, 2010-09-22 at 22:50 -0400, bo yang wrote:
>  =20
>> Driver added the Device update flag to tell LSI application driver
>> will do the device Update.  LSI MegaRAID SAS application will check
>> this flag to decide if it is need to update the Device or not.
>>    =20
> Well, the good news is I've got the Online Controller reset update. T=
he
> bad news is that this patch now fails to apply: looks like an attachm=
ent
> problem again:
>
> Applying: megaraid_sas: support devices update flag
> fatal: corrupt patch at line 70
> Patch failed at 0001 megaraid_sas: support devices update flag
>
> James
>
>
> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=
=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=
=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=
=EF=BF=BD=EF=BF=BD"=EF=BF=BD{ay=EF=BF=BD=1D=CA=87=DA=99=EF=BF=BD,j=07=EF=
=BF=BD=EF=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BD=
z=EF=BF=BD=1E=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=0C=EF=BF=BD=EF=BF=BD=
=EF=BF=BDj:+v=EF=BF=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BDj=EF=BF=BDm=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=07=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDzZ+=EF=BF=
=BD=EF=BF=BD=DD=A2j"=EF=BF=BD=EF=BF=BD!tml=3D
