From: Pat LaVarre <p.lavarre@ieee.org>
Subject: bytes/CDB of SCSI pass thru grossly limited maybe
Date: 30 Jul 2004 17:04:12 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1091228652.6845.1.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:53651 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264531AbUG3XEq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jul 2004 19:04:46 -0400
Received: from royntex01.iomegacorp.com (edison [10.1.1.82])
	by email.iomega.com (Postfix) with ESMTP id 5EB6F37EC
	for <linux-scsi@vger.kernel.org>; Fri, 30 Jul 2004 17:04:46 -0600 (MDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Offline a friend reports seeing bytes/CDB of Linux ioctl SG_IO grossly
limited - like down below 0.000000128 GB/CDB for op x3B "WRITE BUFFER".

I'm writing now to give this audience the chance to comment.

Left to myself, I'll hope to work to reproduce that result, compare USB/
PATAPI/ FireWire/ SATAPI, try the alternative of ioctl
CDROM_SEND_PACKET, ... and report back here if/when I discover anything
interesting.

I remember seeing talk of tweaking the kernel to choke off the default
kernel thruput whenever status/ command overhead is high, but before now
I don't remember hearing of choking off SCSI pass thru as well.

Pat LaVarre
http://linux-pel.blog-city.com/read/752705.htm


