From: claplant@pubnix.org
Subject: Problem with LF-D100 / LF-D101N Reading CD's
Date: Tue, 8 Feb 2005 00:38:20 -0600 (CST)
Message-ID: <Pine.GSO.4.05.10502080018410.18327-100000@emdub.pubnix.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from pubnix.org ([169.207.167.57]:7153 "EHLO pubnix.org")
	by vger.kernel.org with ESMTP id S261475AbVBHGm5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2005 01:42:57 -0500
Received: from localhost (claplant@localhost)
	by pubnix.org (8.9.1/8.12.2) with ESMTP id AAA09763
	for <linux-scsi@vger.kernel.org>; Tue, 8 Feb 2005 00:38:20 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I am having a problem with an LF-D101N DVD-RAM drive. 

Host: scsi0 Channel: 00 Id: 02 Lun: 00
  Vendor: MATSHITA Model: PD-2 LF-D100     Rev: A123
  Type:   CD-ROM                           ANSI SCSI revision: 02

LF-D101N written on the drive.

If it is empty or has any media except dvd-ram media, I get the following:

Feb  7 19:46:33 music kernel: sr2: CDROM (ioctl) error, command: Test Unit
Ready 00 00 00 00 00 Feb  7 19:46:33 music kernel: Current sr: sense key
Hardware Error
Feb  7 19:46:33 music kernel: Additional sense: Tracking servo failure Feb
7 19:46:33 music kernel: sr2: CDROM (ioctl) error, command: Test Unit
Ready 00 00 00 00 00 Feb  7 19:46:33 music kernel: Current sr: sense key
Hardware Error
Feb  7 19:46:33 music kernel: Additional sense: Tracking servo failure 
 
sr0: CDROM (ioctl) error, command: Test Unit Ready 00 00 00 00 00
Current sr: sense key Hardware Error
Additional sense: Id CRC or ECC error

This repeats about once a second.

Once I put in a DVD-RAM:

Feb  7 22:09:13 music kernel: UDF-fs INFO UDF 0.9.8.1 (2004/29/09)
Mounting volume 'OSSTORAGE4254B', timestamp 2004/10/22 11:49 (1e20)

It mounts fine.

I have six of these drives that all act the same, so I am quite sure they
are not all bad.

I am running 2.6.10-1.760_FC3smp though the results were the same w/ a 2.4
kernel under RHEL3. 

Any help or ideas would be apreciated.

Thanks,

-chris

