From: Matthias Brunner <mb@blumenstrasse.vol.at>
Subject: RAID status with fusion mpt driver
Date: Thu, 13 Feb 2003 10:37:17 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200302131037.17635.mb@blumenstrasse.vol.at>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from m736p027.adsl.highway.telekom.at (HELO brot) ([62.47.251.251]) (envelope-sender <mb@blumenstrasse.vol.at>)
          by qmail1rs.highway.telekom.at (qmail-ldap-1.03) with SMTP
          for <linux-scsi@vger.kernel.org>; 13 Feb 2003 09:35:32 -0000
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I have an IBM xSeries with an LSI53C1030 integrated RAID controller, 
a RAID-1 is set up.
The array appears as a virtual SCSI disk (/dev/sda).
So how can I learn the state of the RAID and - even more important - 
be notified if one of the disks fails? What will the logs say (so I 
can use logsurfer)?
Files in /proc/mpt and below are not very helpful in that respect.

Kernel version: 2.4.20
-- 
Matthias Brunner <mb@blumenstrasse.vol.at>
PGP FP 7862 32B3 3B75 292A F76F  5042 8587 21AB 5B89 D501
Check out http://blumenstrasse.vol.at/~mb/gpgkey.asc

