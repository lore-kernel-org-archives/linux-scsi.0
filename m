From: Douglas Gilbert <dougg@torque.net>
Subject: increasing host numbers
Date: Tue, 24 Jun 2003 18:16:58 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EF808FA.5020503@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:12050 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S264679AbTFXICz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2003 04:02:55 -0400
Received: from torque.net (d-241-87.stlucia.uq.net.au [203.101.241.87])
	by bunyip.cc.uq.edu.au (8.12.9/8.12.9) with ESMTP id h5O8H0hp003717
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2003 18:17:01 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

It seems as though host numbers are no longer re-used.
This pattern started in lk 2.5.73:

# lsscsi
[0:0:1:0]    disk    FUJITSU  MAM3184MP        0106  /dev/sda
# modprobe scsi_debug
# lsscsi
[0:0:1:0]    disk    FUJITSU  MAM3184MP        0106  /dev/sda
[2:0:0:0]    disk    Linux    scsi_debug       0004  /dev/sdb
# rmmod scsi_debug
# modprobe scsi_debug
# lsscsi
[0:0:1:0]    disk    FUJITSU  MAM3184MP        0106  /dev/sda
[3:0:0:0]    disk    Linux    scsi_debug       0004  /dev/sdb
# rmmod scsi_debug
# modprobe scsi_debug
# lsscsi
[0:0:1:0]    disk    FUJITSU  MAM3184MP        0106  /dev/sda
[4:0:0:0]    disk    Linux    scsi_debug       0004  /dev/sdb

Feature?

Doug Gilbert


