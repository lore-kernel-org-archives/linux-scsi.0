From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Fri, 15 Jul 2005 12:53:33 -0300
Message-ID: <20050715155332.GA3954@ime.usp.br>
References: <1120926901.5008.12.camel@mulgrave> <200507091656.j69GuP5Y028863@einhorn.in-berlin.de> <20050715005309.GB14816@ime.usp.br> <20050715014312.GI13229@phunnypharm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout5.uol.com.br ([200.221.4.196]:57738 "EHLO
	smtp.uol.com.br") by vger.kernel.org with ESMTP id S261957AbVGOPxg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2005 11:53:36 -0400
Received: from dumont.rtb.ath.cx (unknown [200.221.104.251])
	by scorpion5.uol.com.br (Postfix) with ESMTP id 63CB67EF6
	for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2005 12:53:33 -0300 (BRT)
Content-Disposition: inline
In-Reply-To: <20050715014312.GI13229@phunnypharm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <bcollins@debian.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, James.Bottomley@SteelEye.com, arjan@infradead.org

Hi, all.

On Jul 14 2005, Ben Collins wrote:
> Can you give the latest git tree, plus the latest linux1394 repo a tr=
y?

Well, I just booted with a vanilla -rc3-git2 kernel with the patch to t=
he
hotplug scripts that Stefan mentioned in an earlier e-mail and the
enclosure worked this time.

I didn't try the linux1394 trunk yet.

I just uploaded the dmesg output to <http://www.ime.usp.br/~rbrito/bug/=
>.


Thank you very much for the help, Rog=E9rio.

--=20
Rog=E9rio Brito : rbrito@ime.usp.br : http://www.ime.usp.br/~rbrito
Homepage of the algorithms package : http://algorithms.berlios.de
Homepage on freshmeat:  http://freshmeat.net/projects/algorithms/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
