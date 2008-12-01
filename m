From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12119] iscsi repeatedly times out
Date: Sun, 30 Nov 2008 17:39:34 -0800 (PST)
Message-ID: <20081201013934.B33B7108041@picon.linux-foundation.org>
References: <bug-12119-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752299AbYLABkE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Nov 2008 20:40:04 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mB11dY0g018894
	for <linux-scsi@vger.kernel.org>; Sun, 30 Nov 2008 17:39:35 -0800
In-Reply-To: <bug-12119-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12119





------- Comment #1 from anonymous@kernel-bugs.osdl.org  2008-11-30 17:39 -------
Reply-To: michaelc@cs.wisc.edu

bugme-daemon@bugzilla.kernel.org wrote:
> Hardware Environment:diskless i386, swap on iscsi device
> Software Environment:open-iscsi v 6.2

What is the rest of this version string? With fedora run

rpm -q iscsi-initiator-utils


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
