From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12020] scsi_times_out NULL pointer dereference
Date: Thu, 13 Nov 2008 10:40:05 -0800 (PST)
Message-ID: <20081113184005.22E70108040@picon.linux-foundation.org>
References: <bug-12020-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751447AbYKMSkH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2008 13:40:07 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mADIe5Ha003580
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2008 10:40:06 -0800
In-Reply-To: <bug-12020-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12020


akpm@osdl.org changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Regression|0                           |1




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
