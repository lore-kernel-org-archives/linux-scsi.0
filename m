From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: 3.3.0/3.4.1 | 53c1030 PCI-X Fusion-MPT | mptbase: ioc0:
 LogInfo(0x11010000): F/W: bug! MID not found
Date: Wed, 6 Jun 2012 15:05:24 +0200
Message-ID: <20120606150524.5da58b01@harpe.intellique.com>
References: <DE50C1A5-85F6-4B84-B77F-BCED651D2EB5@4lin.net>
	<20120606133435.16a502b8@harpe.intellique.com>
	<825C042F-9868-48E4-AEF1-B6FF20FA5E06@4lin.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:42357 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568Ab2FFNFa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jun 2012 09:05:30 -0400
In-Reply-To: <825C042F-9868-48E4-AEF1-B6FF20FA5E06@4lin.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denny Schierz <linuxmail@4lin.net>
Cc: linux-scsi@vger.kernel.org

Le Wed, 6 Jun 2012 13:42:48 +0200
Denny Schierz <linuxmail@4lin.net> =E9crivait:

> Raid 5, and JBOD says, everything is O.K, no problem at all.

Apparently this is a known problem with this driver under high IO. See:

https://bugzilla.novell.com/show_bug.cgi?id=3D554152
https://bugzilla.redhat.com/show_bug.cgi?id=3D210243

http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg12758.html

There aren't any clear solution, unfortunately.

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
