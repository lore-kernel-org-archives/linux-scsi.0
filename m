From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [BK PATCH] SCSI Bugfixes for 2.6.0-test9
Date: 19 Nov 2003 14:33:31 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069270260.1664.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:25606 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264073AbTKSUdz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 15:33:55 -0500
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This contains the current slew of bug fixes harvested from the scsi
mailing lists.  I think we could still do with getting our
slave_alloc/destroy bug sorted out, and finally getting our mid layer
refcounting up to the level where were robust against surprise ejection,
but those could also wait for 2.6.1

You can pull the changes from:

bk://linux-scsi.bkbits.net/scsi-bugfixes-2.6

The short changelogs are:

Alan Stern:
  o Off-by-one bug in user page calculations for Direct I/O

Andrew Morton:
  o fix scsi_report_lun_scan bug

Christoph Hellwig:
  o scsi_device refcounting and list lockdown

James Bottomley:
  o Add missing .module initialisation to lasi700 and sim710
  o lasi700: Fix missed variable name change causing module load error

James

