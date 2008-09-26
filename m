From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11645] qla2xxx.ko can't load firmware binary code
Date: Fri, 26 Sep 2008 05:14:34 -0700 (PDT)
Message-ID: <20080926121434.7D45611D11A@picon.linux-foundation.org>
References: <bug-11645-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318AbYIZMPM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2008 08:15:12 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8QCEehu008698
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2008 05:14:41 -0700
In-Reply-To: <bug-11645-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11645





------- Comment #7 from nerijus.kislauskas@ktu.lt  2008-09-26 05:14 -------
Hi guys,

Andrew, thanks for pointing me to right direction. The problem was my kernel
configuration. I enabled this option:

CONFIG_TMPFS=y

in 2.6.24.5, and everything works fine. tmpfs somehow related to udev and
uevents. No doubt, that it will work in other versions too. Thanks again. You
may now close this ticket.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
