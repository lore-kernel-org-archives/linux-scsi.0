From: Douglas Gilbert <dougg@torque.net>
Subject: smartmontools
Date: Tue, 11 Mar 2003 22:45:46 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E6DDA7A.4010304@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: ballen@gravity.phys.uwm.edu

Self-Monitoring, Analysis and Reporting Technology System
(S.M.A.R.T.) is built into most modern ATA and SCSI hard
disks (or at least that is what the manufacturers claim).

smartmontools grew out of the smartsuite project which
does not seem to be maintained anymore. The home page
for smartmontools is:
   http://smartmontools.sourceforge.net/

The chief maintainer of smartmontools has a farm of ATA
disks and is requesting help with SCSI disks (there is
also some SCSI tape test code in there). Even though
the support for SCSI devices lags that of ATA devices,
smartmontools is still useful.

For example, the "-a" option lists all available "SMART"
data (most derived from LOG SENSE responses in SCSI):

# smartctl -a /dev/sda
smartctl version 5.1-9 Copyright (C) 2002-3 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

Device: FUJITSU  MAM3184MP        Version: 0105
Local Time is: Tue Mar 11 22:27:38 2003 EST
Device supports S.M.A.R.T. and is Enabled
Temperature Warning Disabled or Not Supported
S.M.A.R.T. Sense: Ok!
Current Drive Temperature:     43 C
Drive Trip Temperature:        65 C
Current start stop count:      328 times
Recommended start stop count:  10000 times

SMART Self-test log
Num  Test              Status                 segment  LifeTime
      Description                              number   (hours)
# 1  Background long   Self test in progress ...   -   NOW
# 2  Background short  Completed                   -   830
# 3  Background short  Completed                   -   703
......


A self test can be started manually with:
# smartctl -t long /dev/sda


Hope this tool is of some help. The smartmontools
maintainer (Bruce Allen) will welcome feedback.

Doug Gilbert



