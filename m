From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Tue, 30 Mar 2010 14:53:06 GMT
Message-ID: <201003301453.o2UEr6IG019034@demeter.kernel.org>
References: <bug-14831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54569 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0C3OxH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2010 10:53:07 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2UEr6Nm019035
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 30 Mar 2010 14:53:06 GMT
In-Reply-To: <bug-14831-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14831





--- Comment #12 from bpkroth@gmail.com  2010-03-30 14:52:52 ---
I'm also seeing the problem, also on a Dell server.  I'm running Debian
Squeeze.  I didn't see this issue with 2.6.29.

# cat /proc/mpt/summary 
ioc0: LSISAS1068E B3, FwRev=00192f00h, Ports=1, MaxQ=266, IRQ=32

# uname -a
Linux oberon 2.6.32-3-amd64 #1 SMP Wed Feb 24 18:07:42 UTC 2010 x86_64
GNU/Linux

# dmesg | egrep -i 'scsi 0.*(wdc|samsung)'
[   18.427778] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1602ABKS-1 3B04
PQ: 0 ANSI: 5
[   18.432650] scsi 0:0:1:0: Direct-Access     ATA      WDC WD1602ABKS-1 3B04
PQ: 0 ANSI: 5
[   18.448696] scsi 0:0:2:0: Direct-Access     ATA      SAMSUNG HD103UJ  1118
PQ: 0 ANSI: 5
[   18.464756] scsi 0:0:3:0: Direct-Access     ATA      SAMSUNG HD103UJ  1118
PQ: 0 ANSI: 5
[   18.480824] scsi 0:0:4:0: Direct-Access     ATA      SAMSUNG HD103UJ  1118
PQ: 0 ANSI: 5
[   18.496910] scsi 0:0:5:0: Direct-Access     ATA      SAMSUNG HD103UJ  1118
PQ: 0 ANSI: 5

Please let me know if you need any additional information.  I would like to be
able to know when my drives are starting to have issues so I can replace them
before it causes major problems.  Right now I can't issue SMART queries without
it throwing the disks from the md.

Thanks,
Brian

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
