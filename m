From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: Help - looking for a Linux SCSI testing utility
Date: 25 May 2004 09:30:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085499008.9003.55.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:32934 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264790AbUEYPaP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 May 2004 11:30:15 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> http://members.aol.com/plscsi/linux/plscsi.tar.gz

Thanks to Randy D for that direct link, also to the two offline
volunteers who drew me into this thread.

> When we were working on Windows platform, we
> had a couple of tools that can issue selected
> SCSI command(s) to selected device(s). 

plscsi is for dos/ linux/ mac/ windows/ solaris/ ....  The introductory
plscsi page recently built at linux-ide now is:

http://members.aol.com/plscsi/linux/

Clicking back thru the archived "previous editions" I see along the way
I lost the cross-references of:

http://members.aol.com/plscsi/linux/index.200312.html

Specifically:

man dd for read/write wherever on disk e.g. erasing disks
e.g. sudo dd if=/dev/hda0 skip=0 count=1 | strings

man fdisk for editing Microsoft partition tables
...

MTX for SCSI ... Device Control
http://mtx.badtux.net/

scu a SCSI Command Utility 
http://www.bit-net.com/~rmiller/scu.html

Enjoy, Pat LaVarre


