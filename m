From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sg_scan -i /dev/sg[0123] /dev/hd[abcd] /dev/scd[0123]
Date: 14 Dec 2003 15:30:37 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1071441037.3402.39.camel@patibmrh9>
References: <1070670440.3056.7.camel@patibmrh9>
	 <3FD43229.7070708@torque.net>  <1070906283.2263.101.camel@patibmrh9>
	 <1070908146.2263.121.camel@patibmrh9> <1071172941.2868.26.camel@patibmrh9>
	 <3FD9BBF3.1030209@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:1949 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262746AbTLNWaw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Dec 2003 17:30:52 -0500
In-Reply-To: <3FD9BBF3.1030209@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Doug G:

> > ... sg_scan now lets me name the devices to scan, including
> > lk 2.6 block devices:
> > 
> > ... then also omits and scans past the
> > "Stopping because there are too many error" message in configurations
> > with few devices present, ....
> ...
> Patch applied, uploaded to the sg webpage.

Beautiful, thank you, our command line grows more incisive:

$ time sg_scan -i /dev/hd* /dev/scd*
sg_scan: device /dev/hda failed on scsi ioctl, skip: Invalid argument
sg_scan: device /dev/hda1 failed on scsi ioctl, skip: Invalid argument
sg_scan: device /dev/hda2 failed on scsi ioctl, skip: Invalid argument
sg_scan: device /dev/hda3 failed on scsi ioctl, skip: Invalid argument
/dev/hdc: scsi0 channel=0 id=0 lun=0 [em]
    LITE-ON   COMBO LTC-48161H  KH0K [rmb=1 cmdq=0 pqual=0 pdev=0x5]
/dev/hdd: scsi0 channel=0 id=0 lun=0 [em]
    Iomega    RRD               14.A [rmb=1 cmdq=0 pqual=0 pdev=0x5]
/dev/scd0: scsi0 channel=0 id=0 lun=0 [em]
    Iomega    RRD               14.U [rmb=1 cmdq=0 pqual=0 pdev=0x5]
/dev/scd1: scsi1 channel=0 id=0 lun=0 [em]
    Iomega    RRD               14.U [rmb=1 cmdq=0 pqual=0 pdev=0x5]
 
real    0m1.213s
user    0m0.097s
sys     0m0.021s
$
$ uname -msr
Linux 2.6.0-test11 i686
$
$ grep Change sg3_utils-1.06/CHANGELOG | head -1
Changelog for sg3_utils-1.06 [20031212]
$

Pat LaVarre


