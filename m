From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [-next] m68k proc_ops breakage
Date: Mon, 26 Mar 2012 22:06:14 +0200
Message-ID: <CAMuHMdVQ9pxfRz899KVdAHhcspnhYU_H5DRCwRcsQY8cpZUqZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>, James Bottomley <JBottomley@Parallels.com>
Cc: scsi <linux-scsi@vger.kernel.org>, Linux-Next <linux-next@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

m68k/defconfig:

In file included from drivers/scsi/atari_scsi.c:1091:
drivers/scsi/atari_NCR5380.c: In function =E2=80=98NCR5380_print_status=
=E2=80=99:
drivers/scsi/atari_NCR5380.c:736: error: implicit declaration of
function =E2=80=98NCR5380_proc_info=E2=80=99
drivers/scsi/atari_NCR5380.c: At top level:
drivers/scsi/atari_NCR5380.c:767: error: static declaration of
=E2=80=98NCR5380_proc_info=E2=80=99 follows non-static declaration
drivers/scsi/atari_NCR5380.c:736: error: previous implicit declaration
of =E2=80=98NCR5380_proc_info=E2=80=99 was here
make[1]: *** [drivers/scsi/atari_scsi.o] Error 1


m68k/sun3_defconfig:

In file included from drivers/scsi/sun3_scsi.c:628:
drivers/scsi/sun3_NCR5380.c: In function =E2=80=98NCR5380_print_status=E2=
=80=99:
drivers/scsi/sun3_NCR5380.c:678: error: implicit declaration of
function =E2=80=98sun3scsi_proc_info=E2=80=99
drivers/scsi/sun3_NCR5380.c: At top level:
drivers/scsi/sun3_NCR5380.c:709: error: static declaration of
=E2=80=98sun3scsi_proc_info=E2=80=99 follows non-static declaration
drivers/scsi/sun3_NCR5380.c:678: error: previous implicit declaration
of =E2=80=98sun3scsi_proc_info=E2=80=99 was here
make[1]: *** [drivers/scsi/sun3_scsi.o] Error 1

In file included from drivers/scsi/sun3_scsi_vme.c:571:
drivers/scsi/sun3_NCR5380.c: In function =E2=80=98NCR5380_print_status=E2=
=80=99:
drivers/scsi/sun3_NCR5380.c:678: error: implicit declaration of
function =E2=80=98sun3scsi_proc_info=E2=80=99
drivers/scsi/sun3_NCR5380.c: At top level:
drivers/scsi/sun3_NCR5380.c:709: error: static declaration of
=E2=80=98sun3scsi_proc_info=E2=80=99 follows non-static declaration
drivers/scsi/sun3_NCR5380.c:678: error: previous implicit declaration
of =E2=80=98sun3scsi_proc_info=E2=80=99 was here
make[1]: *** [drivers/scsi/sun3_scsi_vme.o] Error 1


http://kisskb.ellerman.id.au/kisskb/buildresult/5967959/
http://kisskb.ellerman.id.au/kisskb/buildresult/5967969/

Gr{oetje,eeting}s,

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org

In personal conversations with technical people, I call myself a hacker=
=2E But
when I'm talking to journalists I just say "programmer" or something li=
ke that.
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =C2=A0=C2=A0 -- Linus Torvalds
