From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Fri, 15 Jul 2005 22:42:25 -0300
Message-ID: <20050716014225.GA9733@ime.usp.br>
References: <1120926901.5008.12.camel@mulgrave> <200507091656.j69GuP5Y028863@einhorn.in-berlin.de> <20050715005309.GB14816@ime.usp.br> <20050715014312.GI13229@phunnypharm.org> <20050715155332.GA3954@ime.usp.br> <20050715172854.GJ13229@phunnypharm.org> <20050715185034.GA3903@ime.usp.br> <20050715205741.GN13229@phunnypharm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout5.uol.com.br ([200.221.4.196]:24529 "EHLO
	smtp.uol.com.br") by vger.kernel.org with ESMTP id S262040AbVGPBm2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2005 21:42:28 -0400
Received: from dumont.rtb.ath.cx (unknown [200.221.104.251])
	by scorpion5.uol.com.br (Postfix) with ESMTP id 74E5E8016
	for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2005 22:42:26 -0300 (BRT)
Content-Disposition: inline
In-Reply-To: <20050715205741.GN13229@phunnypharm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <bcollins@debian.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, James.Bottomley@SteelEye.com, arjan@infradead.org

On Jul 15 2005, Ben Collins wrote:
> No, there are changes in the current rev of the repo. Are sure you tr=
ied
> the latest rev?

Well, I think it is, since this is what svn tells me:

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -=
 - -
rbrito@dumont:/usr/local/media/progs$ svn co svn://svn.linux1394.org/ie=
ee1394/trunk/ ieee1394
Checked out revision 1315.
rbrito@dumont:/usr/local/media/progs$=20
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -=
 - -

I then copied this over the ieee1394 tree of the git2 kernel and things
stopped working (but with vanilla git2, it worked).

I will now try what Stefan told me and I will report back.


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
