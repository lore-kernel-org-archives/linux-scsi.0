From: Radovan Garabik <garabik@kassiopeia.juls.savba.sk>
Subject: Re: [usb-storage] Re: MPIO HS200 Gigabox weird behaviour again
Date: Wed, 16 Feb 2005 15:37:14 +0100
Message-ID: <20050216143714.GA11363@kassiopeia.juls.savba.sk>
References: <1108138682.5773.23.camel@mulgrave> <Pine.LNX.4.44L0.0502111326540.937-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Received: from kassiopeia.juls.savba.sk ([147.213.138.8]:3566 "EHLO
	kassiopeia.juls.savba.sk") by vger.kernel.org with ESMTP
	id S262024AbVBPOgw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2005 09:36:52 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0502111326540.937-100000@ida.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org

On Fri, Feb 11, 2005 at 01:31:30PM -0500, Alan Stern wrote:
=2E..

>=20
> Radovan: Below is an updated version of the patch James mentioned, wi=
th an
> entry included for your Gigabox drive.  It's meant to apply to
> 2.6.11-rc3-bk5, but it will probably go with older kernels too.  Try =
it
> out and let me know how it works.  If it solves your problem, I'll su=
bmit
> it for inclusion in the official kernel.

I tried it (with 2.6.10), and it really seems to solve the
problems (though I made just a few test so far).

thanks a lot

P.S. Just FYI, I tried the ub driver, it seems to suffer from the same =
symptoms...

--=20
 -----------------------------------------------------------
| Radovan Garab=EDk http://melkor.dnp.fmph.uniba.sk/~garabik/ |
| __..--^^^--..__    garabik @ kassiopeia.juls.savba.sk     |
 -----------------------------------------------------------
Antivirus alert: file .signature infected by signature virus.
Hi! I'm a signature virus! Copy me into your signature file to help me =
spread!
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
