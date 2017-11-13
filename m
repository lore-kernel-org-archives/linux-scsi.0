From: Andrey Astafyev <1@246060.ru>
Subject: Re: [PATCH] uas: Add US_FL_NO_ATA_1X quirk for one more Seagate
 device
Date: Mon, 13 Nov 2017 07:01:30 +0300
Message-ID: <46d6dde9-e811-9655-96db-a046de521782@246060.ru>
References: <20171110151344.10563-1-hdegoede@redhat.com>
 <20171112164234.48b5185c@Vantage.cJ>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171112164234.48b5185c-WI5o+PA4G9BYumZHjSPV5A@public.gmane.org>
Content-Language: ru-RU
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?B?SsOpcsO0bWUgQ2FycmV0ZXJv?= <cJ-ko-WRw03QTAyf3sq35pWSNszA@public.gmane.org>
Cc: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

13.11.2017 00:42, Jérôme Carretero пишет:
> Nov 12 16:20:59 Bidule kernel: sd 22:0:0:0: [sdaa] tag#2 
> uas_eh_abort_handler 0 uas-tag 3 inflight: CMD OUT
> 	Nov 12 16:20:59 Bidule kernel: sd 22:0:0:0: [sdaa] tag#2 CDB: Write(16) 8a 00 00 00 00 00 20 00 08 00 00 00 00 08 00 00
> 	Nov 12 16:20:59 Bidule kernel: sd 22:0:0:0: [sdaa] tag#1 uas_eh_abort_handler 0 uas-tag 2 inflight: CMD OUT
> 	Nov 12 16:20:59 Bidule kernel: sd 22:0:0:0: [sdaa] tag#1 CDB: Write(16) 8a 00 00 00 00 00 00 02 08 00 00 00 00 08 00 00
> 	Nov 12 16:21:29 Bidule kernel: sd 22:0:0:0: [sdaa] tag#0 uas_eh_abort_handler 0 uas-tag 1 inflight: CMD
> 	Nov 12 16:21:29 Bidule kernel: sd 22:0:0:0: [sdaa] tag#0 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
> 	Nov 12 16:21:29 Bidule kernel: scsi host22: uas_eh_device_reset_handler start
> 	Nov 12 16:21:29 Bidule kernel: usb 6-4.3.2.1: reset SuperSpeed USB device number 9 using xhci_hcd
> 	Nov 12 16:21:29 Bidule kernel: scsi host22: uas_eh_device_reset_handler success
>
>
> Do you see such things?
>
Hi, I've seen dmesg output like this so I've added my device to quirks 
list like any other Seagate USB drive.

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
