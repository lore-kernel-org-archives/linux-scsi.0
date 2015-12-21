From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Mon, 21 Dec 2015 18:49:11 +0100
Message-ID: <20151221184911.2a14b03f@harpe.intellique.com>
References: <20151218170644.24167419@harpe.intellique.com>
	<20151221134649.293a1a1e@harpe.intellique.com>
	<CAAzz28gn2zwC5ZUTtPupDOTHekGspWh0vnWHV+jvbx52c=cq2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:18511 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbbLURtJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2015 12:49:09 -0500
In-Reply-To: <CAAzz28gn2zwC5ZUTtPupDOTHekGspWh0vnWHV+jvbx52c=cq2Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <oberman.l@gmail.com>, linux-tape@vger.kernel.org, linux-scsi@vger.kernel.org

Le Mon, 21 Dec 2015 11:20:55 -0500
Laurence Oberman <oberman.l@gmail.com> =C3=A9crivait:

> The st driver gets a lot of attention actually. Let me look into this
> and get back you.

I've found that the IBM tape driver (lin_tape) implements neat ioctls
for LTO and 3592 tape partitionning. Just in case.

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
