From: Xose Vazquez Perez <xose@wanadoo.es>
Subject: Re: differences in megaraid2 v2.00.9 source from LSIL FTP and 2.4.24
 tree
Date: Tue, 13 Jan 2004 14:25:47 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4003F1DB.7050802@wanadoo.es>
References: <20040113101507.6cad6e13@philou.gramoulle.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp13.eresmas.com ([62.81.235.113]:31720 "EHLO
	smtp13.eresmas.com") by vger.kernel.org with ESMTP id S264285AbUAMNeh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2004 08:34:37 -0500
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Philippe_Gramoull=E9?= <philippe.gramoulle@mmania.com>
Cc: MegaRaid-Devel <linux-megaraid-devel@dell.com>, linux-scsi <linux-scsi@vger.kernel.org>, atulm <atulm@lsil.com>

Philippe Gramoull=E9 wrote:

> I just compared the original source code from ftp.lsil.com and 2.4.24=
=2E
> v2.00.9 megaraid driver and i'd like to know what are the differences=
 and which one i should use.
>=20
> I assume that the one in the 2.4.24 is the one to be used but i just =
wanted to be sure.

The FTP driver is _only_ for Red Hat Enterprise LiNUX.
You have to clean the code to run on a standard kernel.


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
