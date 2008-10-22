From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9010] SCSI device is not offlined properly and tries to cache data from previous device
Date: Wed, 22 Oct 2008 07:07:14 -0700 (PDT)
Message-ID: <20081022140714.3C88911D108@picon.linux-foundation.org>
References: <bug-9010-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752425AbYJVOIO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2008 10:08:14 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m9ME7hUw011307
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2008 07:07:44 -0700
In-Reply-To: <bug-9010-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9010





------- Comment #31 from lkmlist@gmail.com  2008-10-22 07:07 -------
Did anyone take care of this?

If you want't I can try to reproduce it with 2.6.27.*

Kind regards
Bjoern


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
