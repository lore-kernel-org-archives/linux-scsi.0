From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [build failure] Re: [GIT PULL] First round of SCSI updates for
 2.6.38 merge window
Date: Mon, 21 Mar 2011 11:33:31 -0500
Message-ID: <1300725211.10634.20.camel@mulgrave.site>
References: <1300392635.17266.5.camel@mulgrave.site>
	 <20110321122111.GA17237@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110321122111.GA17237@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-03-21 at 13:21 +0100, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@suse.de> wrote:
>=20
> > This represents the usual round of driver updates (fcoe, lpfc,
> qla2xxx, > zfcp, bnx2i, mpt2sas, megaraid_sas, iscsi, cxgbi and hpsa)
> plus one new > driver (bnx2fc) and as a bonus we move libsas from the
> old libata eh to > the new one paving the way for junking the old one
> (once we can get ipr > converted).
>=20
> The new bnx2fc driver does not build with module support disabled:
>=20
>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815:17: error: dereferencing
> pointer to incomplete type  drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815:28=
:
> error: =E2=80=98MODULE_STATE_LIVE=E2=80=99 undeclared (first use in t=
his function)
>   drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1878:17: error: dereferencing
> pointer to incomplete type  drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1878:28=
:
> error: =E2=80=98MODULE_STATE_LIVE=E2=80=99 undeclared (first use in t=
his function)
>=20
> and this build breakage has been reported to you two weeks ago:
>=20
>  http://lkml.org/lkml/2011/3/2/468

The actual fix is here:

http://git.kernel.org/?p=3Dlinux/kernel/git/jejb/scsi-misc-2.6.git;a=3D=
commit;h=3De81460b20107ae83a7541d12b14114ea731a86fc

it just took time to secure agreement on this.  The ultimate fixes to
=46CoE will be in the next merge window.

James
