From: Eric GAUDET <eric@rti-zone.org>
Subject: Re: 2.4.20 scsi problem
Date: Mon, 02 Dec 2002 23:27:16 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <XFMail.20021202232716.eric@rti-zone.org>
References: <1038867342.8945.0.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1038867342.8945.0.camel@irongate.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: groudier@free.fr, axboe@suse.de, linux-scsi@vger.kernel.org

-- En reponse de "Re: 2.4.20 scsi problem" de Alan Cox, le 02-Dec-2002 =
:
> On Mon, 2002-12-02 at 06:58, Eric GAUDET wrote:
>> # SCSI low-level drivers
>> #
>> (none set)
>=20
> That sounds like your problem to me

Unfortuately, as I said in my earlier message:
>> Compiling sd as a module instead of in the kernel does not seem to c=
hange
>> anything. Nor compiling with a scsi low-level driver. It seems that =
I need an
>> actual scsi device at boot time in order to see block device 8 (not =
tested, I
>> don=B4t have such a device)

Just for kicks, I tried with:
CONFIG_SCSI_AHA152X=3Dy
but it does not seem to help.

The .config I used for 2.4.18 (the one that is working fine), and the o=
ne for
2.4.20 are exactly the same, I just loaded it with make oldconfig witho=
ut
changing a thing. I can send those two config files if it helps.

Anyway, just asking for scsi disk support should be enough to see block=
 device
8 (and it used to work just fine) without needing a low-level driver at=
 boot
time: I boot on my ide driver and plug my external scsi HD (really a us=
b HD
using scsi subsystem) afterwards.

dmesg used to report:
SCSI subsystem driver Revision: 1.00
request_module[scsi_hostadapter]: Root fs not mounted

Now it says:
SCSI subsystem driver Revision: 1.00
kmod: failed to exec /sbin/modprobe -s -k scsi_hostadapter, errno =3D 2

Do this mean nobody else is seeing the problem?

Thanks,
-----------------------------------------------------------------------=
-
Eric GAUDET <eric@rti-zone.org>
Le 02-Dec-2002 a 19:38:34
-----------------------------------------------------------------------=
-

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
