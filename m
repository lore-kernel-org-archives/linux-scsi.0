From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12163] mptsas driver cannot discover some hotplugged SATA/SAS disks
Date: Fri,  5 Dec 2008 05:18:44 -0800 (PST)
Message-ID: <20081205131844.BC83E10800F@picon.linux-foundation.org>
References: <bug-12163-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625AbYLENSq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 08:18:46 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mB5DIiWZ013340
	for <linux-scsi@vger.kernel.org>; Fri, 5 Dec 2008 05:18:45 -0800
In-Reply-To: <bug-12163-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12163





------- Comment #2 from crquan@gmail.com  2008-12-05 05:18 -------
Created an attachment (id=19155)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=19155&action=view)
The vendor driver 4.00.43.00 from LSI Corporation

http://www.lsi.com/storage_home/products_home/standard_product_ics/sas_ics/lsisas1068e/index.html

It's just the vendor driver from LSI, you can also download from it and extract
them under drivers instead of applying this patch.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
