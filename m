From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: 2.6.22 oops kernel BUG at block/elevator.c:366!
Date: Wed, 29 Aug 2007 19:10:27 +0200
Message-ID: <200708291910.27742.arekm@maven.pl>
References: <200708291241.52473.arekm@maven.pl> <200708291515.59105.arekm@maven.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.carme.maven.pl ([193.239.45.138]:58421 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbXH2RKk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Aug 2007 13:10:40 -0400
Received: from chello089076029142.chello.pl ([89.76.29.142] helo=[192.168.0.124])
	by main.carme.maven.pl with esmtpa (Exim 4.67)
	(envelope-from <arekm@maven.pl>)
	id 1IQR3u-0008RG-Sc
	for linux-scsi@vger.kernel.org; Wed, 29 Aug 2007 19:10:38 +0200
In-Reply-To: <200708291515.59105.arekm@maven.pl>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Wednesday 29 of August 2007, Arkadiusz Miskiewicz wrote:
> On Wednesday 29 of August 2007, Arkadiusz Miskiewicz wrote:
> > Hello,
> >
> > I'm trying to get stable kernel for Promise SuperTrak
> > X16350 hardware. So far 2.6.20, 2.6.21 and 2.6.22 oopsed
> > like this (while doing rsync):
>
> With anticipatory:
>
> berta login: ------------[ cut here ]------------
> kernel BUG at block/as-iosched.c:1084!

One more information: I'm currently running 2.6.19 for few hours and th=
e oops=20
doesn't happen. Looks like some regression introduced between 2.6.19 an=
d=20
2.6.20.

--=20
Arkadiusz Mi=B6kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
