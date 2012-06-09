From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH v2 3/4] usb: storage: update usb devices for write cache
 quirk in quirk list.
Date: Sat, 9 Jun 2012 21:08:43 +0900
Message-ID: <CAKYAXd8NYdBu4-uyuW5k3Z2yFUqFg1+bQ_TT__3LU9+WL4hBjA@mail.gmail.com>
References: <1339211540-10315-1-git-send-email-linkinjeon@gmail.com>
	<4FD3305E.1040803@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38516 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab2FIMIr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jun 2012 08:08:47 -0400
In-Reply-To: <4FD3305E.1040803@mvista.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: James.Bottomley@hansenpartnership.com, gregkh@linuxfoundation.org, mdharm-usb@one-eyed-alien.net, stern@rowland.harvard.edu, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>, Pankaj Kumar <pankaj.km@samsung.com>, Amit Sahrawat <a.sahrawat@samsung.com>

2012/6/9, Sergei Shtylyov <sshtylyov@mvista.com>:
> Hello.
>
> On 09-06-2012 7:12, Namjae Jeon wrote:
>
>> Update information of Segate Portable HDD and WD My Passport HDD in
>> quirk list.
>
>> Signed-off-by: Namjae Jeon<namjae.jeon@samsung.com>
>> Signed-off-by: Pankaj Kumar<pankaj.km@samsung.com>
>> Signed-off-by: Amit Sahrawat<a.sahrawat@samsung.com>
>> ---
>>   drivers/usb/storage/unusual_devs.h |   10 ++++++++++
>>   1 file changed, 10 insertions(+)
>
>> diff --git a/drivers/usb/storage/unusual_devs.h
>> b/drivers/usb/storage/unusual_devs.h
>> index 1719886..1d895f4 100644
>> --- a/drivers/usb/storage/unusual_devs.h
>> +++ b/drivers/usb/storage/unusual_devs.h
>> @@ -2025,6 +2025,16 @@ UNUSUAL_DEV( 0xed10, 0x7636, 0x0001, 0x0001,
>>   		"Digital MP3 Audio Player",
>>   		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_NOT_LOCKABLE ),
>>
>> +UNUSUAL_DEV(0x1058, 0x070A, 0x0000, 0x9999,
>> +		"Westron Digital",
>
>     Maybe "Western"? :-)
Right. Thanks. I wil resend the patch after fixing.
>
>> +		"My Passport HDD",
>> +		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_WRITE_CACHE),
>
> WBR, Sergei
>
