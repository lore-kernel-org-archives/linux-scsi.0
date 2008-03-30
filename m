From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 5921] AIC7xxx: SCSI bus crash when formating CDRW
Date: Sun, 30 Mar 2008 11:55:06 -0700 (PDT)
Message-ID: <20080330185506.6D21E108039@picon.linux-foundation.org>
References: <bug-5921-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752288AbYC3Szj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Mar 2008 14:55:39 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m2UIt6ep030415
	for <linux-scsi@vger.kernel.org>; Sun, 30 Mar 2008 11:55:07 -0700
In-Reply-To: <bug-5921-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=5921





------- Comment #19 from emmanuel.fuste@laposte.net  2008-03-30 11:55 -------
Created an attachment (id=15515)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=15515&action=view)
crash log march 30 2008

I was able to restart cleanly the computer whith the magic Ctrl+Alt+del combo
keys, but it took ~1hour.
sr0 is on the narrow bus.
The recovery path still impact non involved devices like sda witch is on the
wide bus and wich consequently never fully recover too. 
There is two questions (two bugs too ?)
- why formating a cdrw crash the HBA
- why the recovery code never recover and take sr0 AND sda in a never ending
spiral.
Complete log attached.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
