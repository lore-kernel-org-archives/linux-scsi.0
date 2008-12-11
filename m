From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12195] "dd" make kernel panic
Date: Wed, 10 Dec 2008 18:09:01 -0800 (PST)
Message-ID: <20081211020901.7C74610800C@picon.linux-foundation.org>
References: <bug-12195-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753023AbYLKCJD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Dec 2008 21:09:03 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBB291S8029879
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2008 18:09:02 -0800
In-Reply-To: <bug-12195-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12195





------- Comment #1 from alex.shi@intel.com  2008-12-10 18:09 -------
the device is :
06:02.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X
Fusion-MPT Dual Ultra320 SCSI (rev 07)
        Subsystem: Intel Corporation: Unknown device 3402
        Flags: bus master, 66Mhz, medium devsel, latency 64, IRQ 49
        I/O ports at 8800 [size=256]
        Memory at 00000000f8fd0000 (64-bit, non-prefetchable) [size=64K]
        Memory at 00000000f8fc0000 (64-bit, non-prefetchable) [size=64K]
        Expansion ROM at 00000000f8d00000 [disabled] [size=1M]
        Capabilities: <available only to root>

06:02.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X
Fusion-MPT Dual Ultra320 SCSI (rev 07)
        Subsystem: Intel Corporation: Unknown device 3402
        Flags: bus master, 66Mhz, medium devsel, latency 64, IRQ 50
        I/O ports at 8c00 [size=256]
        Memory at 00000000f8ff0000 (64-bit, non-prefetchable) [size=64K]
        Memory at 00000000f8fe0000 (64-bit, non-prefetchable) [size=64K]
        Expansion ROM at 00000000f8e00000 [disabled] [size=1M]
        Capabilities: <available only to root>


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
