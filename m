From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14157] end_request: I/O error, dev cciss/cXdX, sector 0
Date: Sun, 13 Sep 2009 22:40:05 GMT
Message-ID: <200909132240.n8DMe5as029877@demeter.kernel.org>
References: <bug-14157-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41460 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbZIMWkC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Sep 2009 18:40:02 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n8DMe5is029878
	for <linux-scsi@vger.kernel.org>; Sun, 13 Sep 2009 22:40:05 GMT
In-Reply-To: <bug-14157-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14157


Andrew Morton <akpm@linux-foundation.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |akpm@linux-foundation.org
          Component|Other                       |Block Layer
         AssignedTo|scsi_drivers-other@kernel-b |axboe@kernel.dk
                   |ugs.osdl.org                |
            Product|SCSI Drivers                |IO/Storage
         Regression|No                          |Yes




--- Comment #2 from Andrew Morton <akpm@linux-foundation.org>  2009-09-13 22:40:04 ---
Marked as a regression.

Randomly reassigned to block layer.

Weird.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
