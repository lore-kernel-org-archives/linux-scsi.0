From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: 5.2.x kernel: WD 8TB USB Drives: Unaligned partial completion (resid=78, sector_sz=512)
Date: Wed, 07 Aug 2019 22:03:36 -0400
Message-ID: <yq1ftmcct1j.fsf@oracle.com>
References: <006d01d549db$54e42140$feac63c0$@lucidpixels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <006d01d549db$54e42140$feac63c0$@lucidpixels.com> (Justin
        Piszcz's message of "Sat, 3 Aug 2019 05:10:44 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: 'LKML' <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Justin,

> Attached 2 x brand new Western Digital 8TB USB 3.0 drives awhile back and
> ran some file copy tests and was getting these warnings-- is there any way
> to avoid these warnings?=C2=A0 I did confirm with parted that the partiti=
on was
> aligned but this appears to be something related to the firmware on the
> device according to [1] and [2]?

Please send us the output of:

# sg_vpd -p bl /dev/sdN
# sg_vpd -p bdc /dev/sdN
# sg_readcap -l /dev/sdN

--=20
Martin K. Petersen	Oracle Linux Engineering
