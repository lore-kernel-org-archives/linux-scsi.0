From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10486] kernel 2.6.24  4G FC arrays don't work properly with qla2xxx driver
Date: Mon, 21 Apr 2008 11:35:29 -0700 (PDT)
Message-ID: <20080421183529.14E92108060@picon.linux-foundation.org>
References: <bug-10486-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752061AbYDUSgE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2008 14:36:04 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m3LIZTOD016594
	for <linux-scsi@vger.kernel.org>; Mon, 21 Apr 2008 11:35:30 -0700
In-Reply-To: <bug-10486-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10486





------- Comment #3 from andrew.vasquez@qlogic.com  2008-04-21 11:35 -------
Could you provide some details on the configuration?  Size of luns in
question, storage type?  Are you stating that the report-luns information
is now incorrect with your 4gb storage???

Detecting 4G array gives:
 sd 8:0:0:0: [sdc] Very big device. Trying to use READ CAPACITY(16).
 sd 8:0:0:0: [sdc] 44918798336 512-byte hardware sectors (22998425 MB)
 sd 8:0:0:0: [sdc] Write Protect is off
 sd 8:0:0:0: [sdc] Mode Sense: 8f 00 00 08
 sd 8:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
 sd 8:0:0:0: [sdc] Very big device. Trying to use READ CAPACITY(16).
 sd 8:0:0:0: [sdc] 44918798336 512-byte hardware sectors (22998425 MB)
 sd 8:0:0:0: [sdc] Write Protect is off
 sd 8:0:0:0: [sdc] Mode Sense: 8f 00 00 08
 sd 8:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
 sdc: sdc1
 sd 8:0:0:0: [sdc] Attached SCSI disk

So you don't have a 22Tb storage device?  I'm not entirely clear on
what the problem is here...  BTW: The driver is simply a command passthru,
Lun discovery is handled by the midlayer...

Can you provide full logs, from driver load to failure.  Also what is 'vgscan'?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
