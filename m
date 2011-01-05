From: DuanZhenzhong <zhenzhong.duan@oracle.com>
Subject: Re: declare MODULE_FIRMWARE in libsas
Date: Wed, 05 Jan 2011 13:27:05 +0800
Message-ID: <4D240129.5080200@oracle.com>
References: <4D22CF9F.1070005@oracle.com>	 <1294150132.4726.0.camel@mulgrave.site> <4D235CAC.5070309@garzik.org>	 <4D23E315.9060900@oracle.com> <1294202192.7879.30.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1294202192.7879.30.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley =E5=86=99=E9=81=93:
> On Wed, 2011-01-05 at 11:18 +0800, DuanZhenzhong wrote:
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
>> I was finding all requested but not exported firmware in scsi driver=
 for=20
>> generating dump initrd use.
>> In sas_scsi_host.c, request_firmware is called with "sas_addr", sas_=
addr=20
>> neither builtin nor exported. Don't sas_addr a firmware? Please corr=
ect=20
>> me. thanks
>>    =20
>
> No, it's not requesting any firmware ... it's a slight misuse of the
> firmware mechanism that allows a libsas based driver to be given a SA=
S
> address if it doesn't have an internal nsvram to store one.
>
> James
>
>
>  =20
I see, thanks

--=20
Regards
zhenzhong
