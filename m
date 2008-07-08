From: "Indan Zupancic" <indan@nul.nu>
Subject: Re: 2.6.27-rc7-git1: usb-storage breakage with non-functional disk
Date: Tue, 8 Jul 2008 16:28:26 +0200 (CEST)
Message-ID: <14494.84.245.32.19.1215527306.squirrel@secure.samage.net>
References: <Pine.LNX.4.44L0.0807081008230.2135-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smarthost1.greenhost.nl ([85.17.153.87]:37147 "EHLO
	smarthost1.samage.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbYGHO2j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2008 10:28:39 -0400
In-Reply-To: <Pine.LNX.4.44L0.0807081008230.2135-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB development list <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Tue, July 8, 2008 16:11, Alan Stern wrote:
> On Tue, 8 Jul 2008, Indan Zupancic wrote:
>
>> On Tue, July 8, 2008 15:00, Indan Zupancic wrote:
>> > Any idea why my cardreader doesn't work in the first place though?
>>
>> In case it's useful, an usbmon dump can be found at
>> http://pastebin.org/49630
>> This is the log of plugging in the thing and unplugging it again after it
>> failed.
>> Corresponding dmesg output with USB and usb-storage debugging enabled at
>> http://pastebin.org/49631. This is on 2.6.26-rc9 with Alan's patch applied.
>
> The logs reveal only that this doesn't seem to be a software- or
> firmware-related problem.  And it probably isn't a problem in the cable
> either, which leaves only the reader or its USB interface.

It's connected directly without cable, so good call on the no cable problem.
It looks like a big usb stick with slots for memory cards.

It's not something silly like the device saying it only needs 100mA
while in reality it needs 200mA? Or are those numbers only used to
calculate how many devices may be connected?

> It might work better at full speed than at high speed (although you
> probably don't want to use it in a degraded mode).

I have ehci built-in, how can I force full speed? Hm, in the BIOS maybe.

I'll try it with my neighbours' pc later today, if I've the chance.

Thanks,

Indan


