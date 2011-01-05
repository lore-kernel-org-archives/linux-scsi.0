From: DuanZhenzhong <zhenzhong.duan@oracle.com>
Subject: Re: declare MODULE_FIRMWARE in libsas
Date: Wed, 05 Jan 2011 13:28:26 +0800
Message-ID: <4D24017A.3060202@oracle.com>
References: <4D22CF9F.1070005@oracle.com> <1294150132.4726.0.camel@mulgrave.site> <4D235CAC.5070309@garzik.org> <4D23E315.9060900@oracle.com> <20110105044733.GA6256@cr0.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110105044733.GA6256@cr0.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Am=C3=A9rico Wang =E5=86=99=E9=81=93:
> On Wed, Jan 05, 2011 at 11:18:45AM +0800, DuanZhenzhong wrote:
>  =20
>> Jeff Garzik =E5=86=99=E9=81=93:
>>    =20
>>> On 01/04/2011 09:08 AM, James Bottomley wrote:
>>>      =20
>>>> On Tue, 2011-01-04 at 15:43 +0800, DuanZhenzhong wrote:
>>>>        =20
>>>>> Signed-off-by: Zhenzhong Duan<zhenzhong.duan@oracle.com>
>>>>>
>>>>> ---
>>>>>          =20
>>>> Description?  Since libsas has no firmware, surely some explanatio=
n is
>>>> required.
>>>>        =20
>>> Indeed.  Looks bogus at first glance?
>>>
>>>
>>>      =20
>> I was finding all requested but not exported firmware in scsi driver
>> for generating dump initrd use.
>> In sas_scsi_host.c, request_firmware is called with "sas_addr",
>> sas_addr neither builtin nor exported. Don't sas_addr a firmware?
>> Please correct me. thanks
>>
>>    =20
>
> But once you export it, it needs to be found in fireware/ directory..=
=2E
>  =20
Not exactly, firmware/ dir only have a subset of all needed firmware.=20
Also one can load firmware manually from anywhere

--=20
Regards
zhenzhong
