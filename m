From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11645] qla2xxx.ko can't load firmware binary code
Date: Thu, 25 Sep 2008 06:56:00 -0700 (PDT)
Message-ID: <20080925135600.6F69E11D107@picon.linux-foundation.org>
References: <bug-11645-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753430AbYIYN4c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2008 09:56:32 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8PDu0F0013858
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2008 06:56:01 -0700
In-Reply-To: <bug-11645-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11645





------- Comment #2 from seokmann.ju@qlogic.com  2008-09-25 06:56 -------
Created an attachment (id=18034)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=18034&action=view)
.config file for the platform tested

This is a .config file for the H/W platform that has been used for the test.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
