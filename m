From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: CDC_RAM for lk 2.4, PATCH proposed
Date: 18 Jun 2004 15:42:51 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087594970.3793.48.camel@patibmrh9>
References: <20040604152422.GE1946@suse.de><1086362855.16914.5.camel@patibmr
	h9>  <20040604153627.GF1946@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:6807 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264881AbUFRVnI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jun 2004 17:43:08 -0400
Received: from royntex01.iomegacorp.com (edison [10.1.1.82])
	by email.iomega.com (Postfix) with ESMTP id 1C2CB1B9C
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jun 2004 15:43:03 -0600 (MDT)
In-Reply-To: <20040604153627.GF1946@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: John McKell <McKellj@iomega.com>
Cc: linux-scsi@vger.kernel.org

Thanks again to everyone.

2.4.27-pre6 here now of rewritable RMB MMC UDF looks better than 2.6.6,
indeed as good as 2.6.7.

Pat LaVarre

-----
http://www.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.27.log
Summary of changes ... to v2.4.27-pre6
...
Jens Axboe:
  o DVD-RW write support
  o cdrom hardware defect mgt header length
...
Summary of changes from v2.4.26 ...
...
-----

$ uname -r
2.4.27-pre6
$
$ sudo mkudffs /dev/scd0
...
$ sudo mount /dev/scd0 /mnt/scd0
$ mount | grep scd0
/dev/scd0 on /mnt/scd0 type udf (rw)
$ sudo umount /dev/scd0
$
$ sudo rrd scan
/dev/scd0 is Iomega RRD 74.B rw
$
$ sudo eject /dev/scd0
$
$ sudo mount -r /dev/scd0 /mnt/scd0
$ ls -l /mnt/scd0
total 20
-rw-rw-rw-    1 4294967295 4294967295       25 Jun 17 14:01 Autorun.inf
-rw-rw-rw-    1 4294967295 4294967295    18902 Feb  5 08:35 REV.ico
$ sudo umount /dev/scd0
$


