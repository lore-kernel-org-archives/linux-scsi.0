From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: s390 patches for 2.6.5.
Date: Thu, 8 Apr 2004 16:26:59 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040408142659.GA1793@mschwid3.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:55016 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP id S261794AbUDHO1L
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Apr 2004 10:27:11 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi Andrew,
easter egg patches from s390 land. Quite big this time: 36000 lines.
The big things are the crypto device driver (6KLOC) and the rewritten
qeth driver (23KLOC).
I've included the zfcp patches in this patch set as well after I "fixed"
the kfree problem. To get the other bug fixes into mainline I side-stepped
the kfree issue. There are now release functions for the zfcp_unit and
zfcp_port objects but I removed the module_exit function as well. Without
the kfree trick we KNOW module unloading to be racy. So far we know of no
other feasible solution for this problem. Therefore we removed the support
for unloading of the zfcp module.

Descriptions:
1) s390 architecture fixes.
2) Common i/o layer fixes.
3) Tape device driver fixes.
4) Dasd driver fix.
5) Network driver fixes.
6) DCSS block device driver fix.
7) The real zfcp bug fixes.
8) zfcp host adapter message cleanup part 1.
9) zfcp host adapter message cleanup part 2.
10) The crypto device driver part 1.
11) The crypto device driver part 2.
12) The rewritten qeth driver. This patch is HUGE and there is no
    easy way to get it divided into 100K chunks. So I can't sent
    this to lkml, sorry. If someone wants a copy feel free to kick me.

blue skies,
  Martin.

