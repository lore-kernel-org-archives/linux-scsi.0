From: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>
Subject: =?UTF-8?Q?Maxtor_USB_disk_=E2=80=93_=22UNKNOWN=280x2003=29_Result=22_message?=
        =?UTF-8?Q?s_logged?=
Date: Mon, 24 Oct 2016 09:08:42 +0300
Message-ID: <CAPWNY8UvHmmwAs9t3etm_+0hnjii19a0MteaR1rWp36d4n9yxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:34871 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752429AbcJXGJA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2016 02:09:00 -0400
Received: by mail-lf0-f43.google.com with SMTP id f134so22232283lfg.2
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2016 23:08:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Apologies if I'm posting to the wrong place; this is where I was
pointed to the last time I had USB storage questions.

I have a Maxtor (Seagate) "D3 Station" USB 3.0 SATA disk (0bc2:6125).
While it appears to work completely fine, every now and then the
following are logged in dmesg:

[Oct20 01:00] sd 3:0:0:0: [sdb] tag#0 UNKNOWN(0x2003) Result:
hostbyte=3D0x07 driverbyte=3D0x08
[  +0.000004] sd 3:0:0:0: [sdb] tag#0 Sense Key : 0x4 [current] [descriptor=
]
[  +0.000003] sd 3:0:0:0: [sdb] tag#0 ASC=3D0x0 ASCQ=3D0x0
[  +0.000003] sd 3:0:0:0: [sdb] tag#0 CDB: opcode=3D0x85 85 06 20 00 00
00 00 00 00 00 00 00 00 00 e5 00

[  +0.137088] sd 3:0:0:0: [sdb] tag#0 UNKNOWN(0x2003) Result:
hostbyte=3D0x07 driverbyte=3D0x08
[  +0.000003] sd 3:0:0:0: [sdb] tag#0 Sense Key : 0x4 [current] [descriptor=
]
[  +0.000002] sd 3:0:0:0: [sdb] tag#0 ASC=3D0x0 ASCQ=3D0x0
[  +0.000002] sd 3:0:0:0: [sdb] tag#0 CDB: opcode=3D0xa1 a1 06 20 da 00
00 4f c2 00 b0 00 00

When using smartctl (--health --device=3Dsat), a similar message is also lo=
gged:

[Oct20 01:09] sd 3:0:0:0: [sdb] tag#0 UNKNOWN(0x2003) Result:
hostbyte=3D0x07 driverbyte=3D0x08
[  +0.000004] sd 3:0:0:0: [sdb] tag#0 Sense Key : 0x4 [current] [descriptor=
]
[  +0.000001] sd 3:0:0:0: [sdb] tag#0 ASC=3D0x0 ASCQ=3D0x0
[  +0.000003] sd 3:0:0:0: [sdb] tag#0 CDB: opcode=3D0x85 85 06 2c 00 da
00 00 00 00 00 4f 00 c2 00 b0 00

Are those the sign of a hardware problem or a kernel bug? (I'm running
4.8.2 at the moment.)

--=20
Mantas Mikul=C4=97nas <grawity@gmail.com>
