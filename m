From: Douglas Gilbert <dougg@torque.net>
Subject: lsscsi-0-13 released
Date: Fri, 20 Aug 2004 15:04:42 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4125866A.4050008@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub2.uq.edu.au ([130.102.149.128]:36614 "EHLO
	mailhub2.uq.edu.au") by vger.kernel.org with ESMTP id S267357AbUHTFFe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2004 01:05:34 -0400
Received: from smtp2.uq.edu.au (smtp2.uq.edu.au [130.102.5.53])
	by mailhub2.uq.edu.au (8.12.11/8.12.11) with ESMTP id i7K55S4N032575
	for <linux-scsi@vger.kernel.org>; Fri, 20 Aug 2004 15:05:28 +1000 (EST)
Received: from [192.168.48.80] (d-239-61.stlucia.uq.net.au [203.101.239.61])
	by smtp2.uq.edu.au (8.12.10/8.12.10) with ESMTP id i7K55PO4006734
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 20 Aug 2004 15:05:27 +1000 (EST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lsscsi is a utility that uses sysfs in linux 2.6 series kernels
to list information about all SCSI devices (including devices
that use the SCSI stack such as USB mass storage devices)
and SCSI hosts. Both a compact format (default) which is one line
per device and a "classic" format (like the output of
'cat /proc/scsi/scsi') are supported. Some examples:

$ lsscsi
[0:0:0:0]    disk    Linux    scsi_debug       0004  /dev/sda
[1:0:6:0]    tape    SONY     SDT-7000         0192  /dev/st0

$ lsscsi --classic
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: Linux    Model: scsi_debug       Rev: 0004
   Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi1 Channel: 00 Id: 06 Lun: 00
   Vendor: SONY     Model: SDT-7000         Rev: 0192
   Type:   Sequential-Access                ANSI SCSI revision: 02

Version 0.13 is available at
http://www.torque.net/scsi/lsscsi.html

This version has been tested with lk 2.6.8.1 .

Changelog: Version 0.13 2004/8/12
   - add 'timeout' to long device option output
   - quiet (unless verbose) if no mid level (hence
     no SCSI devices or hosts)




There is also a pre-release version of lsscsi-0.14 which
is a port to use the libsysfs library. It awaits a new
dlist function called dlist_sort_custom() being added to
libsysfs. This function allows an application (such as
lsscsi) to sort sysfs directories. lsscsi uses this facility
to numerically sort <h,c,t,l> tuples.

Doug Gilbert
