From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: s390 patches for 2.6.5-rc1-mm1.
Date: Tue, 16 Mar 2004 14:48:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040316134852.GA2785@mschwid3.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:24019 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP id S261685AbUCPNtO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Mar 2004 08:49:14 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi Andrew,
the current set of s390 patches against 2.6.5-rc1-mm1. The differ a bit
from the last set I sent:

> Short descriptions:
> 1) s390 architecture fixes. This one clashes with the remap-file-pages
>    fix for s390 I sent yesterday but the conflict is easy to fix.
> 2) Some more common i/o layer fixes.
> 3) Fix for the last sclp fix.
> 4) Network driver fixes.
> 5) Dasd driver fixes.
> 6) z/VM monitor stream fixes.
> 7) Tape driver fixes.
> 8) The real zfcp bug fixes.
> 9) zfcp host adapter message cleanup part 1.
> 10) zfcp host adapter message cleanup part 2.

Changes 16.03.2004
1) added another single stepped svc patch, applies on top of remap-file-pages
2) added activity check fix
4) added code to allow to change the netiucv peer username
7) adapted to recent bk changes
8) added include file cleanup & small optimization.

Protests against the zfcp patch #8 have died down. I still think the kfree
trick is the best solution for the port/unit object release problem.
Perhaps we'll see some more feedback from the linux-scsi list.

That leaves the question whether we could use dev_printk instead of the
ZFCP_LOG macros. dev_printk doesn't offer a variable log level, so the
one macro can't just be replaced by another. For now, I'd say no.

blue skies,
  Martin.

