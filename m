From: Jonas Schwertfeger <jschwertfeger@gmail.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Fri, 2 Apr 2010 14:40:34 +0200
Message-ID: <m2l59ca64281004020540z7e502130g22dfc035f1ceda6a@mail.gmail.com>
References: <4BB37454.8070808@interlog.com> <Pine.LNX.4.44L0.1003311229460.1739-100000@iolanthe.rowland.org>
	<n2r59ca64281004010632h9dec0e98pdc0bc9a923b43206@mail.gmail.com>
	<s2zac3eb2511004010642ic2e8f973h2e038d3c90c6ca75@mail.gmail.com>
	<r2k59ca64281004010655z93fedfa8rdeb447d82a848d9f@mail.gmail.com>
	<k2zac3eb2511004010705he844fff8wfa8e18626b8f3e45@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55859 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab0DBMk5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Apr 2010 08:40:57 -0400
In-Reply-To: <k2zac3eb2511004010705he844fff8wfa8e18626b8f3e45@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Douglas Gilbert <dgilbert@interlog.com>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>

On Thu, Apr 1, 2010 at 4:05 PM, Kay Sievers <kay.sievers@vrfy.org> wrot=
e:
>> Since the drive doesn't even show up as a block device when connecte=
d
>> to the USB 3.0 port I can't run that command for the device directly=
=2E
>
> That means it does not show up, or it disappears after something is
> trying to do something with it. If it does not appear at all, we don'=
t
> need to look in userspace, I guess. :)

I assume it is there for a very brief moment but then disappears.

> What are your rules trying to do with hdparm on the drive, that seems
> rather odd to apply to a USB device:
> =A0RUN '/lib/udev/hdparm' /lib/udev/rules.d/85-hdparm.rules:2

Why would you think so? From the hdparm man page:

"Many newer (2008 and later) USB drive enclosures now also support
"SAT" (SCSI-ATA Command Translation) and therefore may also  work
with  hdparm."

-Jonas
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
