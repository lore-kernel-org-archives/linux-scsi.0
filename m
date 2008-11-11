From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11898] mke2fs hang on AIC79 device.
Date: Tue, 11 Nov 2008 03:23:08 -0800 (PST)
Message-ID: <20081111112308.5C650108048@picon.linux-foundation.org>
References: <bug-11898-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755382AbYKKLXZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2008 06:23:25 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mABBN8l2007458
	for <linux-scsi@vger.kernel.org>; Tue, 11 Nov 2008 03:23:09 -0800
In-Reply-To: <bug-11898-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11898





------- Comment #33 from vandrove@vc.cvut.cz  2008-11-11 03:23 -------
Created an attachment (id=18799)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=18799&action=view)
Kernel NULL pointer dereference with patch from update #28


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
