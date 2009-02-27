From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after 2.6.20
Date: Fri, 27 Feb 2009 08:17:21 -0800 (PST)
Message-ID: <20090227161721.516A511D10A@picon.linux-foundation.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753137AbZB0QRx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 11:17:53 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1RGHLex013723
	for <linux-scsi@vger.kernel.org>; Fri, 27 Feb 2009 08:17:22 -0800
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646





------- Comment #21 from grin@grin.hu  2009-02-27 08:17 -------
#20, enlighten me in the internals, please. Can multipathd actually _cause_
driver timeouts? 

As much as I understood directio checker does nothing more than reads first and
last sector of the device by direct IO (O_DIRECT) calls, and if that fails it
fires an uevent towards userspace to handle the situation.  Can it do anything
"below", like the qla driver, or the scsi device itself?

I tried 'tur' checker in the past with mixed results, and I'm not sure it meant
the path was really down that much or the checker failed, but directio seemed
the most generic.

I thought it's the other way around, eg. qla timoeuts which makes multipathd
cry.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
