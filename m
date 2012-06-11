From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH v3 3/3] usb: storage: update usb devices for write cache
 quirk in quirk list.
Date: Tue, 12 Jun 2012 07:47:41 +0900
Message-ID: <CAKYAXd_79Rk3f4ft5yH_uSiKOD+gTsQr4UX-by964nEQgxhkRA@mail.gmail.com>
References: <1339263678-4075-1-git-send-email-linkinjeon@gmail.com>
	<4FD39998.4020903@mvista.com>
	<CAKYAXd9Evpo6jn+_+bnyNeaX9vmPicVp5Xm-12tp_U4=wb6Pgw@mail.gmail.com>
	<4FD62653.7060206@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4FD62653.7060206@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: James.Bottomley@hansenpartnership.com, gregkh@linuxfoundation.org, mdharm-usb@one-eyed-alien.net, stern@rowland.harvard.edu, bvanassche@acm.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>, Pankaj Kumar <pankaj.km@samsung.com>, Amit Sahrawat <a.sahrawat@samsung.com>
List-Id: linux-scsi@vger.kernel.org

2012/6/12, Sergei Shtylyov <sshtylyov@mvista.com>:
> Hello.
>
> On 10-06-2012 4:45, Namjae Jeon wrote:
>
>>>> Update information of Seagate Portable HDD and WD My Passport HDD in
>>>> quirk list.
>
>>>> Signed-off-by: Namjae Jeon<namjae.jeon@samsung.com>
>>>> Signed-off-by: Pankaj Kumar<pankaj.km@samsung.com>
>>>> Signed-off-by: Amit Sahrawat<a.sahrawat@samsung.com>
>>>> ---
>>>>    drivers/usb/storage/unusual_devs.h |   24 ++++++++++++++++++++++++
>>>>    1 file changed, 24 insertions(+)
>
>>>> diff --git a/drivers/usb/storage/unusual_devs.h
>>>> b/drivers/usb/storage/unusual_devs.h
>>>> index 1719886..64f0369 100644
>>>> --- a/drivers/usb/storage/unusual_devs.h
>>>> +++ b/drivers/usb/storage/unusual_devs.h
>>>> @@ -1267,6 +1267,18 @@ UNUSUAL_DEV( 0x0af0, 0xd357, 0x0000, 0x0000,
>>>>    		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>>>>    		0 ),
>>>>
>>>> +/* Reported by Namjae Jeon<namjae.jeon@samsung.com>
>>>> + * Even though write cache is enabled by default,
>>>> + * SCSI driver assume that cache is not enabled
>>>> + * which in turn might lead loss of data
>>>                                 ^ to the
>
>>>> + * since data still will be in cache.
>>>> + * So this entry is needed for assuming that cache is enabled.
>>>> + */
>>>> +UNUSUAL_DEV(0x0bc2, 0x2300, 0x0000, 0x9999,
>>>> +		"Seagate",
>>>> +		"Portable HDD",
>>>> +		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_WRITE_CACHE),
>>>> +
>>>>    /* Reported by Ben Efros<ben@pc-doctor.com>   */
>>>>    UNUSUAL_DEV( 0x0bc2, 0x3010, 0x0000, 0x0000,
>>>>    		"Seagate",
>>>> @@ -1468,6 +1480,18 @@ UNUSUAL_DEV(  0x1058, 0x0704, 0x0000, 0x9999,
>>>>    		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>>>>    		US_FL_SANE_SENSE),
>>>>
>>>> +/* Reported by Namjae Jeon<namjae.jeon@samsung.com>
>>>> + * Even though write cache is enabled by default,
>>>> + * SCSI driver assume that cache is not enabled
>>>> + * which in turn might lead loss of data
>>>                                 ^ to the
>> to the ? Sorry, I don't understand what you want to change.
>> like this ? "Even though write cache is enabled by default, SCSI
>> driver assume that cache is not enabled and it in turn might lead the
>> loss of data. "
>
>     Lead to the loss of data.
Okay, I changed it on the latest patch.
Thanks a lot.
>
> WBR, Sergei
>
