From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12730] USB memory stick moved to different device on error / may be due to problem with high concurrent load on two USB devices
Date: Wed, 18 Feb 2009 10:32:56 -0800 (PST)
Message-ID: <20090218183256.75DFE108042@picon.linux-foundation.org>
References: <bug-12730-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754246AbZBRSdp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2009 13:33:45 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1IIWuKU013682
	for <linux-scsi@vger.kernel.org>; Wed, 18 Feb 2009 10:32:57 -0800
In-Reply-To: <bug-12730-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12730





------- Comment #3 from wagner@tik.ee.ethz.ch  2009-02-18 10:32 -------
Ok, so this is a known issue with AHCI hardware. I think I till pass on the
debug-kernel. 

Anyways, thanks for the info. I will just be careful with raw access to USB
devices. Mounted ones should not be that critical, since they will not remount
themselves. 


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
