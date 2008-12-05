From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12163] mptsas driver cannot discover some hotplugged SATA/SAS disks
Date: Fri,  5 Dec 2008 05:20:25 -0800 (PST)
Message-ID: <20081205132025.D114C10800F@picon.linux-foundation.org>
References: <bug-12163-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751984AbYLENU1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 08:20:27 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mB5DKPAw013421
	for <linux-scsi@vger.kernel.org>; Fri, 5 Dec 2008 05:20:26 -0800
In-Reply-To: <bug-12163-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12163





------- Comment #3 from crquan@gmail.com  2008-12-05 05:20 -------
Created an attachment (id=19156)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=19156&action=view)
port vendor driver 4.00.43.00 for RHEL5.1 to the latest mainstream git kernel

with the previous 4.00.43.00 driver and this, you can run it on the latest git
kernel.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
