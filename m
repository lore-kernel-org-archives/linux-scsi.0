From: Clemens Fruhwirth <clemens@endorphin.org>
Subject: Re: [PATCH] Forcing SCSI capacity for broken SD Card readers
Date: Sun, 20 Dec 2009 14:20:38 +0100
Message-ID: <2f83750a0912200520l8e16fe6vdb436e67868c8f07@mail.gmail.com>
References: <da824cf30912161038r690e0032lb047c4a667f06c50@mail.gmail.com>
	 <Pine.LNX.4.44L0.0912161438270.2909-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:46017 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155AbZLTNUm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2009 08:20:42 -0500
In-Reply-To: <Pine.LNX.4.44L0.0912161438270.2909-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Grant Grundler <grundler@google.com>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Wed, Dec 16, 2009 at 8:43 PM, Alan Stern <stern@rowland.harvard.edu>=
 wrote:

> Isn't just changing a block device's size at random times a bad thing
> to do? =C2=A0The size gets used a for a bunch of different things (ch=
ecking
> partition boundaries, validating I/O block ranges, and so on).

=46orcefully extending partition boundaries and I/O block ranges was
just what I had in mind. My card reader was listed as being compatible
with card >1GB, and I suspected that this was only verified under
Windows. I knew that Windows believed in the partition table more
strongly than into device boundaries, so I figured that would probably
work. And it did.

> A lot of older card readers can't handle cards larger than 1 or 2 GB =
(I
> forget which). =C2=A0Or they see that the card has a larger block siz=
e and
> then don't report it to the host.

That was quite helpful to me
http://www.hjreggel.net/cardspeed/special-sd.html
--=20
=46ruhwirth Clemens http://clemens.endorphin.org
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
