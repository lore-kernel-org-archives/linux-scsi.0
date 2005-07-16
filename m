From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sat, 16 Jul 2005 16:34:06 -0300
Message-ID: <20050716193406.GB4092@ime.usp.br>
References: <20050715005309.GB14816@ime.usp.br> <20050715014312.GI13229@phunnypharm.org> <20050715155332.GA3954@ime.usp.br> <20050715172854.GJ13229@phunnypharm.org> <20050715185034.GA3903@ime.usp.br> <20050715205741.GN13229@phunnypharm.org> <20050716014225.GA9733@ime.usp.br> <20050716155637.GA22044@phunnypharm.org> <20050716164202.GA3846@ime.usp.br> <42D94DAB.2050302@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout5.uol.com.br ([200.221.4.196]:23543 "EHLO
	smtp.uol.com.br") by vger.kernel.org with ESMTP id S261494AbVGPTeK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Jul 2005 15:34:10 -0400
Received: from dumont.rtb.ath.cx (unknown [200.221.104.251])
	by scorpion5.uol.com.br (Postfix) with ESMTP id A81258212
	for <linux-scsi@vger.kernel.org>; Sat, 16 Jul 2005 16:34:06 -0300 (BRT)
Content-Disposition: inline
In-Reply-To: <42D94DAB.2050302@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

Hi, Stefan.

On Jul 16 2005, Stefan Richter wrote:
> Rog=E9rio Brito wrote:
> >I just modprobe'd sd_mod by hand and the device was recognized:
> [...]
> >ieee1394: sbp2: Logged into SBP-2 device
> >ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
> >  Vendor: ST316002  Model: 1A                Rev: 3.06
> >  Type:   Unknown                            ANSI SCSI revision: 06
> >SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
> [...]
> >I had to load sd_mod by hand, though. The hotplug scripts didn't loa=
d it
> >this time.
>=20
> The .../device/type is 14, right?

Yes, it still is.

(...)
> I could check your scsi.agent if you upload or post it although the=20
> necessary addition is trivial.

The changes you suggested are trivial indeed and hwere is what my
scsi.agent file has:

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -=
 - -
dumont:~# grep sd_mod /etc/hotplug/scsi.agent
    0)		TYPE=3Ddisk ;	MODULES=3Dsd_mod ;;
    7)		TYPE=3Dmod ;	MODULES=3Dsd_mod ;;
    14)		TYPE=3Drbc-disk ;  MODULE=3Dsd_mod ;;
dumont:~#=20
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -=
 - -

> But make sure hotplug is really active and not accidently disabled.

I think that it is working.

> (E.g. sbp2 should be autoloaded too when ieee1394 detected an SBP-2
> device.)

Yes, sbp2 is automatically loaded when the device is connected. But, fo=
r
some reason, the sd_mod module doesn't. :-(

I have uploaded dmesg's and lsmod's and other information to
<http://www.ime.usp.br/~rbrito/bug/>.

I think that I did it detailed enough (just after booting the system, a=
fter
plugging the device and after manually loading the sd_mod module) so th=
at
you can see whatever is interesting.

Of course, I can provide you with any information that you think might =
be
useful.


Thanks, Rog=E9rio.

--=20
Rog=E9rio Brito : rbrito@ime.usp.br : http://www.ime.usp.br/~rbrito
Homepage of the algorithms package : http://algorithms.berlios.de
Homepage on freshmeat:  http://freshmeat.net/projects/algorithms/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
