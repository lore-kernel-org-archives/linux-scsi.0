From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: RE: 5.2.x kernel: WD 8TB USB Drives: Unaligned partial completion (resid=78, sector_sz=512)
Date: Sat, 3 Aug 2019 15:37:16 -0400
Message-ID: <001b01d54a32$dbb09260$9311b720$@lucidpixels.com>
References: <006d01d549db$54e42140$feac63c0$@lucidpixels.com> <Pine.LNX.4.44L0.1908031458330.22056-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1908031458330.22056-100000@netrider.rowland.org>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: damien.lemoal@wdc.com
Cc: 'LKML' <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, 'Alan Stern' <stern@rowland.harvard.edu>
List-Id: linux-scsi@vger.kernel.org



-----Original Message-----
From: Alan Stern [mailto:stern@rowland.harvard.edu]=20
Sent: Saturday, August 3, 2019 3:00 PM
To: Justin Piszcz
Cc: 'LKML'; linux-usb@vger.kernel.org; linux-scsi@vger.kernel.org
Subject: Re: 5.2.x kernel: WD 8TB USB Drives: Unaligned partial =
completion (resid=3D78, sector_sz=3D512)

On Sat, 3 Aug 2019, Justin Piszcz wrote:

> Attached 2 x brand new Western Digital 8TB USB 3.0 drives awhile back =
and
> ran some file copy tests and was getting these warnings-- is there any =
way
> to avoid these warnings?=EF=BF=BD I did confirm with parted that the =
partition was
> aligned but this appears to be something related to the firmware on =
the
> device according to [1] and [2]?
>=20
> [1]=EF=BF=BDhttps://patchwork.kernel.org/patch/9573203/
> [2] https://patchwork.kernel.org/patch/9597797/

Just out of curiosity, why did you not address your email to the author=20
or committer of this patch?  Surely they would be the people in the=20
best position to answer your questions.

[ .. ]

Fixed.

I had been researching this issue and did not find any useful notes on =
the mailing lists--hopefully this will help others if there's a copy of =
the response on the mailing list.

These drives [1] [2] are the ones noted as affected when used on Linux =
[1] plugged in directly to a Linux PC (w/USB 3.0/XHCI) and [2] when in a =
USB enclosure with a JMicron SATA Bridge.

[1] WDBBGB0080HBK-NESN - =
https://www.wd.com/products/external-storage/my-book-new.html#WDBBGB0080H=
BK-NESN
[2] WD40EZRZ-22GXCB0 - =
https://www.wd.com/products/internal-storage/wd-blue-pc-desktop-hard-driv=
e.html  (In a USB enclosure with a JMicron SATA Bridge - per Markus)

Regards,

Justin.
