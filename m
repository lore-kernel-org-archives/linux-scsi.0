From: Newtech Tan <tan@newtech.co.jp>
Subject: how to use SES driver to send SES commands?
Date: Fri, 29 Nov 2013 19:07:30 +0900
Message-ID: <20131129190730.B2FC.46AD7750@newtech.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dc31.etius.jp ([119.245.209.2]:40770 "EHLO dc31.etius.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224Ab3K2KOD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Nov 2013 05:14:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi friends

    I subscribed the mailing list just now. Would you please to give me help? 

    Who can tell me how to use SES driver(linux/driver/scsi/ses.c) to send SES command(SEND DIAGNOSTIC, RECEIVE DIAGNOSTIC RESULTS) in my linux program?
(I don't want to use sg_ses.)

The following is my system info. /dev/sg2 is my SES device.

[root@tan-sl dev]# lsscsi -g
[0:0:0:0]    cd/dvd  HL-DT-ST DVD+-RW GSA-H53N B104  /dev/sr0   /dev/sg0
[3:0:0:0]    disk    ATA      TOSHIBA MK8061GS ME0A  /dev/sda   /dev/sg1
[4:0:0:0]    enclosu LSI      SAS616x          0502  -         /dev/sg2

[root@tan-sl enclosure]# pwd
/sys/class/enclosure
[root@tan-sl enclosure]# ls -l
total 0
lrwxrwxrwx 1 root root 0 Nov 29 14:51 4:0:0:0 -> ../../devices/pci0000:00/0000:00:1c.0/0000:02:00.0/host4/port-4:0/expan
der-4:0/port-4:0:0/end_device-4:0:0/target4:0:0/4:0:0:0/enclosure/4:0:0:0

in linux, I can't find ses device.  Under /sys/class/enclosure, folder 4:0:0:0 existed. 

I will apprectiate for your help.

