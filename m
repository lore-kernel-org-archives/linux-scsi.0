From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: help decoding aacraid errors (3.10.40 kernel)
Date: Fri, 27 Jun 2014 12:59:18 +0200
Message-ID: <201406271259.18659.a.miskiewicz@gmail.com>
References: <201406271055.08750.a.miskiewicz@gmail.com> <20140627104131.GD10042@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:42402 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbaF0K7W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jun 2014 06:59:22 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so2468693wib.0
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2014 03:59:21 -0700 (PDT)
In-Reply-To: <20140627104131.GD10042@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Friday 27 of June 2014, Bryn M. Reeves wrote:
> On Fri, Jun 27, 2014 at 10:55:08AM +0200, Arkadiusz Miskiewicz wrote:
> > [3757350.671860] Result: hostbyte=3D0x00 driverbyte=3D0x08
> > [3757350.671862] sd 0:0:2:0: [sdc]
> > [3757350.671863] Sense Key : 0x4 [current]
>=20
> http://www.t10.org/lists/2sensekey.htm
>=20
> 0x4 is "hardware error".
>=20
> > [3757350.671866] sd 0:0:2:0: [sdc]
> > [3757350.671868] ASC=3D0x44 ASCQ=3D0x0
>=20
> http://www.t10.org/lists/asc-num.htm
>=20
> 0x44/0x00 is "internal target failure".

Thanks for links. I wonder why kernel doesn't decode these to be actual=
ly=20
readable without a need for asking on ml - was decoding considered?

Anyway Adaptec support helped with details:

http://ask.adaptec.com/app/answers/detail/a_id/14947/track/AvOF~QqxDv8S=
~TbvGmIW~yLb_fsq5C75Mv~s~zj~PP8l

Basically this controller finds "bad stripes" and blocks any access to =
these=20
areas resulting in errors :-/ What's more interesting there is no recov=
ery=20
procedure beside recreation. Fun :-)

> Regards,
> Bryn.


--=20
Arkadiusz Mi=C5=9Bkiewicz, arekm / maven.pl

Q: vger.kernel.org postmasters - always rude and impolite, hmm?
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
