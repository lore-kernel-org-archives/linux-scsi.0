From: Fabien Salvi <fabien@cri74.org>
Subject: Re: Migrating RAID array to a different manufacturer controller
Date: Tue, 18 Feb 2003 09:59:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E51F5D7.2070507@cri74.org>
References: <Pine.LNX.4.44.0302170920001.31351-100000@ddnsupport.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Ryan Weiss <ryan@ddnsupport.com>
Cc: linux-scsi@vger.kernel.org



Ryan Weiss a =E9crit:
> The stripe segment size, stripe order, the parameter block informatio=
n
> (depends on controller, some have, some don't) being compatible, and =
any
> offset before starting storage space.  For the most part, I would cou=
nt on
> these things _not_ being compatible, and be happily surprised in any =
case
> where it is.
>=20
> Your best bet is to get the same controller (and have it run the same=
=20
> firmware rev), to pull data off.
>=20

Ok, I will try this.
Thanks for your advice, Ryan.


--=20
=46abien SALVI      Centre de Ressources Informatiques
                   Archamps, France -- http://www.cri74.org
                   PingOO GNU/linux distribution : http://www.pingoo.or=
g

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
