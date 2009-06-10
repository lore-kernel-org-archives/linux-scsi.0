From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13499] Write cache: disabled, read cache: enabled, supports DPO
 and FUA? it's  bug???
Date: Wed, 10 Jun 2009 17:04:29 GMT
Message-ID: <200906101704.n5AH4TuI018651@demeter.kernel.org>
References: <bug-13499-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46951 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761311AbZFJRE1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2009 13:04:27 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5AH4TbO018652
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2009 17:04:29 GMT
In-Reply-To: <bug-13499-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13499





--- Comment #3 from ping.li <lxy9805287@163.com>  2009-06-10 17:04:29 ---
1. BBU  status is ok
./MegaCli64 -AdpBbuCmd -GetBbuStatus -a0

BBU status for Adapter: 0

BatteryType: BBU
Voltage: 4058 mV
Current: 0 mA
Temperature: 19 C
Firmware Status: 00000000

Battery state:

GasGuageStatus:
  Fully Discharged        : No
  Fully Charged           : Yes
  Discharging             : Yes
  Initialized             : Yes
  Remaining Time Alarm    : No
  Remaining Capacity Alarm: No
  Discharge Terminated    : No
  Over Temperature        : No
  Charging Terminated     : Yes
  Over Charged            : No

Relative State of Charge: 98 %
Charger Status: Complete
Remaining Capacity: 1634 mAh
Full Charge Capacity: 1662 mAh
isSOHGood: Yes

2. Cache Policy is default,and try change setting but problem still.

./MegaCli64 -LDinfo -L0 -a0
Adapter 0 -- Virtual Drive Information:
Virtual Disk: 0 (target id: 0)
Name:
RAID Level: Primary-5, Secondary-0, RAID Level Qualifier-3
Size:975744MB
State: Optimal
Stripe Size: 64kB
Number Of Drives:8
Span Depth:1
Default Cache Policy: WriteBack, ReadAheadNone, Direct, Write Cache OK if Bad
BBU
Current Cache Policy: WriteBack, ReadAheadNone, Direct, Write Cache OK if Bad
BBU
Access Policy: Read/Write
Disk Cache Policy: Enabled

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
