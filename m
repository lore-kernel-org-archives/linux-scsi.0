From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: 3.3.0/3.4.1 | 53c1030 PCI-X Fusion-MPT | mptbase: ioc0:
 LogInfo(0x11010000): F/W: bug! MID not found
Date: Wed, 6 Jun 2012 13:34:35 +0200
Message-ID: <20120606133435.16a502b8@harpe.intellique.com>
References: <DE50C1A5-85F6-4B84-B77F-BCED651D2EB5@4lin.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:57696 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab2FFLfQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jun 2012 07:35:16 -0400
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id DDF75D1B260
	for <linux-scsi@vger.kernel.org>; Wed,  6 Jun 2012 13:35:12 +0200 (CEST)
In-Reply-To: <DE50C1A5-85F6-4B84-B77F-BCED651D2EB5@4lin.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denny Schierz <linuxmail@4lin.net>
Cc: linux-scsi@vger.kernel.org

Le Wed, 6 Jun 2012 13:07:14 +0200
Denny Schierz <linuxmail@4lin.net> =E9crivait:

> What could be the problem?
>=20

Definitely looks like a bad disk to me. What is the RAID level used on
the infortrend array? If it's RAID-0, look no further. Check your array
messages and eventually cabling in any case.

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
