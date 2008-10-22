From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11804] iscsi: LRO plus iSCSI causes panic
Date: Tue, 21 Oct 2008 17:28:27 -0700 (PDT)
Message-ID: <20081022002827.606B4108048@picon.linux-foundation.org>
References: <bug-11804-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751848AbYJVA25 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2008 20:28:57 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m9M0SRvt024327
	for <linux-scsi@vger.kernel.org>; Tue, 21 Oct 2008 17:28:28 -0700
In-Reply-To: <bug-11804-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11804


akpm@osdl.org changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|acme@ghostprotocols.net     |linux-scsi@vger.kernel.org
          Component|Other                       |SCSI
            Product|Networking                  |IO/Storage




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
