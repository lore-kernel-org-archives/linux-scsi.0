From: Martin Dalecki <dalecki@evision-ventures.com>
Subject: Re: [PATCH] /proc/scsi/map
Date: Thu, 20 Jun 2002 23:36:31 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D124ADF.6030103@evision-ventures.com>
References: <Pine.LNX.4.44.0206201401010.8225-100000@home.transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Kurt Garloff <garloff@suse.de>, Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>

U=BFytkownik Linus Torvalds napisa=B3:
>=20
> On Thu, 20 Jun 2002, Martin Dalecki wrote:
>=20
>>>	/devices/disks/disk0 -> ../../pci0/00:02.0/02:1f.0/03:07.0/disk0
>>
>>                  ^^^^^^^^^^ You notice the redundancy in naming here=
 :-).
>=20
>=20
> I'd rather have redundancy than have horrible names like just "0", th=
ank
> you very much.
>=20
> It takes up no space, all the dentries are virtual anyway, and a dent=
ry
> embeds the storage for the first n characters (n ~16 or something lik=
e
> that).
>=20
>=20
>>Boah the chierachies are already deep enough. /devices/net/eth@XX
>>will cut it.
>=20
>=20
> There is _no_ excuse for being terse.

Yes indeed:

ls 	DIR
cp 	COPY
mv      REANME
cat     TYPE

Note: the VMS stuff was even longer. You ever used the "shell" there?

> Also, never EVER use special characters like "@" unless there is _rea=
son_
> to use them. I don't see any reason to make a filesystem look like pe=
rl.

The reaons is that it is making the splitup betwen the enumeration
and naming part very easy. Not just for scripts but for C code as well.
Numbers get user quite frequently for versioning as well.
And I tought the above should be mainly used by programs?

> Please use sane names like "disknnn" over insane cryptographically se=
cure
> filesystem contents like "sd@nnn".

I'm so used to sd@ :-). Don't invent where you can borrow - or you will
go the esperanto way.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
