From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive gives EBUSY
Date: Mon, 22 Dec 2008 10:09:40 -0800 (PST)
Message-ID: <20081222180940.757A0108041@picon.linux-foundation.org>
References: <bug-12207-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752945AbYLVSKL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Dec 2008 13:10:11 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBMI9eTa016808
	for <linux-scsi@vger.kernel.org>; Mon, 22 Dec 2008 10:09:41 -0800
In-Reply-To: <bug-12207-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12207


alan@lxorguk.ukuu.org.uk changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
      KernelVersion|2.6.16                      |2.6.27




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
