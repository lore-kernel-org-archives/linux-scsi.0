From: Jonas Schwertfeger <jschwertfeger@gmail.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Tue, 30 Mar 2010 09:44:51 +0200
Message-ID: <59ca64281003300044g53ae5170xaf198bf99964fc36@mail.gmail.com>
References: <Pine.LNX.4.44L0.1003261705340.23253-100000@netrider.rowland.org>
	<4BAD275A.7050903@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57180 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab0C3HpO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2010 03:45:14 -0400
In-Reply-To: <4BAD275A.7050903@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Alan Stern <stern@rowland.harvard.edu>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org

On Fri, Mar 26, 2010 at 11:30 PM, Douglas Gilbert <dgilbert@interlog.co=
m> wrote:
>> Booting into a minimal userspace environment (for example, with
>> init=3D/bin/bash) might prove this.
>>
>> No doubt the reason the drive fails to respond is because it can't h=
andle
>> these commands and gets fatally confused.
>
> The ATA commands seem to be:
> =A0 IDENTIFY DEVICE =A0(via the ATA_12 tunnel)
> =A0 SET FEATURES =A0 =A0 (via the ATA_16 tunnel)
> =A0 IDENTIFY DEVICE =A0(via the ATA_16 tunnel)
>
> The last one fails but that could be caused by
> the second last one. Doesn't look like smartd.
> My money would be on udev.

Doug was right. I switched into runlevel 1 and connected the drive.
Same errors as before. Then, I unplugged it, stopped the udev daemon
and plugged it back in. Voila, I was able to manually mount the drive
with no issues.

Where do we go from here? Does anyone know how to debug udev?

-Jonas
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
