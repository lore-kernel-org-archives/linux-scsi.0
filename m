From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11589] Mass-storage USB Device does not show up when CONFIG_SCSI_MULTI_LUN is set
Date: Thu, 18 Sep 2008 18:23:56 -0700 (PDT)
Message-ID: <20080919012356.ED2D5108047@picon.linux-foundation.org>
References: <bug-11589-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754968AbYISBX6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Sep 2008 21:23:58 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8J1Nvao000319
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2008 18:23:58 -0700
In-Reply-To: <bug-11589-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11589





------- Comment #1 from nico@lifeisabug.com  2008-09-18 18:23 -------
Created an attachment (id=17872)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=17872&action=view)
dmesg output when CONFIG_SCSI_MULTI_LUN is DISABLED


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
