From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: Patch for LSI Logic Fusion MPT
Date: Tue, 9 Mar 2004 13:02:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57040DAAF7@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:9112 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262080AbUCISDB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Mar 2004 13:03:01 -0500
List-Id: linux-scsi@vger.kernel.org
To: Alexander Stohr <Alexander.Stohr@gmx.de>, linux-scsi@vger.kernel.org
Cc: mpt_linux_developer@lsil.com, sjralston1@netscape.net

I will look at applying this against the
driver I released yesterday.

ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-patches/3.=
01.00

Eric Moore
Staff Engineer
Standard Storage Products Division
LSI Logic Corporation
4420 Arrowswest Drive
Colorado Springs, CO 80907
Email: emoore@lsil.com
Web: http://www.lsilogic.com/



On  Tuesday, March 09, 2004 10:52 AM, Alexander Stohr wrote:
>=20
>=20
> Hello,
>=20
> the below attached patch does fix a warning
> when the LSI MPT  driver is compiled into the kernel.
> The patch is made against Kernel 2.6.4-rc2.
> Please apply. Thanks.
>=20
> -Alex.
>=20
> --=20
> +++ NEU bei GMX und erstmalig in Deutschland: T=DCV-gepr=FCfter=20
> Virenschutz +++
> 100% Virenerkennung nach Wildlist. Infos:=20
> http://www.gmx.net/virenschutz
>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
