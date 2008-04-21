From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10486] kernel 2.6.24  4G FC arrays don't work properly with qla2xxx driver
Date: Mon, 21 Apr 2008 12:02:13 -0700 (PDT)
Message-ID: <20080421190213.CAF31108060@picon.linux-foundation.org>
References: <bug-10486-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753673AbYDUTCq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2008 15:02:46 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m3LJ2FKx018648
	for <linux-scsi@vger.kernel.org>; Mon, 21 Apr 2008 12:02:17 -0700
In-Reply-To: <bug-10486-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10486





------- Comment #4 from andrej.filipcic@ijs.si  2008-04-21 12:02 -------
The lun information is correct. The luns are ~23TB in size, the fibre channel
connection speed is 4Gb/s. But as soon as vgscan is run, there are read errors
from the device (like /dev/sdc). The device file does not have any successful
operation. vgscan just tries to read /dev/sdc to scan for possible LVM groups,
since it is easier to handle them in fstab. 

In short, all external disk are detected/reported correctly. device files of
disks with 2Gb/s connection can be used (read), while device files wih 4Gb/s
connection are unsuable (read errors from /dev/sdc)


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
