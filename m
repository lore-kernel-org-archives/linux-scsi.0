From: Pat LaVarre <p.lavarre@ieee.org>
Subject: printk the cdb's that interest me
Date: 23 Sep 2003 09:40:42 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064331642.10473.23.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:45531 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262021AbTIWPkJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2003 11:40:09 -0400
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id A60EA1AA0
	for <linux-scsi@vger.kernel.org>; Tue, 23 Sep 2003 09:40:08 -0600 (MDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Can I somehow easily trace only all the scsi cdb's that fail?

How about a patch to trace only the cdb's that fail between the sk asc =
x 6 28 GoneReady of disc insertion and the sk asc = x 2 3A DiskAbsent?

I'm guessing I have to reach down into usb-storage, ide-cd, ide-scsi
etc. to find a line of code thru which all cdb's pass.  I see
CONFIG_USB_STORAGE_DEBUG=y gives me all cdb's and so much more besides
that often I run with =n.  I want only cdb's that interest me to
distract me from my other printk.

I'm slow to believe I'm alone in wanting this - can I really be the
first to try to code it?  I'm motivated specifically by having no
confident interpretation of such existing printk as:

lost page write due to I/O error on sr1
SCSI error : <2 0 0 0> return code = 0x10000
end_request: I/O error, dev sr1, sector 54044096
Buffer I/O error on device sr1, logical block 6755512

1) I think I get these for less than all interesting errors.

In particular, I think I don't see not-retried unit attentions reported
this way, even though unit attentions change such things as the
2.6.0-test4 /proc/sys/dev/cdrom/info

2) I have no confident idea of what the cdb was, and zero idea of what
the auto-sensed sk asc ascq info was.

Pat LaVarre



