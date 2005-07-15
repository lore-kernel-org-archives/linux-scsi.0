From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Fri, 15 Jul 2005 12:30:02 -0300
Message-ID: <20050715153001.GB7792@ime.usp.br>
References: <1120926901.5008.12.camel@mulgrave> <200507091656.j69GuP5Y028863@einhorn.in-berlin.de> <20050715005309.GB14816@ime.usp.br> <20050715014312.GI13229@phunnypharm.org> <42D7596B.1090801@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout6.uol.com.br ([200.221.4.197]:25744 "EHLO
	smtp.uol.com.br") by vger.kernel.org with ESMTP id S261521AbVGOPaF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2005 11:30:05 -0400
Received: from dumont.rtb.ath.cx (unknown [200.221.104.251])
	by scorpion6.uol.com.br (Postfix) with ESMTP id 6B0A67777
	for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2005 12:30:02 -0300 (BRT)
Content-Disposition: inline
In-Reply-To: <42D7596B.1090801@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, James.Bottomley@SteelEye.com

On Jul 15 2005, Stefan Richter wrote:
> This type should also appear with the latest linux1394 drivers.
> sd_mod should be bound to this type now, but it must be loaded manual=
ly
> or the hotplug script needs to be adapted:
> http://marc.theaimsgroup.com/?m=3D112129844017488

Ok, I already patched the hotplug scripts. I will post the results I ge=
t in
the next reboot.

> Rog=E9rio, the disable_irm issue has not been addressed yet, so pleas=
e
> try the new code with and without this parameter. (I still intent to
> find out how to make it work without that parameter.) Thanks for test=
ing.

I will test that and report ASAP.

> I hope you get well again soon.


Thank you very much for everything, Rog=E9rio.

--=20
Rog=E9rio Brito : rbrito@ime.usp.br : http://www.ime.usp.br/~rbrito
Homepage of the algorithms package : http://algorithms.berlios.de
Homepage on freshmeat:  http://freshmeat.net/projects/algorithms/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
