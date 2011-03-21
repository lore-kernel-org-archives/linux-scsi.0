From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [build failure] Re: [GIT PULL] First round of SCSI updates for
 2.6.38 merge window
Date: Mon, 21 Mar 2011 18:59:34 +0100
Message-ID: <20110321175934.GA4849@elte.hu>
References: <1300392635.17266.5.camel@mulgrave.site>
 <20110321122111.GA17237@elte.hu>
 <1300725211.10634.20.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:36122 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004Ab1CUR7i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2011 13:59:38 -0400
Content-Disposition: inline
In-Reply-To: <1300725211.10634.20.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>


* James Bottomley <James.Bottomley@suse.de> wrote:

> On Mon, 2011-03-21 at 13:21 +0100, Ingo Molnar wrote:
> > * James Bottomley <James.Bottomley@suse.de> wrote:
> >=20
> > > This represents the usual round of driver updates (fcoe, lpfc,
> > qla2xxx, > zfcp, bnx2i, mpt2sas, megaraid_sas, iscsi, cxgbi and hps=
a)
> > plus one new > driver (bnx2fc) and as a bonus we move libsas from t=
he
> > old libata eh to > the new one paving the way for junking the old o=
ne
> > (once we can get ipr > converted).
> >=20
> > The new bnx2fc driver does not build with module support disabled:
> >=20
> >  drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815:17: error: dereferencing
> > pointer to incomplete type  drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815:=
28:
> > error: =E2=80=98MODULE_STATE_LIVE=E2=80=99 undeclared (first use in=
 this function)
> >   drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1878:17: error: dereferencing
> > pointer to incomplete type  drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1878:=
28:
> > error: =E2=80=98MODULE_STATE_LIVE=E2=80=99 undeclared (first use in=
 this function)
> >=20
> > and this build breakage has been reported to you two weeks ago:
> >=20
> >  http://lkml.org/lkml/2011/3/2/468
>=20
> The actual fix is here:
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/jejb/scsi-misc-2.6.git;a=3D=
commit;h=3De81460b20107ae83a7541d12b14114ea731a86fc

This too does the trick.

Thanks,

	Ingo
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
