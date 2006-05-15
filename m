From: Maik Hampel <Maik.Hampel@xiranet.com>
Subject: Hotplug does not work with Fusion MPT
Date: Mon, 15 May 2006 14:08:14 +0200
Message-ID: <1147694894.9689.15.camel@c64.dd.xiranet.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 162.237.80.212.versanetonline.de ([212.80.237.162]:5053 "EHLO
	cheetah.dd.xiranet.com") by vger.kernel.org with ESMTP
	id S1751406AbWEOMIU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 May 2006 08:08:20 -0400
Received: from c64.dd.xiranet.com (c64.dd.xiranet.com [192.168.0.130])
	by cheetah.dd.xiranet.com (8.13.4/8.13.4/Debian-1) with ESMTP id k4FC8Fbp027138
	for <linux-scsi@vger.kernel.org>; Mon, 15 May 2006 14:08:16 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hello,

I'm using MPT-Fusion driver (linux-2.6.16.x) with LSI 53C1030 on SPI.

I recognized, that removing a scsi-drive (connected with SCA) did not
remove it from linux scsi subsystem. The physically removed drive was
still listed in /proc/scsi/scsi:

Host: scsi0 Channel: 00 Id: 04 Lun: 00
  Vendor: FUJITSU  Model: MAP3367NC        Rev: 0108
  Type:   Direct-Access                    ANSI SCSI revision: 03

On access via cfdisk /dev/sdd the following error messages occured in
syslog:

mptbase: ioc0: IOCStatus(0x0043): SCSI Device Not There
sd 0:0:4:0: SCSI error: return code = 0x10000
end_request: I/O error, dev sdd, sector 0
Buffer I/O error on device sdd, logical block 0
mptbase: ioc0: IOCStatus(0x0043): SCSI Device Not There
sd 0:0:4:0: SCSI error: return code = 0x10000
end_request: I/O error, dev sdd, sector 4
Buffer I/O error on device sdd, logical block 1
mptbase: ioc0: IOCStatus(0x0043): SCSI Device Not There
sd 0:0:4:0: SCSI error: return code = 0x10000
end_request: I/O error, dev sdd, sector 8
Buffer I/O error on device sdd, logical block 2
mptbase: ioc0: IOCStatus(0x0043): SCSI Device Not There
sd 0:0:4:0: SCSI error: return code = 0x10000
end_request: I/O error, dev sdd, sector 0
Buffer I/O error on device sdd, logical block 0
mptbase: ioc0: IOCStatus(0x0043): SCSI Device Not There
sd 0:0:4:0: SCSI error: return code = 0x10000
end_request: I/O error, dev sdd, sector 12
Buffer I/O error on device sdd, logical block 3
mptbase: ioc0: IOCStatus(0x0043): SCSI Device Not There
sd 0:0:4:0: SCSI error: return code = 0x10000
end_request: I/O error, dev sdd, sector 4
Buffer I/O error on device sdd, logical block 1
mptbase: ioc0: IOCStatus(0x0043): SCSI Device Not There
sd 0:0:4:0: SCSI error: return code = 0x10000
end_request: I/O error, dev sdd, sector 16
Buffer I/O error on device sdd, logical block 4
mptbase: ioc0: IOCStatus(0x0043): SCSI Device Not There
sd 0:0:4:0: SCSI error: return code = 0x10000
end_request: I/O error, dev sdd, sector 20
Buffer I/O error on device sdd, logical block 5
mptbase: ioc0: IOCStatus(0x0043): SCSI Device Not There
sd 0:0:4:0: SCSI error: return code = 0x10000
end_request: I/O error, dev sdd, sector 24

Any suggestions about that?


Maik Hampel


