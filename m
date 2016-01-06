From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Wed, 6 Jan 2016 17:44:49 +0100
Message-ID: <20160106174449.63e6bc5c@harpe.intellique.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:50067 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbcAFQoq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2016 11:44:46 -0500
In-Reply-To: <alpine.LSU.2.11.1601041219340.1615@xnv.znxvfnen.cevingr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

Le Mon, 4 Jan 2016 12:22:34 +0200 (EET)
Kai Makisara <Kai.Makisara@kolumbus.fi> =C3=A9crivait:

> The patch has been tested with my DDS-4 drive.

Oh BTW, may be you could correct this one while you're at it :) I don't
think my kernel is so old... :)

~# mt -f /dev/st0 stshowopt
Your kernel (3.18.25) may be too old for this command.
The options set: buffer-writes async-writes read-ahead debug can-bsr ca=
n-partitions


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
