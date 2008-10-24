From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11817] SCSI: timing out command for dvd drive
Date: Fri, 24 Oct 2008 08:55:50 -0700 (PDT)
Message-ID: <20081024155550.BB34A108048@picon.linux-foundation.org>
References: <bug-11817-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753891AbYJXPzx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Oct 2008 11:55:53 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m9OFtoFm028842
	for <linux-scsi@vger.kernel.org>; Fri, 24 Oct 2008 08:55:52 -0700
In-Reply-To: <bug-11817-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11817





------- Comment #4 from anonymous@kernel-bugs.osdl.org  2008-10-24 08:55 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Fri, 2008-10-24 at 08:39 -0700, bugme-daemon@bugzilla.kernel.org
wrote:
> ------- Comment #3 from khali@linux-fr.org  2008-10-24 08:39 -------
> Same problem here.

This is Jens' tag cockup:

http://marc.info/?t=122483204900001

Isn't it?

CDs are also no-NCQ devices.

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
