From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bug 6009] tcpdump causes kernel panic
Date: Sat, 4 Feb 2006 10:54:50 -0800
Message-ID: <20060204105450.0c4d7e24.akpm@osdl.org>
References: <200602041838.k14Ic4Pi028741@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:55764 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751520AbWBDSzX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Feb 2006 13:55:23 -0500
In-Reply-To: <200602041838.k14Ic4Pi028741@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, Adam Radford <linuxraid@amcc.com>

bugme-daemon@bugzilla.kernel.org wrote:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=6009

This 2.6.15 kernel has some 3ware problems:

messages.4:Jan  6 12:15:41 chilsp010 kernel: 3w-9xxx: scsi0: AEN: INFO (0x04:0x0053): Battery capacity test is overdue:.
messages.4:Jan  6 12:15:41 chilsp010 kernel: scsi0 : 3ware 9000 Storage Controller
messages.4:Jan  6 12:15:41 chilsp010 kernel: 3w-9xxx: scsi0: Found a 3ware 9000 Storage Controller at 0xfeaffc00, IRQ: 217.
messages.4:Jan  6 12:15:41 chilsp010 kernel: 3w-9xxx: scsi0: Firmware FE9X 2.06.00.009, BIOS BE9X 2.03.01.051, Ports: 8.
messages.4:Jan  6 12:15:41 chilsp010 kernel:   Vendor: AMCC      Model: 9500S-8    DISK   Rev: 2.06
messages.4:Jan  6 12:15:41 chilsp010 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 03
messages.4:Jan  6 12:15:41 chilsp010 kernel: SCSI device sda: 390602752 512-byte hdwr sectors (199989 MB)
messages.4:Jan  6 12:15:41 chilsp010 kernel: SCSI device sda: drive cache: write back, no read (daft)
messages.4:Jan  6 12:15:41 chilsp010 kernel:  sda: sda1 sda2
messages.4:Jan  6 12:15:41 chilsp010 kernel: Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
messages.4:Jan  6 12:15:41 chilsp010 kernel: scsi: On host 0 channel 0 id 0 only 511 (max_scsi_report_luns) of 493425154 luns reported, try increasing max_scsi_report_luns.
messages.4:Jan  6 12:15:41 chilsp010 kernel: scsi: host 0 channel 0 id 0 lun 0xb0b800008ed88ec0 has a LUN larger than currently supported.
messages.4:Jan  6 12:15:41 chilsp010 kernel: scsi: host 0 channel 0 id 0 lun 0xfbbe007cbf0006b9 has a LUN larger than currently supported.
messages.4:Jan  6 12:15:41 chilsp010 kernel: scsi: host 0 channel 0 id 0 lun 0x0002f3a4ea210600 has a LUN larger than currently supported.
messages.4:Jan  6 12:15:41 chilsp010 kernel: scsi: host 0 channel 0 id 0 lun 0x00bebe073804750b has a LUN larger than currently supported.
messages.4:Jan  6 12:15:41 chilsp010 kernel: scsi: host 0 channel 0 id 0 lun 0x83c61081fefe0775 has a LUN larger than currently supported.
messages.4:Jan  6 12:15:41 chilsp010 kernel: scsi: host 0 channel 0 id 0 lun 0xf3eb16b402b001bb has a LUN larger than currently supported.
messages.4:Jan  6 12:15:41 chilsp010 kernel: scsi: host 0 channel 0 id 0 lun 0x007cb2808a740302 has a LUN larger than currently supported.
messages.4:Jan  6 12:15:41 chilsp010 kernel: scsi: host 0 channel 0 id 0 lun 0x8000008041c80100 has a LUN larger than currently supported.
messages.4:Jan  6 12:15:41 chilsp010 kernel: scsi: host 0 channel 0 id 0 lun 0x0008fa80ca80ea53 has a LUN larger than currently supported.
messages.4:Jan  6 12:15:41 chilsp010 kernel: scsi: host 0 channel 0 id 0 lun 0x7c000031c08ed88e has a LUN larger than currently supported.
messages.4:Jan  6 12:15:41 chilsp010 kernel: scsi: host 0 channel 0 id 0 lun 0xd0bc0020fba0407c has a LUN larger than currently supported.


Donny, I think we have two separate bugs here, but we won't be able tell
until you've been able to get us a copy of the oops output.

