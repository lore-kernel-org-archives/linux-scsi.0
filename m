From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Tue, 29 Dec 2015 17:58:59 +0100
Message-ID: <20151229175859.0c2c9b91@harpe.intellique.com>
References: <20151218170644.24167419@harpe.intellique.com>
	<20151221134649.293a1a1e@harpe.intellique.com>
	<F89B43DA-FE51-4FEF-97BB-C79A401050D7@kolumbus.fi>
	<20151221185759.38dd21d6@harpe.intellique.com>
	<3F0204AE-89BD-45C7-883F-D6EC3A1D34E2@kolumbus.fi>
	<alpine.LSU.2.11.1512251732060.4761@xnv.znxvfnen.cevingr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:24280 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbbL2Q64 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Dec 2015 11:58:56 -0500
In-Reply-To: <alpine.LSU.2.11.1512251732060.4761@xnv.znxvfnen.cevingr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

Le Fri, 25 Dec 2015 17:53:46 +0200 (EET)
Kai Makisara <Kai.Makisara@kolumbus.fi> =C3=A9crivait:

> The patch uses the scsi level of the device to separate processing.
> The FORMAT MEDIUM command is defined in SCSI-3 and I suppose that no
> current drive is still SCSI-2. In addition to the "sane" changes
> using the method to specify partitions, the patch implements the
> following: if the size is 1, the driver tells the drive to use
> default partitioning for two partitions. For the HP Ultrium this
> should result in partition 0 of 1425 GB and 1 of 37.5 GB. I don't
> know if this is a useful addition.

Still testing, with another, LTO-5 tape:

~# mt -f /dev/nst0 mkpartition 0
/dev/nst0: Invalid argument

Dec 29 17:57:38 shakuhachi kernel: st 7:0:0:0: st0: Block limits 1 - 16=
777215 bytes.
Dec 29 17:57:38 shakuhachi kernel: st 7:0:0:0: st0: Mode sense. Length =
11, medium 0, WBS 10, BLL 8
Dec 29 17:57:38 shakuhachi kernel: st 7:0:0:0: st0: Density 58, tape le=
ngth: 0, drv buffer: 1
Dec 29 17:57:38 shakuhachi kernel: st 7:0:0:0: st0: Block size: 0, buff=
er size: 4096 (1 blocks).


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
