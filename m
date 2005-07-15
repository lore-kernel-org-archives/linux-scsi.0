From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Fri, 15 Jul 2005 08:36:27 +0200
Message-ID: <42D7596B.1090801@s5r6.in-berlin.de>
References: <1120926901.5008.12.camel@mulgrave> <200507091656.j69GuP5Y028863@einhorn.in-berlin.de> <20050715005309.GB14816@ime.usp.br> <20050715014312.GI13229@phunnypharm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:51357 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S263218AbVGOGhK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2005 02:37:10 -0400
In-Reply-To: <20050715014312.GI13229@phunnypharm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, James.Bottomley@SteelEye.com

Ben Collins wrote:
> Can you give the latest git tree, plus the latest linux1394 repo a tr=
y?
>=20
> On Thu, Jul 14, 2005 at 09:53:09PM -0300, Rog=E9rio Brito wrote:
>>Already reporting to James the contents of
>>/sys/class/scsi_device/<dev>/device/type when the device isn't config=
ured
>>(I'm using a -rc2-mm1 kernel here; vanilla -mm, that is), I get:
>>
>>- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -=
 - - -
>>rbrito@dumont:~$ cat /sys/class/scsi_device/0\:0\:0\:0/device/type=20
>>14

This type should also appear with the latest linux1394 drivers.
sd_mod should be bound to this type now, but it must be loaded manually
or the hotplug script needs to be adapted:
http://marc.theaimsgroup.com/?m=3D112129844017488

Rog=E9rio, the disable_irm issue has not been addressed yet, so please
try the new code with and without this parameter. (I still intent to
find out how to make it work without that parameter.) Thanks for testin=
g.

I hope you get well again soon.
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D-=3D -=3D=3D=3D -=3D=3D=3D=3D
http://arcgraph.de/sr/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
