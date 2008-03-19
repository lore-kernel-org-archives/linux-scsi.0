From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9010] SCSI device is not offlined properly and tries to cache data from previous device
Date: Wed, 19 Mar 2008 01:43:44 -0700 (PDT)
Message-ID: <20080319084344.0FDE310806C@picon.linux-foundation.org>
References: <bug-9010-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978AbYCSTYp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2008 15:24:45 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m2J8jSEu012699
	for <linux-scsi@vger.kernel.org>; Wed, 19 Mar 2008 01:45:29 -0700
In-Reply-To: <bug-9010-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9010


protasnb@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |linux-scsi@vger.kernel.org




------- Comment #24 from protasnb@gmail.com  2008-03-19 01:43 -------
Since bug analysis shows this is scsi layer problem - copying to SCSI devel


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
