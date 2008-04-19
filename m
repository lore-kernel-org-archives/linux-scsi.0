From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10486] kernel 2.6.24  4G FC arrays don't work properly with qla2xxx driver
Date: Sat, 19 Apr 2008 15:04:36 -0700 (PDT)
Message-ID: <20080419220436.448F410805F@picon.linux-foundation.org>
References: <bug-10486-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754624AbYDSWEz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Apr 2008 18:04:55 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m3JM4rba029555
	for <linux-scsi@vger.kernel.org>; Sat, 19 Apr 2008 15:04:54 -0700
In-Reply-To: <bug-10486-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10486


dsd@gentoo.org changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kernel@gentoo.org
      KernelVersion|2.6.25                      |2.6.24+
         Regression|0                           |1
            Summary|kernel 2.6.25  4G FC arrays |kernel 2.6.24  4G FC arrays
                   |don't work properly with    |don't work properly with
                   |qla2xxx driver              |qla2xxx driver




------- Comment #1 from dsd@gentoo.org  2008-04-19 15:04 -------
This is a 2.6.24 regression

Downstream bug:
https://bugs.gentoo.org/show_bug.cgi?id=214883


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
