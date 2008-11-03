From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11943] Boot fails at scsi0:MESH with hde: lost interrupt, AEC6260
Date: Mon,  3 Nov 2008 00:27:57 -0800 (PST)
Message-ID: <20081103082757.6903A108040@picon.linux-foundation.org>
References: <bug-11943-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754566AbYKCI21 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Nov 2008 03:28:27 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA38Rv9s006224
	for <linux-scsi@vger.kernel.org>; Mon, 3 Nov 2008 00:27:58 -0800
In-Reply-To: <bug-11943-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11943


akpm@osdl.org changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|SCSI                        |IDE




------- Comment #1 from akpm@osdl.org  2008-11-03 00:27 -------
Thanks - I'll reassign this to io-ide (although it sounds like an
acpi or x86 problem).


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
