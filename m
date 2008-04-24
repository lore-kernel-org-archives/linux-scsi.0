From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10486] kernel 2.6.24  4G FC arrays don't work properly with qla2xxx driver
Date: Thu, 24 Apr 2008 14:18:11 -0700 (PDT)
Message-ID: <20080424211811.93A7F11D10A@picon.linux-foundation.org>
References: <bug-10486-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753317AbYDXVSn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2008 17:18:43 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m3OLIBr4021244
	for <linux-scsi@vger.kernel.org>; Thu, 24 Apr 2008 14:18:12 -0700
In-Reply-To: <bug-10486-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10486





------- Comment #12 from andrew.vasquez@qlogic.com  2008-04-24 14:18 -------
Created an attachment (id=15901)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=15901&action=view)
Correct relogin logic

Ok, I've reproduced this issue locally.  Could you try the
attached patch within your configuration?  I'll queue this
fix along with my latest batch of updates to linux-scsi. 

Unfortunately, as it turns out, this particular issue was
resolved some time back in the QLogic standard driver but
was missed for upstream inclusion (argg..).


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
