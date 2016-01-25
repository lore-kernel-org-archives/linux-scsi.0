From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: What partition should the MTMKPART argument specify? Was: Re:
 st driver doesn't seem to grok LTO partitioning
Date: Mon, 25 Jan 2016 11:21:30 +0100
Message-ID: <20160125112130.1350643c@harpe.intellique.com>
References: <20151218170644.24167419@harpe.intellique.com>
	<alpine.LSU.2.11.1601041219340.1615@xnv.znxvfnen.cevingr>
	<20160104124626.3112e8c0@harpe.intellique.com>
	<CAAzz28iCoG-rjnL7EsjHXA7UtRJSCEXuwL3+27ZBo7fckcBAfg@mail.gmail.com>
	<688812570.3359420.1452030904683.JavaMail.zimbra@redhat.com>
	<20160106161049.34f29973@harpe.intellique.com>
	<1993563395.3556606.1452093814452.JavaMail.zimbra@redhat.com>
	<20160106170720.61db9e86@harpe.intellique.com>
	<1371374871.6203837.1452802373256.JavaMail.zimbra@redhat.com>
	<DDB9C85B850785449757F9914A034FCB4450CE9B@G9W0766.americas.hpqcorp.net>
	<0840949A-970D-43FB-A691-E2F8AC2A0804@kolumbus.fi>
	<DDB9C85B850785449757F9914A034FCB44517327@G4W3219.americas.hpqcorp.net>
	<alpine.LSU.2.11.1601242247440.3145@xnv.znxvfnen.cevingr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:43294 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755173AbcAYKVa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2016 05:21:30 -0500
In-Reply-To: <alpine.LSU.2.11.1601242247440.3145@xnv.znxvfnen.cevingr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: "Seymour, Shane M" <shane.seymour@hpe.com>, Laurence Oberman <loberman@redhat.com>, Laurence Oberman <oberman.l@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Le Sun, 24 Jan 2016 23:05:17 +0200 (EET)
Kai Makisara <Kai.Makisara@kolumbus.fi> =C3=A9crivait:

> Below is a test patch that implements the current behaviour with=20
> non-negative argument (but works with LTOs etc.) and makes partition=20
> zero size absolute value of argument (MB) if argument is negative. If=
=20
> you want to test the patch, note that the current mt-st does not
> accept negative numbers. A minimal patch is needed.

OK I'm going to try this one.

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
