From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Tue, 22 Dec 2015 11:04:02 +0100
Message-ID: <20151222110402.4ac6ffcd@harpe.intellique.com>
References: <20151218170644.24167419@harpe.intellique.com>
	<20151221134649.293a1a1e@harpe.intellique.com>
	<F89B43DA-FE51-4FEF-97BB-C79A401050D7@kolumbus.fi>
	<20151221185759.38dd21d6@harpe.intellique.com>
	<3F0204AE-89BD-45C7-883F-D6EC3A1D34E2@kolumbus.fi>
	<DDB9C85B850785449757F9914A034FCB444FC76D@G4W3219.americas.hpqcorp.net>
	<CAAzz28i5=oz_BmcoEC2ApLN9zj_F4aDmGkCXkXaS48HR_Ockew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:64137 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932562AbbLVKEC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2015 05:04:02 -0500
In-Reply-To: <CAAzz28i5=oz_BmcoEC2ApLN9zj_F4aDmGkCXkXaS48HR_Ockew@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <oberman.l@gmail.com>
Cc: Shane M Seymour <shane.seymour@hpe.com>, linux-scsi@vger.kernel.org, Kai =?UTF-8?B?TcOka2lzYXJh?= <kai.makisara@kolumbus.fi>

Le Tue, 22 Dec 2015 02:20:31 -0500
Laurence Oberman <oberman.l@gmail.com> =C3=A9crivait:

> I also have access to newer hardware if needed. I have started
> reviewing all of this and will post back to this thread.
> Emmanuel can you summarize what you would like to achieve and we will
> all work on this together.

I'd like to be able to partition LTO media through standard commands,
like "mt mkpartition", mostly to be able to create LTFS tapes without
relying on hard to compile code from IBM/HP/Quantum/Oracle.

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
