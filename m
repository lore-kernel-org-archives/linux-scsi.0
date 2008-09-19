From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11589] Mass-storage USB Device does not show up when CONFIG_SCSI_MULTI_LUN is set
Date: Thu, 18 Sep 2008 18:24:54 -0700 (PDT)
Message-ID: <20080919012454.55E22108047@picon.linux-foundation.org>
References: <bug-11589-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755581AbYISBY4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Sep 2008 21:24:56 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8J1Os7Y000359
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2008 18:24:55 -0700
In-Reply-To: <bug-11589-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11589





------- Comment #2 from nico@lifeisabug.com  2008-09-18 18:24 -------
Created an attachment (id=17873)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=17873&action=view)
dmesg output when CONFIG_SCSI_MULTI_LUN is ENABLED


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
