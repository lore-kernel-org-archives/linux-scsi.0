From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11302] I get a kernel OOPS! If I try to attach an usb card reader, SD, MMC, ecc.. to my Slamd64
Date: Mon,  1 Sep 2008 23:04:00 -0700 (PDT)
Message-ID: <20080902060400.93FDD108059@picon.linux-foundation.org>
References: <bug-11302-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751925AbYIBGEb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Sep 2008 02:04:31 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m82640gx024619
	for <linux-scsi@vger.kernel.org>; Mon, 1 Sep 2008 23:04:01 -0700
In-Reply-To: <bug-11302-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11302





------- Comment #9 from anonymous@kernel-bugs.osdl.org  2008-09-01 23:04 -------
Reply-To: drzeus@drzeus.cx

On Mon, 1 Sep 2008 23:30:56 +0000 (GMT)
pinco pallino <pinc_o@yahoo.it> wrote:

> Hi Andrew,
> 
> with the new kernel 2.6.26.3 the SD are now read and wrote correctly, but SDHC are not read! The kernel repeat the error. Follow the error:
> 

Have you checked that the reader does in fact support SDHC? They tend
to fail in all sorts of ways when they don't.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
