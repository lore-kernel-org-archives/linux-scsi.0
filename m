From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Wed, 6 Jan 2016 17:16:40 +0100
Message-ID: <20160106171640.465a0d48@harpe.intellique.com>
References: <20151218170644.24167419@harpe.intellique.com>
	<20151221134649.293a1a1e@harpe.intellique.com>
	<F89B43DA-FE51-4FEF-97BB-C79A401050D7@kolumbus.fi>
	<20151221185759.38dd21d6@harpe.intellique.com>
	<3F0204AE-89BD-45C7-883F-D6EC3A1D34E2@kolumbus.fi>
	<alpine.LSU.2.11.1512251732060.4761@xnv.znxvfnen.cevingr>
	<20151229175859.0c2c9b91@harpe.intellique.com>
	<8BB7A0F5-0F45-48C4-AB16-1EB7F23BD565@kolumbus.fi>
	<20151229191347.2e0e5f0e@harpe.intellique.com>
	<alpine.LSU.2.11.1512301947150.1713@xnv.znxvfnen.cevingr>
	<20151230193309.0df94c88@harpe.intellique.com>
	<D1FDE9A6-D190-4ABC-B935-56A65200956A@kolumbus.fi>
	<20151230222418.03e40cf7@harpe.intellique.com>
	<AC6651F8-0642-42DF-A3B1-72C5A8D8E665@kolumbus.fi>
	<alpine.LSU.2.11.1601041219340.1615@xnv.znxvfnen.cevingr>
	<20160104124626.3112e8c0@harpe.intellique.com>
	<20160106171015.4edacf41@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:46949 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbcAFQQg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2016 11:16:36 -0500
In-Reply-To: <20160106171015.4edacf41@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

Le Wed, 6 Jan 2016 17:10:15 +0100
Emmanuel Florac <eflorac@intellique.com> =C3=A9crivait:

> Works OK with LTO-5 (HP). Sizing the partitions is quite difficult, a=
s
> you can see. To get one "wrap" in the first partition, "1400000" and
> "1424000" work, but "1450000" doesn't. Same for LTO-6 (I'm still
> looking for the proper size).
>=20

Looks like the proper size for a "one wrap" 38 GB partition 0 on LTO-6
is "2450000". Go figure.

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
