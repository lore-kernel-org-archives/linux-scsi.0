From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] libata (Serial ATA) update
Date: Mon, 1 Dec 2003 12:15:27 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20031201171527.GA23280@gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Some more bug fixes:
* Use sg_dma_xxx macros.  Fixes "doesn't build" on some non-x86
  platforms, and fixes "doesn't work" on some other non-x86 platforms.
* Fix for Promise SX4

Patch for 2.4.23:
http://www.kernel.org/pub/linux/kernel/people/jgarzik/libata/2.4.23-libata1.patch.bz2

Patch for 2.6.0-test11:
http://www.kernel.org/pub/linux/kernel/people/jgarzik/libata/2.6.0-test11-libata1.patch.bz2

BK users:
http://gkernel.bkbits.net/libata-2.[45]
