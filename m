From: =?ISO-8859-1?Q?Erik_Inge_Bols=F8?= <knan@mo.himolde.no>
Subject: Re: Megaraid, I/O error...
Date: Sun, 7 Apr 2002 18:36:01 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0204071826480.17889-100000@yme.mo.himolde.no>
References: <E16tz8F-0002s8-00@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
In-Reply-To: <E16tz8F-0002s8-00@the-village.bc.nu>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org, knan@tvilsom.org

On Sat, 6 Apr 2002, Alan Cox wrote:
>> SCSI disk error : host 0 channel 2 id 0 lun 0 return code =3D3D 2504=
0001
>>  I/O error: dev 08:06, sector 4749296
>> SCSI disk error : host 0 channel 2 id 0 lun 0 return code =3D3D 2504=
0001
>>  I/O error: dev 08:06, sector 4749304
>>
>> Do this mean what I suspect, that a disk is failing?
>
>I've also seen it when a cable came loose.

Just checked the cables, seems I'm out of luck. One of two identical di=
sks
failing after two months is not good. And on a saturday, too.

Thanks for the help.

Time to go for RAID 5, I think.

>> How do I find out which disk is failing, when linux only knows about=
 th=3D
>> em as one logical disk? Listen for which disk makes bad noises? :/
>
>I've never found a way to do that without checking the BIOS - that wil=
l
>say which drive it thinks failed if you are lucky

Ah. Megamon told me the physical drive by mail to root, when I installe=
d
it and fired it up. "Medium error count: 249" does not sound good for
that drive.

--
Erik I. Bols=F8 | email: <knan at mo.himolde.no>
The UNIX philosophy basically involves giving you enough rope to
hang yourself.  And then a couple of feet more, just to be sure.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
