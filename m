From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9010] SCSI device is not offlined properly and tries to cache data from previous device
Date: Sat, 22 Mar 2008 04:52:27 -0700 (PDT)
Message-ID: <20080322115227.EB80F10803D@picon.linux-foundation.org>
References: <bug-9010-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754776AbYCVLxB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Mar 2008 07:53:01 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m2MBqT0U013362
	for <linux-scsi@vger.kernel.org>; Sat, 22 Mar 2008 04:52:30 -0700
In-Reply-To: <bug-9010-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9010





------- Comment #28 from lkmlist@gmail.com  2008-03-22 04:52 -------
Hotplug works fine on my ICH7 ports, it's just that damn jmicron controller. So
it must be an effect trigered by a hardware or firmware "feature".

So finally someone from libata has to fix this problem?

thanks for the explanation

regards
Bjoern


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
