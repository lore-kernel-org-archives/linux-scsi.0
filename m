From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14577] Data Corruption with Adaptec 52445, Firmware 5.2-0
 (17380)
Date: Wed, 18 Nov 2009 13:57:29 GMT
Message-ID: <200911181357.nAIDvTdB023904@demeter.kernel.org>
References: <bug-14577-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53935 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676AbZKRN5X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2009 08:57:23 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAIDvTob023905
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2009 13:57:29 GMT
In-Reply-To: <bug-14577-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14577


lkolbe@techfak.uni-bielefeld.de changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Blocks|                            |14579




--- Comment #10 from lkolbe@techfak.uni-bielefeld.de  2009-11-18 13:57:28 ---
This bug also blocks #14579
The LSI requested us to try the current mtpfusion which is included in
2.6.32-rc, but we are unable to boot that kernel successfully.

fyi, the 24 1TB Sata-disks are in a RAID-60, and the system (debian lenny) is
installed in an LVM volume.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
