From: Thomas Beutin <tyrone@laokoon.IN-Berlin.DE>
Subject: AIC7902 lockups
Date: Mon, 11 Aug 2003 14:36:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030811143610.A19365@laokoon.bug.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hirsch.in-berlin.de ([192.109.42.6]:63917 "EHLO
	hirsch.in-berlin.de") by vger.kernel.org with ESMTP id S272521AbTHKMkH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2003 08:40:07 -0400
Received: from hirsch.in-berlin.de (localhost [127.0.0.1])
	by hirsch.in-berlin.de (8.12.9/8.12.9/Debian-1) with ESMTP id h7BCe5xG026749
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2003 14:40:05 +0200
Received: (from uucp@localhost)
	by hirsch.in-berlin.de (8.12.9/8.12.9/Debian-1) with UUCP id h7BCe56s026746
	for linux-scsi@vger.kernel.org; Mon, 11 Aug 2003 14:40:05 +0200
Received: (from tyrone@localhost)
	by laokoon.bug.net (8.9.3/8.9.3) id OAA31844
	for linux-scsi@vger.kernel.org; Mon, 11 Aug 2003 14:36:10 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

sorry for asking again, but my problem with two disks connected
to an Adaptec AIC7902 still exists. Any help to solve the
annoying problem or hints are greatly appreciated.

Actually i'm using a vanilla linux kernel (2.4.21) with the
aic79xx-1.3.10 source unpacked on the right place in the kernel
sources. The kernel is compiled with SMP support (a complete
.config from the running kernel is available at
http://laokoon.in-berlin.de/~beutin/kernel-config.gz).

Three disks are connected to the first channel of the onboard
Adaptec AIC7902 of the Intel SE7501HG2 board (/proc/scsi/scsi):
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: IBM      Model: IC35L036UCPR15-0 Rev: S70H
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: FUJITSU  Model: MAP3367NC        Rev: 0105
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 02 Lun: 00
  Vendor: FUJITSU  Model: MAP3367NC        Rev: 0105
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 06 Lun: 00
  Vendor: ESG-SHV  Model: SCA HSBP M15     Rev: 0.10
  Type:   Processor                        ANSI SCSI revision: 02

The first disk works perfect and the system starts up fine (only the
first disks file systems are in /etc/fstab). dmesg output looks
ok (is pretty long, You can find it on 
http://laokoon.in-berlin.de/~beutin/dmesg-after-boot.log.gz)

After accessing one of the FUJITSU disks the system hangs and the
dmesg output shows a lot of "DevQ(0:?:0): 0 waiting" and
card state dumps (the output is long, You can find it on
http://laokoon.in-berlin.de/~beutin/dmesg-mount-try.gz).

What can i do? Do i have any chance to get a stable system with
all three disks useable?

Thanks for reading and any suggestions!

Greetings,
-tb
-- 
Thomas Beutin                             tb@laokoon.IN-Berlin.DE
Beam me up, Scotty. There is no intelligent live down in Redmond.
