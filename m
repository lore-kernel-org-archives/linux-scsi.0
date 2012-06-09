From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH v2 3/4] usb: storage: update usb devices for write cache
 quirk in quirk list.
Date: Sat, 9 Jun 2012 12:52:46 -0400
Message-ID: <CAKYAXd-UEz03dEvNj3TGexOFL4TXzW+AEbGB3iiz0boCZzvGsA@mail.gmail.com>
References: <1339243754-2150-1-git-send-email-linkinjeon@gmail.com>
	<Pine.LNX.4.44L0.1206091131040.11334-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1206091131040.11334-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James.Bottomley@hansenpartnership.com, gregkh@linuxfoundation.org, mdharm-usb@one-eyed-alien.net, sshtylyov@mvista.com, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>, Pankaj Kumar <pankaj.km@samsung.com>, Amit Sahrawat <a.sahrawat@samsung.com>
List-Id: linux-scsi@vger.kernel.org

2012/6/9 Alan Stern <stern@rowland.harvard.edu>:
> On Sat, 9 Jun 2012, Namjae Jeon wrote:
>
>> Update information of Segate Portable HDD and WD My Passport HDD in
>> quirk list.
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
>> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
>> ---
>> =C2=A0drivers/usb/storage/unusual_devs.h | =C2=A0 10 ++++++++++
>> =C2=A01 file changed, 10 insertions(+)
>>
>> diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storag=
e/unusual_devs.h
>> index 1719886..1d895f4 100644
>> --- a/drivers/usb/storage/unusual_devs.h
>> +++ b/drivers/usb/storage/unusual_devs.h
>> @@ -2025,6 +2025,16 @@ UNUSUAL_DEV( 0xed10, 0x7636, 0x0001, 0x0001,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Digital MP3 Audio =
Player",
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 USB_SC_DEVICE, USB_=
PR_DEVICE, NULL, US_FL_NOT_LOCKABLE ),
>>
>> +UNUSUAL_DEV(0x1058, 0x070A, 0x0000, 0x9999,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Western Digital",
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "My Passport HDD",
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 USB_SC_DEVICE, USB_PR_DE=
VICE, NULL, US_FL_WRITE_CACHE),
>> +
>> +UNUSUAL_DEV(0x0BC2, 0x2300, 0x0000, 0x9999,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Seagate",
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Portable HDD",
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 USB_SC_DEVICE, USB_PR_DE=
VICE, NULL, US_FL_WRITE_CACHE),
>> +
>
> Entries must be sorted by Vendor ID and then Product ID. =C2=A0Please=
 put
> your new entries in the correct spot.
Okay, I will resend th patch after moving code.
Thanks.
>
> Alan Stern
>
