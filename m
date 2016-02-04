From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: What partition should the MTMKPART argument specify? Was: Re:
 st driver doesn't seem to grok LTO partitioning
Date: Thu, 4 Feb 2016 19:12:29 +0100
Message-ID: <20160204191229.1ba481c1@harpe.intellique.com>
References: <20151218170644.24167419@harpe.intellique.com>
	<20160106170720.61db9e86@harpe.intellique.com>
	<1371374871.6203837.1452802373256.JavaMail.zimbra@redhat.com>
	<DDB9C85B850785449757F9914A034FCB4450CE9B@G9W0766.americas.hpqcorp.net>
	<0840949A-970D-43FB-A691-E2F8AC2A0804@kolumbus.fi>
	<DDB9C85B850785449757F9914A034FCB44517327@G4W3219.americas.hpqcorp.net>
	<alpine.LSU.2.11.1601242247440.3145@xnv.znxvfnen.cevingr>
	<DDB9C85B850785449757F9914A034FCB44522A7B@G9W0766.americas.hpqcorp.net>
	<6685EAA5-B880-40FB-951D-BA94883049B3@kolumbus.fi>
	<DDB9C85B850785449757F9914A034FCB44523469@G9W0766.americas.hpqcorp.net>
	<alpine.LSU.2.11.1601291915010.22105@xnv.znxvfnen.cevingr>
	<DDB9C85B850785449757F9914A034FCB44525667@G9W0766.americas.hpqcorp.net>
	<alpine.LSU.2.11.1602032011230.2679@xnv.znxvfnen.cevingr>
	<DDB9C85B850785
 449757F9
 914A034FCB445262D4@G9W0766.americas.hpqcorp.net>
	<DA4D459C-6D64-4028-8D8D-6F266C77E036@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:37988 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbcBDSM0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2016 13:12:26 -0500
In-Reply-To: <DA4D459C-6D64-4028-8D8D-6F266C77E036@kolumbus.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kai =?UTF-8?B?TcOka2lzYXJh?= (Kolumbus)" <kai.makisara@kolumbus.fi>
Cc: "Seymour, Shane M" <shane.seymour@hpe.com>, Laurence Oberman <loberman@redhat.com>, Laurence Oberman <oberman.l@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Le Thu, 4 Feb 2016 19:54:55 +0200
"Kai M=C3=A4kisara (Kolumbus)" <kai.makisara@kolumbus.fi> =C3=A9crivait=
:

> > Tested with patched kernel 4.5.0-rc2-next-20160202+. It's looking
> > good everything partition related passed with DDS5 and LTO6. You
> > can definitely add me as a tested-by. I did find one issue below
> > but it's not related to the partitioning changes.=20
> Thanks for testing. It would be interesting to get confirmation from
> a LTO-5 user that partitioning works. Even without that I will make
> the final patch within a few days (remove some debugging and update
> the documentation).

I currently have one IBM LTO-4, one HP LTO-5 and one HP LTO-6 drives.
I'll try to run some tests tomorrow.

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
