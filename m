From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: aha152x_cs: non-functional + locking error
Date: Mon, 29 Jun 2009 08:07:56 -0700
Message-ID: <4A48D8CC.8000900@xenotime.net>
References: <4A452126.7040003@xenotime.net> <20090628202814.GA8498@norbit.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.64.118]:56949 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752324AbZF2PIE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jun 2009 11:08:04 -0400
Received: from ::ffff:98.108.130.97 ([98.108.130.97]) by xenotime.net for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2009 08:07:57 -0700
In-Reply-To: <20090628202814.GA8498@norbit.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?=22J=FCrgen_E=2E_Fischer=22?= <jef@norbit.de>
Cc: scsi <linux-scsi@vger.kernel.org>, fischer@norbit.de

J=FCrgen E. Fischer wrote:
> Hi Randy,
>=20
> On Fri, 26. Jun 2009 at 12:27:34 -0700, Randy Dunlap wrote:
>> When I try to use aha152x_cs on any recent kernel, I get messages li=
ke
>=20
>> (scsi2:4:0) cannot abort running or disconnected command
>> (scsi2:4:0) cannot reset current device
>=20
>> so I enabled lots of debugging (in 2.6.30) and get (end of message l=
og):
>=20
> IIRC that might trigger lockups.

It's non-functional for me without debugging as well.
But not due to locking errors.


>> Does anyone successfully use aha152x_cs now?
>=20
> Just occasionally, when I need to scan something.  I tried 2.6.30 usi=
ng that
> scanner and an old disk.  Still works for me.

 Thanks.

--=20
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
