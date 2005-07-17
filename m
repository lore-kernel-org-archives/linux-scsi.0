From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Mon, 18 Jul 2005 01:27:13 +0200
Message-ID: <42DAE951.1080209@s5r6.in-berlin.de>
References: <20050715005309.GB14816@ime.usp.br> <20050715014312.GI13229@phunnypharm.org> <20050715155332.GA3954@ime.usp.br> <20050715172854.GJ13229@phunnypharm.org> <20050715185034.GA3903@ime.usp.br> <20050715205741.GN13229@phunnypharm.org> <20050716014225.GA9733@ime.usp.br> <20050716155637.GA22044@phunnypharm.org> <20050716164202.GA3846@ime.usp.br> <20050717165712.GA7883@phunnypharm.org> <20050717191832.GB15629@ime.usp.br> <42DAB58F.4000801@s5r6.in-berlin.de> <42DAF44D.2040500@ime.usp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:7176 "EHLO
	statik.tu-cottbus.de") by vger.kernel.org with ESMTP
	id S261446AbVGQXbu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Jul 2005 19:31:50 -0400
In-Reply-To: <42DAF44D.2040500@ime.usp.br>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Cc: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>, Ben Collins <bcollins@debian.org>

Rog=E9rio Brito wrote:
> Stefan Richter wrote:
[sd_mod not auto-loaded]
>> But didn't you add type 14 (RBC disk) and its association with sd_mo=
d
>> to your distro's scsi.agent script already...?
>
> Yes, I did. I'm using a patched scsi.agent as per your recommendation=
=2E
[...]
> I am now slightly puzzled.

Me too.

> BTW, I'm using Debian testing as my distribution, just as some extra
> information.

I'm on Mandrake 10.1. Maybe they have some more routines in their
hotplug scripts whose relevance for scsi hotplugging escaped me.
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D-=3D --=3D=3D -=3D=3D=3D-
http://arcgraph.de/sr/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
