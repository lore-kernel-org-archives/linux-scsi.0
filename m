From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.16-rc5
Date: Tue, 28 Feb 2006 11:30:47 -0600
Message-ID: <1141147847.3258.19.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:43730 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932283AbWB1Rax (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 12:30:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

This represents the current batch of outstanding bug fixes (mostly
driver bug fixes, but one mid-layer update to support fixing a driver
bug).

The patch is available from:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The Short changelog is:

Andrew Vasquez:
  o fc_transport: stop creating duplicate rport entries

Brian King:
  o scsi: scsi command retries off by one fix
  o sg: Remove aha1542 hack

Christoph Hellwig:
  o megaraid_sas: fix physical disk handling
  o scsi: handle ->slave_configure return value

J=EF=BF=BDgen E. Fischer:
  o aha152x: fix variable use before initialisation and other bugs

Matthew Wilcox:
  o Fix uninitialised width and speed in sym2

Ralf B=EF=BF=BDhle:
  o Delete duplicate driver template

And the diffstat:

 aha152x.c               |   85 +++++++++++++++++++++++++++++----------=
---------
 aha152x.h               |    2 -
 jazz_esp.c              |   21 -----------
 megaraid/megaraid_sas.c |   29 ++++++++--------
 pcmcia/aha152x_stub.c   |    4 --
 scsi_error.c            |    4 +-
 scsi_lib.c              |    2 -
 scsi_scan.c             |   16 +++++++--
 scsi_transport_fc.c     |    3 -
 sg.c                    |    2 -
 sym53c8xx_2/sym_hipd.c  |    2 +
 11 files changed, 90 insertions(+), 80 deletions(-)

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
