From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [BK PATCH] bug fixes for scsi for linux-2.6.3-rc1
Date: 08 Feb 2004 11:14:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076256895.2055.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:31643 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263771AbUBHQPJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 8 Feb 2004 11:15:09 -0500
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

The BK tree at

bk://linux-scsi.bkbits.net/scsi-for-linus-2.6

contains four bugfixes for the previous update (actually allow the
qla2xxx to build as part of the build process and remove its compile
warnings, fix the mptscsih_exit() discard problem and undelete the
qlogicfc driver).

The short changelog is:

Andrew Morton:
  o Fix qla2xxx warnings

Andrew Vasquez:
  o qla2xxx Kconfig fix

James Bottomley:
  o mpt fusion fix mptscsih_exit() discard
  o SCSI: undelete qlogicfc driver


James


