From: Stas Nikiforov <stas@itam.nsc.ru>
Subject: megaraid aborting problem (RHEL 3WS)
Date: Thu, 09 Sep 2004 19:10:22 +0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094731822.27029.52.camel@whirl.lab7.lan>
Reply-To: stas@itam.nsc.ru
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.itam.nsc.ru ([194.226.179.15]:35009 "EHLO ns.itam.nsc.ru")
	by vger.kernel.org with ESMTP id S261602AbUIIMWA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Sep 2004 08:22:00 -0400
Received: from site.lan (itut.itam.nsc.ru [194.226.179.2])
	by ns.itam.nsc.ru (8.12.8/8.12.8) with ESMTP id i89CLsF7010907
	for <linux-scsi@vger.kernel.org>; Thu, 9 Sep 2004 19:21:54 +0700
Received: from [192.168.7.215] ([192.168.7.215])
	(authenticated bits=0)
	by site.lan (8.12.11/8.12.11) with ESMTP id i89CLorO012852
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 9 Sep 2004 19:21:50 +0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
I have a RHEL 3WS (RocksCluster) distribution
(kernel 2.4.21-15ELsmp) with megaraid2 2.10.3 driver.
The following is reported by dmesg.

    megaraid: v2.10.3 (Release Date: Thu Apr  8 16:16:05 EDT 2004)
    megaraid: [713G:G117] detected 1 logical drives.
    scsi0 : LSI Logic MegaRAID 713G 254 commands 16 targs 4 chans 7 luns
    blk: queue c3620e18, I/O limit 4294967295Mb (mask
0xffffffffffffffff)
    scsi0: scanning scsi channel 0 for logical drives.
    Vendor: MegaRAID  Model: LD 0 RAID5 1192G  Rev: 713G
    Type:   Direct-Access                      ANSI SCSI revision: 02

Under heavy io I get the following messages reported by dmesg.
Could somebody tell me what is going wrong and what should I do next?

Thanks in advance,
Stas.

megaraid: critical hardware error!
megaraid: aborting-1441961 cmd=2a <c=0 t=0 l=0>
megaraid: 1441961:76, driver owner.
megaraid: Waiting for 8 commands to flush: iter:0
megaraid: Waiting for 8 commands to flush: iter:1000
megaraid: Waiting for 8 commands to flush: iter:2000
...
megaraid: Waiting for 8 commands to flush: iter:60000
megaraid: critical hardware error!
megaraid: reset-1441957 cmd=2a <c=0 t=0 l=0>
megaraid: reservation reset failed.
megaraid: Waiting for 8 commands to flush: iter:0
megaraid: aborted cmd 160098[41] complete.
megaraid: aborted cmd 160099[48] complete.
megaraid: aborted cmd 16009a[75] complete.
megaraid: aborted cmd 16009b[69] complete.
megaraid: aborted cmd 16009c[4d] complete.
megaraid: aborted cmd 16009d[6b] complete.
megaraid: aborted cmd 16009e[77] complete.
megaraid: aborted cmd 16009f[47] complete.
megaraid: reset sequence successfully completed.
megaraid: reset-1441965 cmd=2a <c=0 t=0 l=0>
megaraid: reservation reset failed.
megaraid: reset sequence successfully completed.


