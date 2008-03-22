From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9010] SCSI device is not offlined properly and tries to cache data from previous device
Date: Sat, 22 Mar 2008 15:26:17 -0700 (PDT)
Message-ID: <20080322222617.4055911D109@picon.linux-foundation.org>
References: <bug-9010-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753004AbYCVW1O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Mar 2008 18:27:14 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m2MMQjq1021965
	for <linux-scsi@vger.kernel.org>; Sat, 22 Mar 2008 15:26:46 -0700
In-Reply-To: <bug-9010-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9010





------- Comment #29 from anonymous@kernel-bugs.osdl.org  2008-03-22 15:26 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Sat, 2008-03-22 at 04:52 -0700, bugme-daemon@bugzilla.kernel.org
wrote:
> Hotplug works fine on my ICH7 ports, it's just that damn jmicron controller. So
> it must be an effect trigered by a hardware or firmware "feature".
> 
> So finally someone from libata has to fix this problem?

I think so ... I don't rule out it's being caused by one of the libata
specific pieces in SCSI, but the analysis of the problem definitely has
to begin in libata.

> thanks for the explanation

You're welcome.

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
