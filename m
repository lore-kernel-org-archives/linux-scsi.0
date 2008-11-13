From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12020] scsi_times_out NULL pointer dereference
Date: Thu, 13 Nov 2008 12:12:16 -0800 (PST)
Message-ID: <20081113201216.BB3A911D107@picon.linux-foundation.org>
References: <bug-12020-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420AbYKMUMu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2008 15:12:50 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mADKCGGj010245
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2008 12:12:17 -0800
In-Reply-To: <bug-12020-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12020





------- Comment #2 from bs@q-leap.de  2008-11-13 12:12 -------
Thanks going to test it now. 

While we are at this function, could you please check 

        if (eh_timed_out)
                rtn = eh_timed_out(scmd);
                switch (rtn) {
                case BLK_EH_NOT_HANDLED:
                        break;
                default:
                        return rtn;
                }


Is the indentation wrong or are there missing if-braces?


Thanks,
Bernd


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
