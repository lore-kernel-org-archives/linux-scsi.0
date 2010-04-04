From: Josua Dietze <digidietze-Pw1IEfbnKvGTBPm/0KVrCA@public.gmane.org>
Subject: Re: Add US_FL_NO_ULD_ATTACH usb mass storage unusal dev flag ?
Date: Sun, 04 Apr 2010 20:56:28 +0200
Message-ID: <4BB8E0DC.8090606@draisberghof.de>
References: <4BB8A7BF.6090908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BB8A7BF.6090908-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-usb <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hans de Goede schrieb:

> But one of the variants (usb id 1908:1320) still hits a usb-reset
> when drivers/scsi/sr.c does a READ_CAPACITY from get_sector_size().
> After the initial READ_CAPACITY failure and the usb reset, the
> second READ_CAPACITY succeeds.


Did you try to set the AVOID_RESET_QUIRK attribute? This was
originally targeted at those mode-switching devices, but might be
useful in this case too.


Josua Dietze

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
