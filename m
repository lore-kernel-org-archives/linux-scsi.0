From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: sym53c8xx driver hangs
Date: Fri, 18 Feb 2005 12:15:56 +0000
Message-ID: <20050218121556.GY29917@parcelfarce.linux.theplanet.co.uk>
References: <4214BD90.7030002@ludd.luth.se> <20050218051916.GX29917@parcelfarce.linux.theplanet.co.uk> <4215BDFF.6040703@ludd.luth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:8880 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261332AbVBRMP6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Feb 2005 07:15:58 -0500
Content-Disposition: inline
In-Reply-To: <4215BDFF.6040703@ludd.luth.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roger =?iso-8859-1?Q?H=E5kansson?= <hson@ludd.luth.se>
Cc: linux-scsi@vger.kernel.org

On Fri, Feb 18, 2005 at 11:05:51AM +0100, Roger H=E5kansson wrote:
> Matthew Wilcox wrote:
> >Yeah, I don't think any existing patch will help you. =20
>=20
> Actually I got it to work when I applied the patch frage schnell post=
ed=20
> jan.20 (http://marc.theaimsgroup.com/?l=3Dlinux-scsi&m=3D110624183606=
642)

Oh.  I think I'm confused as to which version of sym2 is in which versi=
on
of Linus' tree.  The same line in my development tree reads:

        if ((goal->options & PPR_OPT_MASK) || (goal->period < 0xa)) {

Does it still work if you use that?  The problem with Frage Schnell's
patch is that it won't try to negotiate U160 speeds; it'll be capped
at U80.

--=20
"Next the statesmen will invent cheap lies, putting the blame upon=20
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refu=
se
to examine any refutations of them; and thus he will by and by convince=
=20
himself that the war is just, and will thank God for the better sleep=20
he enjoys after this process of grotesque self-deception." -- Mark Twai=
n
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
