From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15007] SCSI host adapter's scatter-gather list size Issue
Date: Mon, 18 Jan 2010 04:18:13 GMT
Message-ID: <201001180418.o0I4IDI7008628@demeter.kernel.org>
References: <bug-15007-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55802 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab0ARESN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Jan 2010 23:18:13 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0I4ID4f008629
	for <linux-scsi@vger.kernel.org>; Mon, 18 Jan 2010 04:18:13 GMT
In-Reply-To: <bug-15007-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15007





--- Comment #8 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2010-01-18 04:18:08 ---
Reply-To: fujita.tomonori@lab.ntt.co.jp

On Fri, 15 Jan 2010 02:49:53 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=15007
> 
> 
> 
> 
> 
> --- Comment #6 from nick cheng <nick.cheng@areca.com.tw>  2010-01-15 02:49:48 ---
> OK. I got it.
> But based on 128 sg entries issue on my original driver I found it bugs every
> time while doing mkfs.ext3 on a default NTFS filesystem, but if I do it on a
> ext3 filesystem, it works smoothly.

Do you mean that 128 sg entries don't cause any problems during
performing mkfs on ext3? If so, I have no idea.


> Besides, it bugs on SMP platforms always but doesn't on non-SMP plaform.
> Can your inference explain it?

Do you mean that 128 sg entries don't cause any problems on non SMP
boxes? If so, I have no idea. Your driver should hit this bug with any
boxes.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
