From: Manish RATHI <manish.rathi@st.com>
Subject: scsi problem with usb
Date: Mon, 14 Aug 2006 14:58:21 +0530
Message-ID: <000201c6bf83$fc6200e0$802cc70a@dlh.st.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fra-del-01.spheriq.net ([195.46.51.97]:60330 "EHLO
	fra-del-01.spheriq.net") by vger.kernel.org with ESMTP
	id S1751964AbWHNJ2d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2006 05:28:33 -0400
Received: from fra-out-02.spheriq.net (fra-out-02.spheriq.net [195.46.51.130])
        by fra-del-01.spheriq.net with ESMTP id k7E9SQ7B030329
        for <linux-scsi@vger.kernel.org>; Mon, 14 Aug 2006 09:28:30 GMT
Received: from fra-cus-02.spheriq.net (fra-cus-02.spheriq.net [195.46.51.38])
        by fra-out-02.spheriq.net with ESMTP id k7E9SPDg001479
        for <linux-scsi@vger.kernel.org>; Mon, 14 Aug 2006 09:28:25 GMT
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by fra-cus-02.spheriq.net with ESMTP id k7E9SO9R024761
        (version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=OK)
        for <linux-scsi@vger.kernel.org>; Mon, 14 Aug 2006 09:28:25 GMT
Received: from zeta.dmz-eu.st.com (ns2.st.com [164.129.230.9])
	by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 4BE39DA42
	for <linux-scsi@vger.kernel.org>; Mon, 14 Aug 2006 09:28:24 +0000 (GMT)
Received: from mail2.dlh.st.com (mail2.dlh.st.com [10.199.8.22])
	by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id B955647503
	for <linux-scsi@vger.kernel.org>; Mon, 14 Aug 2006 09:28:23 +0000 (GMT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
I am using linux 2.6.17 for my usb controller driver in host mode for mass storage emulation. Mass storage device is detected and I got following prints


/ # INQUIRY message sent

  Vendor: Generic   Model: Flash D           Rev:     

  Type:   Direct-Access                      ANSI SCSI revision: 00

SCSI device sdb: 1024 512-byte hdwr sectors (1 MB)

sdb: Write Protect is off

sdb: assuming drive cache: write through


SCSI device sdb: 1024 512-byte hdwr sectors (1 MB)


sdb: Write Protect is off

sdb: assuming drive cache: write through

sdb:<7>usb-storage: queuecommand called

unknown partition table

sd 1:0:0:0: Attached scsi removable disk sdb

sd 1:0:0:0: Attached scsi generic sg1 type 0

INQUIRY message sent

  Vendor: Generic   Model:  AUTORUN  Disk    Rev: 8.00

  Type:   Direct-Access                      ANSI SCSI revision: 02


SCSI device sdc: 1024 512-byte hdwr sectors (1 MB)

sdc: Write Protect is on

sdc: assuming drive cache: write through


SCSI device sdc: 1024 512-byte hdwr sectors (1 MB)


sdc: Write Protect is on

sdc: assuming drive cache: write through

 sdc:<7>usb-storage: queuecommand called



 sdc1 sdc4

sd 1:0:0:1: Attached scsi disk sdc

sd 1:0:0:1: Attached scsi generic sg2 type 0



crw-r--r--    1 root     root       5,   1 Jan  1 00:01 console

crw-r--r--    1 root     root      29,   0 May 11  2006 fb0

crw-r--r--    1 root     root      89,   0 May 11  2006 i2c-0

crw-r--r--    1 root     root      89,   1 May 11  2006 i2c-1

crw-r--r--    1 root     root       1,   1 May 11  2006 mem

crw-r--r--    1 root     root      90,   0 May 11  2006 mtd0

crw-r--r--    1 root     root       1,   3 May 11  2006 null

brw-r--r--    1 root     root       8,   0 Aug 14  2006 sda

brw-r--r--    1 root     root       8,   1 Aug 14  2006 sda1

brw-r--r--    1 root     root       8,   2 Aug 14  2006 sda2

brw-r--r--    1 root     root       8,  16 Aug 14  2006 sdb

brw-r--r--    1 root     root       8,  32 Aug 14  2006 sdc

crw-r--r--    1 root     root      21,   0 Aug 14  2006 sg0

crw-r--r--    1 root     root      21,   1 Aug 14  2006 sg1

crw-r--r--    1 root     root      21,   3 Jan  1 00:01 sg3

crw-r--r--    1 root     root     204,  64 May 11  2006 ttyAMA0

crw-r--r--    1 root     root     204,  65 May 11  2006 ttyAMA1



I mounted usbfs and able to see mass storage in /proc/bus/usb/devices

However when I try to mount by
Mount -t vfat /dev/sda /mnt/pendrive then
I get error "Mounting /dev/sda on /mems failed: No such device" I tried it on sdb and sdc as well but it's not mounted.

I also tried to run fdisk /dev/sda but same type of error appears.

Can any one tell me abt possible problem?

Regards
Manish

