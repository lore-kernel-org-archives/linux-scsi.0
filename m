From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: [PATCH 0/2] Stop disks on reboot for laptop which cuts power
Date: Sat, 18 Apr 2009 12:44:15 +0200
Message-ID: <20090418124415.1dc82273@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Linux IDE <linux-ide@vger.kernel.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

During shutdown (power off) the disks are stopped gracefully thus the
stopping is skipped for reboot case.

On my Acer Travelmate 660 reboot is more like power-off as it cuts all
power during reboot which currently causes the disk to emergency-park
its head (noisy and shortens disk life).

This patch series adds a DMI-based check to ide-gd and sd to still
stop the disks for affected laptop during reboot.

Has been compile an run-tested with libata and just compile-tested for
ide.

Bruno Pr=C3=A9mont
