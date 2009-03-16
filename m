From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12163] mptsas driver cannot discover some hotplugged SATA/SAS disks
Date: Mon, 16 Mar 2009 04:47:12 -0700 (PDT)
Message-ID: <20090316114712.D3D56108041@picon.linux-foundation.org>
References: <bug-12163-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752073AbZCPLrw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Mar 2009 07:47:52 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2GBlD01032702
	for <linux-scsi@vger.kernel.org>; Mon, 16 Mar 2009 04:47:49 -0700
In-Reply-To: <bug-12163-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12163





------- Comment #9 from be@mpstor.com  2009-03-16 04:47 -------
Created an attachment (id=20544)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=20544&action=view)
mptsas.c patch for 2.6.29-rc5, SAS/SATA Hotplug issue.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
