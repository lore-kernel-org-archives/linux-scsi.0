From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [BK PATCH] SCSI driver updates
Date: 15 Jan 2004 13:03:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074189825.1868.128.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:46778 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265163AbUAOSDx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2004 13:03:53 -0500
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

This patch is essentially just driver fixes and updates.

The big new item is the inclusion of the qla2xxx driver.  This has been
requested for a long time and we've been working for quite a while to
get it into an acceptable form.  The piece selected for inclusion is
just the actual driver, without either the failover component or suppor=
t
for the qlogic specific fabric ioctls.

I've also included most of the -mmX scsi patches.

The patch is available from

bk://linux-scsi.bkbits.net/scsi-misc-2.7

And the short changelog is:

<patmans:ibm.com>:
  o Re: 2.6.1-rc1: SCSI: `TIMEOUT' redefined

Adrian Bunk:
  o qla1280.c doesn't compile

Arjan van de Ven:
  o fix a few missing return value checks in scsi

Christoph Hellwig:
  o fix inia100 driver

David Jeffery:
  o ips fix for large mem 64bit machines
  o ips 2/2: minor fixes

James Bottomley:
  o Fix qla2xxx Kconfig dependency problem
  o Import qla2xxx driver
  o g_NCR5380 - 2.6.0 -  problem with reloading module
  o NCR53C9x SCSI: Kill bogus inline
  o Amiga NCR53c710: Coalesce all configuration options into one
  o BVME6000 SCSI: Fix typos
  o ncr53c7xx: Cleanup prototypes
  o Mac SCSI fixes (from Matthias Urlichs)
  o Update Mac ESP SCSI
  o Fix sym2 Ultra160 mode
  o sym2 speed selection fix
  o another aic7xxx_old proc fix
  o repair oops in aic7xxx_old proc_info
  o aacraid warning fix
  o SCSI sg,st block layer TCQ fix
  o SCSI: atp870u update
  o 64 bit updates for Workbit NinjaSCSI driver

Jes Sorensen:
  o qla1280

J=FCrgen E. Fischer:
  o Kernel oops in 2.6.1 when loading aha152x_cs.ko

Martin Hicks:
  o Call slave_destroy in scsi_alloc_sdev error path

Matthew Wilcox:
  o Re: Building sym 2.1.18f on linux/alpha

Mike Christie:
  o Initio 9100u


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
