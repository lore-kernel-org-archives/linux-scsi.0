From: Douglas Gilbert <dougg@torque.net>
Subject: lsscsi-0.04
Date: Wed, 15 Jan 2003 09:42:27 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E249253.9000905@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-12.triode.net.au [202.147.125.12])
	by iggy.triode.net.au (8.12.7/8.12.7) with ESMTP id h0EMcwIF030577
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jan 2003 09:39:06 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lsscsi is a utility the uses sysfs in kernels >= lk 2.5.50
to list information about all SCSI devices (including devices
that use the SCSI stack such as USB mass storage devices).
Both a compact format (default), one line per device, and
a "classic" format (like the output of 'cat /proc/scsi/scsi')
are supported.

Version 0.04 is available at
http://www.torque.net/scsi/lsscsi.html

Minor cleanup for SCSI tape devices whose listing
became untidy in lk 2.5.57 . In lk 2.5.58 the
scsi_level value is provided by sysfs. Now the
"classic" lsscsi listing looks equivalent to
'cat /proc/scsi/scsi':

$ lsscsi --classic
ttached devices:
Host: scsi0 Channel: 00 Id: 01 Lun: 00
   Vendor: FUJITSU  Model: MAM3184MP        Rev: 0105
   Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi2 Channel: 00 Id: 00 Lun: 00
   Vendor: Linux    Model: scsi_debug       Rev: 0004
   Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi3 Channel: 00 Id: 00 Lun: 00
   Vendor: CREATIVE Model: CD5233E          Rev: 1.00
   Type:   CD-ROM                           ANSI SCSI revision: 02
Host: scsi4 Channel: 00 Id: 06 Lun: 00
   Vendor: SONY     Model: SDT-7000         Rev: 0192
   Type:   Sequential-Access                ANSI SCSI revision: 02

$ cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 01 Lun: 00
   Vendor: FUJITSU  Model: MAM3184MP        Rev: 0105
   Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi2 Channel: 00 Id: 00 Lun: 00
   Vendor: Linux    Model: scsi_debug       Rev: 0004
   Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi3 Channel: 00 Id: 00 Lun: 00
   Vendor: CREATIVE Model: CD5233E          Rev: 1.00
   Type:   CD-ROM                           ANSI SCSI revision: 02
Host: scsi4 Channel: 00 Id: 06 Lun: 00
   Vendor: SONY     Model: SDT-7000         Rev: 0192
   Type:   Sequential-Access                ANSI SCSI revision: 02


Doug Gilbert



