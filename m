From: Chunwei Chen <tuxoko@gmail.com>
Subject: Re: [uas/3.16.1] panic in uas_data_cmplt()
Date: Tue, 02 Sep 2014 20:15:34 +0800
Message-ID: <5405B4E6.1040908@gmail.com>
References: <54054509.2070609@gmail.com> <540568A3.4010106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <540568A3.4010106@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On =E8=A5=BF=E5=85=832014=E5=B9=B409=E6=9C=8802=E6=97=A5 14:50, Hans de=
 Goede wrote:
> Hi,
>=20
> On 09/02/2014 06:18 AM, Chunwei Chen wrote:
>> Dear all:
>>
>> The kernel version is 3.16.1-1-ARCH
>>
>> Today I keep getting this panic when booting up.
>> http://i.imgur.com/0Rx93Kr.jpg
>>
>> It might be that the UAS device was in some strange state,
>> because that after I unplugged and power-cycled the UAS,
>> everything went normal again.
>>
>> Does anyone know what's the root cause of this issue?
>> Or could anyone provide some instruction on how to debug this issue?
>=20
> There seem to be some issues in the error handling paths of the uas
> driver. I plan to rewrite them completely for robustness and go
> through them with a fine comb to fix any possible bugs while at it.
>=20
> I'll send out a mail when I've a new version ready for testing.
>=20
> Regards,
>=20
> Hans
>=20

Hi Hans,

Thanks for looking into this.

Kind regards,
Chunwei
