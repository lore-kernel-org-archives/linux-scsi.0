From: Pat LaVarre <p.lavarre@ieee.org>
Subject: sg_scan -i /dev/sg[0123] /dev/hd[abcd] /dev/scd[0123]
Date: 05 Dec 2003 17:27:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070670440.3056.7.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:21651 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263868AbTLFA1f
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2003 19:27:35 -0500
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Doug G:

In lk 2.6 I wish sg_scan accepted a list of args e.g.

$ lsmod | grep sg
$
$ sudo sg_scan -i /dev/sg[0123] /dev/hd[abcd] /dev/scd[0123]
/dev/hdd: scsi0 channel=0 id=0 lun=0 [em]  type=5
    Iomega    RRD               05.A [wide=0 sync=0 cmdq=0 sftre=0 pq=0x0]
/dev/scd0: scsi0 channel=0 id=0 lun=0 [em]  type=5
    Iomega    RRD               05.U [wide=0 sync=0 cmdq=0 sftre=0 pq=0x0]
$
$ lsmod | grep sg
$ 

Tell me you will accept such a patch, and I might not be too lazy to write it.

Pat LaVarre

P.S. I presume already you are aware of the gcc -Wall warning:

$ cd sg3_utils-1.06/
$ make
gcc -g -O2 -Wall -W -D_REENTRANT -D_LARGEFILE64_SOURCE
-D_FILE_OFFSET_BITS=64
-c -o sg_dd.o sg_dd.c
sg_dd.c: In function `siginfo_handler':
sg_dd.c:138: warning: unused parameter `sig'
...

P.P.S. Thanks again for giving http://www.torque.net/sg/ us via google.


