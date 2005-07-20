From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Tue, 19 Jul 2005 21:20:39 -0300
Message-ID: <20050720002039.GA4127@ime.usp.br>
References: <20050716014225.GA9733@ime.usp.br> <20050716155637.GA22044@phunnypharm.org> <20050716164202.GA3846@ime.usp.br> <20050717165712.GA7883@phunnypharm.org> <20050717191832.GB15629@ime.usp.br> <42DAB58F.4000801@s5r6.in-berlin.de> <42DAF44D.2040500@ime.usp.br> <42DAE951.1080209@s5r6.in-berlin.de> <42DB3526.9050009@cs.uni-sb.de> <20050718081813.GA5976@ime.usp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout5.uol.com.br ([200.221.4.196]:29144 "EHLO
	smtp.uol.com.br") by vger.kernel.org with ESMTP id S261625AbVGTAVj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2005 20:21:39 -0400
Received: from dumont.rtb.ath.cx (unknown [200.221.104.251])
	by scorpion5.uol.com.br (Postfix) with ESMTP id F1CD38475
	for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2005 21:21:36 -0300 (BRT)
Content-Disposition: inline
In-Reply-To: <20050718081813.GA5976@ime.usp.br>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Philipp Slusallek <slusallek@cs.uni-sb.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, Ben Collins <bcollins@debian.org>

Hi, all.

On Jul 18 2005, Rog=E9rio Brito wrote:
> On Jul 18 2005, Philipp Slusallek wrote:
> > I though everyone would notice it: There is an "S" missing in the=20
> > rbc-disk line from Rogerio's scsi.agent file.
>=20
> Good catch! I am now going to bed, but I will change that and test it=
 as
> soon as I wake up. I will report back the results that I get.

Just reporting what I promised, indeed, the missing "S" in the scsi.age=
nt
script was enough to make everything work with the linux1394 trunk.

Now, with the patched scsi.agent, the sd_mod actually gets loaded when =
I
plug the device.


Thank you very much, Rog=E9rio.

--=20
Rog=E9rio Brito : rbrito@ime.usp.br : http://www.ime.usp.br/~rbrito
Homepage of the algorithms package : http://algorithms.berlios.de
Homepage on freshmeat:  http://freshmeat.net/projects/algorithms/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
