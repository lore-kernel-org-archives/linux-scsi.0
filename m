From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14877] MSI/MSI-X support in 2.6.31.xx and 2.6.32.xx seems
 broken
Date: Sat, 23 Jan 2010 15:36:41 GMT
Message-ID: <201001231536.o0NFafvr009935@demeter.kernel.org>
References: <bug-14877-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33359 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab0AWPgm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Jan 2010 10:36:42 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0NFafxZ009936
	for <linux-scsi@vger.kernel.org>; Sat, 23 Jan 2010 15:36:41 GMT
In-Reply-To: <bug-14877-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14877





--- Comment #10 from Oleg Gawriloff <barzog@telecom.by>  2010-01-23 15:36:40 ---
Tried (I'm on Gentoo) on 2.6.32.4 kernel:
/etc/modules.autoload.d/kernel-2.6:
lpfc lpfc_use_msi=2

nothing changes (still on IO-APIC-fasteoi).

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
