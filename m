From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [BK PATCH] SCSI update for 2.6.3
Date: 23 Feb 2004 22:24:27 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077596668.1983.282.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:50836 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262153AbUBXEYb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Feb 2004 23:24:31 -0500
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

The current crop of accumulated patches are mainly driver updates and
bug fixes.

It is available at

bk://linux-scsi.bkbits.net/scsi-for-linus

The short changelog is:

<brking:us.ibm.com>:
  o SCSI: Make retries obey host_self_blocked flag

Andrew Vasquez:
  o qla2xxx -- FCP_RSP IU check during command completion
  o qla2xxx -- Properly schedule mailbox command timeouts

Christoph Hellwig:
  o move remaining definitions from drivers/scsi/scsi.h to include/scsi
  o fix up NCR5380 private data
  o fix up ini9100 interrupt handling
  o Remove CONFIG_SCSI_DC390T_NOGENSUPP
  o remove flush_cache_all() from qla1280

David S. Miller:
  o qla2xxx: remove flush_cache_all

Geert Uytterhoeven:
  o Sun-3x ESP SCSI clean up
  o NCR53C9x slave_{alloc,destroy}()

James Bottomley:
  o SCSI: 53c700: reduce default tag depth to 4
  o MPT Fusion driver 3.00.03 update

Kai M=E4kisara:
  o Sysfs class support for SCSI tapes

Mark Haverkamp:
  o aacraid reset handler
  o add card types to aacraid driver

Patrick Mansfield:
  o have CONFIG_SCSI_PROC_FS depend on CONFIG_PROC_FS

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
