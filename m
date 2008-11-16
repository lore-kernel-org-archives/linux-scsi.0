From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12020] scsi_times_out NULL pointer dereference
Date: Sun, 16 Nov 2008 09:50:26 -0800 (PST)
Message-ID: <20081116175026.BE30611D107@picon.linux-foundation.org>
References: <bug-12020-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752078AbYKPRu6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Nov 2008 12:50:58 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mAGHoQQn004222
	for <linux-scsi@vger.kernel.org>; Sun, 16 Nov 2008 09:50:27 -0800
In-Reply-To: <bug-12020-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12020





------- Comment #5 from rjw@sisk.pl  2008-11-16 09:50 -------
Patch : http://bugzilla.kernel.org/show_bug.cgi?id=12020#c4
Handled-By : James Bottomley <James.Bottomley@HansenPartnership.com>


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
