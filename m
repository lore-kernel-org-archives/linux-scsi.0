From: =?iso-8859-1?B?SvxyZ2VuIEUu?= Fischer <jef@norbit.de>
Subject: Re: aha152x_cs: non-functional + locking error
Date: Sun, 28 Jun 2009 22:28:14 +0200
Message-ID: <20090628202814.GA8498@norbit.de>
References: <4A452126.7040003@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.norbit.de ([88.198.11.231]:54747 "EHLO mail.norbit.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbZF1UoF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Jun 2009 16:44:05 -0400
Content-Disposition: inline
In-Reply-To: <4A452126.7040003@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: scsi <linux-scsi@vger.kernel.org>, fischer@norbit.de

Hi Randy,

On Fri, 26. Jun 2009 at 12:27:34 -0700, Randy Dunlap wrote:
> When I try to use aha152x_cs on any recent kernel, I get messages lik=
e

> (scsi2:4:0) cannot abort running or disconnected command
> (scsi2:4:0) cannot reset current device

> so I enabled lots of debugging (in 2.6.30) and get (end of message lo=
g):

IIRC that might trigger lockups.

=20
> Does anyone successfully use aha152x_cs now?

Just occasionally, when I need to scan something.  I tried 2.6.30 using=
 that
scanner and an old disk.  Still works for me.


J=FCrgen

--=20
norBIT Gesellschaft fuer Unternehmensberatung und Informationssysteme m=
bH
Rheinstrasse 13, 26506 Norden
GF: Jelto Buurman, HR: Amtsgericht Emden, HRB 5502

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
