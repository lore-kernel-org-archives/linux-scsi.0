From: loody <miloody-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: dummy scsi read or scsi command periodically for external USB
 Hard Disk
Date: Tue, 8 Jul 2014 22:58:02 +0800
Message-ID: <CANudz+uRd3tRfPN-Fqcj5sSW-xkRSN-gERBP7HhUY_s5gEALbg@mail.gmail.com>
References: <CANudz+vS1t3wWbEU6UGGKP=bb3KEvFcpmX=M2+ZnC8bxY_tPjQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1407071258360.871-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1407071258360.871-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: "Bryn M. Reeves" <bmr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

hi Alan:

2014-07-08 1:02 GMT+08:00 Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>:
> On Tue, 8 Jul 2014, loody wrote:
>
>> > An alternative is to write a positive value, such as 240000, to
>> >
>> >         /sys/block/sdX/events_poll_msecs
>> >
>> > where X is replaced with the proper drive letter.  (240000 ms = 240 s =
>> > 4 m.)  I'm not sure this will work, but it's worth a try.
>>
>> I cannot find events_poll_msecs you mentioned in my system.
>> Is this capability related to kernel version?
>> ( my kernel version is 2.6.38.8 )
>
> Well, the in-kernel disk events mechanism was added in 2.6.38, but it
> may not have been implemented for your type of drive.
You are correct.
i can see events_poll_msecs when I change my kernel to 3.8.0
But the device still disconnect.
I have some question.
1. when I cat  /sys/block/sdX/events, I get the answer as media_change.
    is there any events type we can choose, such as read capability or inquiry.
>
> Probably you don't actually need to do a read.  Simply opening the
> device file ought to be sufficient.
2. the open device you mean is like open(/dev/sda1)?

thanks for all your kind help,



-- 
Regards,
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
