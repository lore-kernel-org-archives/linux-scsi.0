From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH]:Amended:Allow random write for PDT 5 profile 2
	Removable Disk
Date: 06 Mar 2004 10:16:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1078593406.2006.4.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:24020 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261692AbUCFRSy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Mar 2004 12:18:54 -0500
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 81B811910
	for <linux-scsi@vger.kernel.org>; Sat,  6 Mar 2004 10:18:53 -0700 (MST)
List-Id: linux-scsi@vger.kernel.org
To: mckellj@iomega.com
Cc: linux-scsi@vger.kernel.org

> queued it for 2.6.4-pre

Absent from 2.6.4-rc2, I think.

Perhaps if I knew what -pre meant that would be no surprise to me.

http://marc.theaimsgroup.com/?l=linux-scsi&s=random+write+pdt+5
does not yet enlighten me further, but I observe lk refusing to let Me
write:

$ uname -msrv
Linux 2.6.4-rc2 #1 SMP Sat Mar 6 09:58:43 MST 2004 i686
$
$ grep CDF_ include/linux/cdrom.h
#define CDF_MRW         0x28
$ grep -i HWDM include/linux/cdrom.h
$
$ sudo rrd scan
/dev/scd0 is Iomega RRD 06.3 rw
/dev/hdc is Iomega RRD 06.3 rw
$
$ sudo dd of=/dev/null if=/dev/scd0 bs=64K seek=0 skip=0 count=1
1+0 records in
1+0 records out
$ sudo dd of=/dev/null if=/dev/hdc bs=64K seek=0 skip=0 count=1
1+0 records in
1+0 records out
$
$ sudo dd of=/dev/scd0 if=/dev/zero bs=64K seek=0 skip=0 count=1
dd: opening `/dev/scd0': Read-only file system
$ sudo dd of=/dev/hdc if=/dev/zero bs=64K seek=0 skip=0 count=1
dd: opening `/dev/hdc': Read-only file system
$

Pat LaVarre


