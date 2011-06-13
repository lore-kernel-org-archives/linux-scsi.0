From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 0/8] M68k SCSI compile warning fixes
Date: Mon, 13 Jun 2011 20:41:08 +0200
Message-ID: <BANLkTimBan7tqAOA8rN8Encoi_rWQJfuYQ@mail.gmail.com>
References: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

[corrected the subject]

=C2=A0 =C2=A0 =C2=A0 =C2=A0Hi James,

These patches fix several compile warnings on m68k.
As I don't have the hardware, I couldn't run test them, though.

=C2=A0b/drivers/scsi/atari_NCR5380.c | =C2=A0 =C2=A05 +++
=C2=A0b/drivers/scsi/atari_scsi.c =C2=A0 =C2=A0| =C2=A0 =C2=A01
=C2=A0b/drivers/scsi/mac_scsi.c =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A02 -
=C2=A0b/drivers/scsi/sun3_NCR5380.c =C2=A0| =C2=A0 =C2=A02 -
=C2=A0b/drivers/scsi/sun3_scsi.c =C2=A0 =C2=A0 | =C2=A0 =C2=A02 -
=C2=A0b/drivers/scsi/sun3_scsi_vme.c | =C2=A0 =C2=A02 -
=C2=A0drivers/scsi/mac_scsi.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 12 --=
-----
=C2=A0drivers/scsi/sun3_NCR5380.c =C2=A0 =C2=A0| =C2=A0 65 +++---------=
-----------------------------
=C2=A0drivers/scsi/sun3_scsi.c =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A09 ++=
++-
=C2=A0drivers/scsi/sun3_scsi_vme.c =C2=A0 | =C2=A0 =C2=A09 ++++-
=C2=A010 files changed, 31 insertions(+), 78 deletions(-)

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
