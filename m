From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 7630] os_scsi_tapes_lock should not be acquired before calling new_tape_buffer
Date: Thu, 25 Sep 2008 12:51:13 -0700 (PDT)
Message-ID: <20080925195113.66C8311D10E@picon.linux-foundation.org>
References: <bug-7630-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753223AbYIYTvv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2008 15:51:51 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8PJpLcU006359
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2008 12:51:22 -0700
In-Reply-To: <bug-7630-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=7630





------- Comment #6 from tammy000@gmail.com  2008-09-25 12:51 -------
A patch was sent. 


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
