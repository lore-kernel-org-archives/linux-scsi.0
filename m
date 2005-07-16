From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sat, 16 Jul 2005 20:10:51 +0200
Message-ID: <42D94DAB.2050302@s5r6.in-berlin.de>
References: <1120926901.5008.12.camel@mulgrave> <200507091656.j69GuP5Y028863@einhorn.in-berlin.de> <20050715005309.GB14816@ime.usp.br> <20050715014312.GI13229@phunnypharm.org> <20050715155332.GA3954@ime.usp.br> <20050715172854.GJ13229@phunnypharm.org> <20050715185034.GA3903@ime.usp.br> <20050715205741.GN13229@phunnypharm.org> <20050716014225.GA9733@ime.usp.br> <20050716155637.GA22044@phunnypharm.org> <20050716164202.GA3846@ime.usp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:7074 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S261786AbVGPSLL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Jul 2005 14:11:11 -0400
In-Reply-To: <20050716164202.GA3846@ime.usp.br>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Cc: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>

Rog=E9rio Brito wrote:
> I just modprobe'd sd_mod by hand and the device was recognized:
[...]
> ieee1394: sbp2: Logged into SBP-2 device
> ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
>   Vendor: ST316002  Model: 1A                Rev: 3.06
>   Type:   Unknown                            ANSI SCSI revision: 06
> SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
[...]
> I had to load sd_mod by hand, though. The hotplug scripts didn't load=
 it
> this time.

The .../device/type is 14, right?

In the scsi.agent patch I posted earlier I added that device number and=
 its
association with sd_mod. However I must admit I did not test this patch=
 in
the form that I posted since my distro uses a little different scsi.age=
nt.

I could check your scsi.agent if you upload or post it although the nec=
essary
addition is trivial.

But make sure hotplug is really active and not accidently disabled.
(E.g. sbp2 should be autoloaded too when ieee1394 detected an SBP-2 dev=
ice.)
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D-=3D -=3D=3D=3D =3D----
http://arcgraph.de/sr/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
