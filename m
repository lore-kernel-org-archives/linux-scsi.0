From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12163] mptsas driver cannot discover some hotplugged SATA/SAS disks
Date: Tue,  3 Feb 2009 07:11:23 -0800 (PST)
Message-ID: <20090203151123.BF227108042@picon.linux-foundation.org>
References: <bug-12163-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753897AbZBCPLy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Feb 2009 10:11:54 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n13FBNLC017251
	for <linux-scsi@vger.kernel.org>; Tue, 3 Feb 2009 07:11:24 -0800
In-Reply-To: <bug-12163-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12163





------- Comment #7 from nikolai.kopanygin@gmail.com  2009-02-03 07:11 -------
Created an attachment (id=20092)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=20092&action=view)
A patch to fix a bug in mptsas with SAS drive hotplugging


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
