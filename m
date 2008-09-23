From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 5921] AIC7xxx: SCSI bus crash when formating CDRW
Date: Tue, 23 Sep 2008 01:16:51 -0700 (PDT)
Message-ID: <20080923081651.5D777108059@picon.linux-foundation.org>
References: <bug-5921-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422AbYIWIQx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2008 04:16:53 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8N8GpwS026186
	for <linux-scsi@vger.kernel.org>; Tue, 23 Sep 2008 01:16:52 -0700
In-Reply-To: <bug-5921-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=5921


emmanuel.fuste@laposte.net changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
      KernelVersion|2.6.22                      |2.6.25




------- Comment #20 from emmanuel.fuste@laposte.net  2008-09-23 01:16 -------
Latest tested kernel is 2.6.25
Will retry with 2.6.27.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
