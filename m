From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Adaptec 71605H HBA randomly failing to detect any drives at
 init
Date: Tue, 2 Sep 2014 16:06:38 +0200
Message-ID: <20140902160638.4824aff1@harpe.intellique.com>
References: <CAKmTNed2uSUGCDkxQSLofjgSGxLpZ154_gNpwt_NWChjR=s8iA@mail.gmail.com>
	<CAKmTNecfkgOoX6p_1MeV5vNac4N1KoGTjMRcWL2GV77piR8RUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:41990 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbaIBOND convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Sep 2014 10:13:03 -0400
In-Reply-To: <CAKmTNecfkgOoX6p_1MeV5vNac4N1KoGTjMRcWL2GV77piR8RUw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Robertson <andyrobertson101@gmail.com>
Cc: linux-scsi@vger.kernel.org

Le Mon, 1 Sep 2014 09:06:46 -0700
Andrew Robertson <andyrobertson101@gmail.com> =E9crivait:

> I'm happy to test patches/etc on this system if necessary -- and/or i=
f
> someone can help point me in the right direction, I'd appreciate it.

In my experience the 7xxx5 are very sensitive to cable length and
backplane type: basically work fine with 50 cm cables, and fails with 8=
0
cm cables with some backplanes (works with Supermicro, not with AIC,
etc).=20

So what is the backplane and cables you're using?

--=20
-----------------------------------------------------------------------=
-
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
-----------------------------------------------------------------------=
-
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
