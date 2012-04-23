From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [-next] m68k proc_ops breakage
Date: Mon, 23 Apr 2012 19:22:02 +0100
Message-ID: <1335205322.4191.27.camel@dabdike.lan>
References: <CAMuHMdVQ9pxfRz899KVdAHhcspnhYU_H5DRCwRcsQY8cpZUqZw@mail.gmail.com>
	 <1332832945.2883.5.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1332832945.2883.5.camel@dabdike>
Sender: linux-next-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, scsi <linux-scsi@vger.kernel.org>, Linux-Next <linux-next@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-03-27 at 07:22 +0000, James Bottomley wrote:
> On Mon, 2012-03-26 at 22:06 +0200, Geert Uytterhoeven wrote:
> > m68k/defconfig:
> >=20
> > In file included from drivers/scsi/atari_scsi.c:1091:
> > drivers/scsi/atari_NCR5380.c: In function =E2=80=98NCR5380_print_st=
atus=E2=80=99:
> > drivers/scsi/atari_NCR5380.c:736: error: implicit declaration of
> > function =E2=80=98NCR5380_proc_info=E2=80=99
> > drivers/scsi/atari_NCR5380.c: At top level:
> > drivers/scsi/atari_NCR5380.c:767: error: static declaration of
> > =E2=80=98NCR5380_proc_info=E2=80=99 follows non-static declaration
> > drivers/scsi/atari_NCR5380.c:736: error: previous implicit declarat=
ion
> > of =E2=80=98NCR5380_proc_info=E2=80=99 was here
> > make[1]: *** [drivers/scsi/atari_scsi.o] Error 1
> >=20
> >=20
> > m68k/sun3_defconfig:
> >=20
> > In file included from drivers/scsi/sun3_scsi.c:628:
> > drivers/scsi/sun3_NCR5380.c: In function =E2=80=98NCR5380_print_sta=
tus=E2=80=99:
> > drivers/scsi/sun3_NCR5380.c:678: error: implicit declaration of
> > function =E2=80=98sun3scsi_proc_info=E2=80=99
> > drivers/scsi/sun3_NCR5380.c: At top level:
> > drivers/scsi/sun3_NCR5380.c:709: error: static declaration of
> > =E2=80=98sun3scsi_proc_info=E2=80=99 follows non-static declaration
> > drivers/scsi/sun3_NCR5380.c:678: error: previous implicit declarati=
on
> > of =E2=80=98sun3scsi_proc_info=E2=80=99 was here
> > make[1]: *** [drivers/scsi/sun3_scsi.o] Error 1
> >=20
> > In file included from drivers/scsi/sun3_scsi_vme.c:571:
> > drivers/scsi/sun3_NCR5380.c: In function =E2=80=98NCR5380_print_sta=
tus=E2=80=99:
> > drivers/scsi/sun3_NCR5380.c:678: error: implicit declaration of
> > function =E2=80=98sun3scsi_proc_info=E2=80=99
> > drivers/scsi/sun3_NCR5380.c: At top level:
> > drivers/scsi/sun3_NCR5380.c:709: error: static declaration of
> > =E2=80=98sun3scsi_proc_info=E2=80=99 follows non-static declaration
> > drivers/scsi/sun3_NCR5380.c:678: error: previous implicit declarati=
on
> > of =E2=80=98sun3scsi_proc_info=E2=80=99 was here
> > make[1]: *** [drivers/scsi/sun3_scsi_vme.o] Error 1
>=20
> Yes, the proc_ops conversion isn't quite ready.  I'll hold it over to
> the next merge window so we can fix stuff like this.

OK, so I'd like to try pushing the proc-ops fixes for the next merge
window, but I think I'm still missing the fix for this.

James
