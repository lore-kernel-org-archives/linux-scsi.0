From: Jeff Garzik <jgarzik@pobox.com>
Subject: libata update posted
Date: Tue, 12 Aug 2003 23:40:42 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3F39B33A.2050709@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Well, I was hoping to complete another low-level driver (Silicon Image) 
out there, but I would rather get bug fixes out first :)

libata driver architecture version 0.70 (helper library)
Intel ICH5 SATA driver version 0.93

Patch for 2.4.21:
ftp://ftp.??.kernel.org/pub/linux/kernel/people/jgarzik/patchkits/2.4/2.4.21-libata5.patch.bz2

Patch for 2.6.0-test3:
ftp://ftp.??.kernel.org/pub/linux/kernel/people/jgarzik/patchkits/2.6/2.6.0-test3-bk1-libata1.patch.bz2

Stressed on both 2.4 and 2.6, SMP and UP, lba2[48] and lba48.

Changes:
* lba48 fix
* SMP fixes
* locking sanitization
* locking documentation ("make pdfdocs")
* more infrastructure for command queueing and async taskfiles

Notes:
* Parallel ATA limited to UDMA/33 (SATA is full speed)
* ATAPI not ready for prime time

Still no data-corrupting bugs, knock on wood.
