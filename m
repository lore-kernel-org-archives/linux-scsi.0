From: Clemens Fruhwirth <clemens@endorphin.org>
Subject: Re: [PATCH] Forcing SCSI capacity for broken SD Card readers
Date: Sun, 20 Dec 2009 20:12:27 +0100
Message-ID: <2f83750a0912201112j7ceb6eb9jcac38324a89fc03b@mail.gmail.com>
References: <2f83750a0912200520l8e16fe6vdb436e67868c8f07@mail.gmail.com>
	 <Pine.LNX.4.44L0.0912201226520.24162-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:8039 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276AbZLTTM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2009 14:12:29 -0500
In-Reply-To: <Pine.LNX.4.44L0.0912201226520.24162-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Grant Grundler <grundler@google.com>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Sun, Dec 20, 2009 at 6:31 PM, Alan Stern <stern@rowland.harvard.edu>=
 wrote:
> On Sun, 20 Dec 2009, Clemens Fruhwirth wrote:
>> Forcefully extending partition boundaries and I/O block ranges was
>> just what I had in mind. My card reader was listed as being compatib=
le
>> with card >1GB, and I suspected that this was only verified under
>> Windows. I knew that Windows believed in the partition table more
>> strongly than into device boundaries, so I figured that would probab=
ly
>> work. And it did.
>
> Just out of curiousity, what happens if you try to repartition and
> format a card using this reader under Windows? =C2=A0Does it restrict=
 the
> total available size to 1 GB? =C2=A0If it does, doesn't that indicate=
 the
> reader _isn't_ compatible with large cards?

I turns out windows _does_ respect the values reported by the device.
However, not sure if this is a new thing in Windows 7.

So from that perspective, the card reader isn't >1GB-ready. But from
another perspective, it is compatible, namely the practical
perspective -- when sending the right USB commands you get a 2GB card
that is written to correctly.
--=20
=46ruhwirth Clemens http://clemens.endorphin.org
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
