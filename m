From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [GIT PULL] First round of SCSI updates for 2.6.38 merge window
Date: Tue, 22 Mar 2011 08:59:14 -0400
Message-ID: <x49zkons44d.fsf@segfault.boston.devel.redhat.com>
References: <1300392635.17266.5.camel@mulgrave.site>
	<AANLkTinvwKzYiy5M=Eoae_ViRQwVBF-TgedKspP0qagE@mail.gmail.com>
	<yq1fwqfu6dd.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1fwqfu6dd.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Tue, 22 Mar 2011 00:27:42 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, James Bottomley <James.Bottomley@suse.de>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

>>>>>> "Geert" =3D=3D Geert Uytterhoeven <geert@linux-m68k.org> writes:
>
> Geert> drivers/scsi/sd.c: In function =E2=80=98sd_prep_fn=E2=80=99:
> Geert> drivers/scsi/sd.c:544: warning: =E2=80=98ret=E2=80=99 may be u=
sed uninitialized
> Geert> in this function
>
> Sorry about that.
>
>
> sd: Fail discard requests when logical block provisioning has been di=
sabled
>
> Ensure that we kill discard requests after logical block provisioning
> has been disabled in sysfs.
>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>

Tao Ma posted a similar patch.  Anyway, either looks good to me.  This
one will avoid an unecessary extra setting of ret, but I doubt that
matters.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
