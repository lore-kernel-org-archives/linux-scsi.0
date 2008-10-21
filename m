From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10974] 2.6.25 regression: delay needed after audio CD insertion
Date: Tue, 21 Oct 2008 02:37:43 -0700 (PDT)
Message-ID: <20081021093743.B1A7B108047@picon.linux-foundation.org>
References: <bug-10974-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752107AbYJUJiP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2008 05:38:15 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m9L9bhFI024257
	for <linux-scsi@vger.kernel.org>; Tue, 21 Oct 2008 02:37:44 -0700
In-Reply-To: <bug-10974-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10974





------- Comment #1 from geert@linux-m68k.org  2008-10-21 02:37 -------
I wrote:
| (I could reproduce it on an Athlon with sym53c8xx SCSI running a Debianized
|  2.6.25 kernel, too, but I didn't try a 2.6.24 kernel there)

However, I gave a Debianized 2.6.24 kernel a try on the machine above. It
behaved differently, but it still didn't work.

CD-ROM specs:
  Vendor: PLEXTOR  Model: CD-R   PX-W1210S Rev: 1.01
  Type:   CD-ROM                           ANSI  SCSI revision: 02

So perhaps it's just a fortunate `accident' the above command sequence works on
PS3 on 2.6.x with x <= 24?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
