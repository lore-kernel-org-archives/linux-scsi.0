From: Jonas Schwertfeger <jschwertfeger@gmail.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Tue, 30 Mar 2010 09:24:04 +0200
Message-ID: <59ca64281003300024m414d10eam7e0c5c8e0f0b24ab@mail.gmail.com>
References: <4BA9D74F.9040507@gmail.com> <4BA7797F.8060605@gmail.com>
	<20100324155917.GA4382@xanatos> <59ca64281003241107x40c5d83co29d1ee03d8d3a0d1@mail.gmail.com>
	<20100326184021.GA4350@xanatos> <20100329212853.GA6996@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46385 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab0C3HY0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2010 03:24:26 -0400
In-Reply-To: <20100329212853.GA6996@xanatos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org

On Mon, Mar 29, 2010 at 11:28 PM, Sarah Sharp
<sarah.a.sharp@linux.intel.com> wrote:
>> Hmm, ok, I would rather figure out why 2.6.31 is hanging, since 2.6.=
32
>> does not. =A0Can you compile the latest 2.6.31 stable tree and use
>> netconsole to capture the crash with CONFIG_USB_XHCI_HCD_DEBUGGING a=
nd
>> CONFIG_USB_STORAGE_DEBUG turned on? =A0(I assume you know how to use
>> netconsole, but if you don't, I've posted how I setup netconsole at
>> http://sarah.thesharps.us/2010-03-26-09-41)
>
> Ping? =A0Any luck reproducing the hang on 2.6.31 stable? =A0I tried w=
ith a
> different unpartitioned USB 3.0 hard drive (SIIG 2.5" drive) on
> 2.6.31.12, but I didn't find any issues.

I just compiled 2.6.31.12 and couldn't reproduce the hang. The
behavior seems the same as in 2.6.32. I have to note though, that due
to the update from Ubuntu Karmic (which used a 2.6.31 kernel) to
Ubuntu Lucid a great deal of my system changed. Specifically,
userspace programs will differ for sure. Unfortunately I don't have
another USB 3.0 host system lying around with Karmic installed.

-Jonas
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
