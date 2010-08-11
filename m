From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16558] iSCSI Connection / Stability Problems
Date: Wed, 11 Aug 2010 03:22:36 GMT
Message-ID: <201008110322.o7B3MavC000560@demeter.kernel.org>
References: <bug-16558-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37661 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168Ab0HKDWh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2010 23:22:37 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o7B3MaQT000561
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Aug 2010 03:22:36 GMT
In-Reply-To: <bug-16558-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16558





--- Comment #2 from peepstein@gmail.com  2010-08-11 03:22:35 ---
(In reply to comment #1)
> Reply-To: fujita.tomonori@lab.ntt.co.jp
> 
> On Tue, 10 Aug 2010 23:31:19 GMT
> bugzilla-daemon@bugzilla.kernel.org wrote:
> 
> > I've tried with both the standalone iscsi-target 1.4.20.2 kernel module and
> > with the tgt userspace iSCSI tool without the iscsi-target module-- so using
> 
> iscsi-target 1.4.20 is an out-of-tree kernel module. So reporting the
> problem to linux-scsi doesn't help. Use
> iscsitarget-devel@lists.sourceforge.net instead.
> 
> 
> > whatever kernel hooks exist for iSCSI that, I believe, have been in the kernel
> > since 2.6.20 (according to stgt.sourceforge.net).
> 
> You confuse two different iSCSI implementations. Seems that Ubuntu
> supports two different implementations:
> 
> iscsitarget.sourceforge.net
> stgt.sourceforge.net
> 
> The log says that you use the former. If you use the latter and hit a
> problem, please report it to stgt@vger.kernel.org.


I have the same problem with the latter as the former, it makes no difference. 
I should also mention that one particular symptom is that if I have an ssh
connection open to the server,  it will stall. Keypresses aren't registered in
the ssh session--- however,  if I bang on the console keyboard which is
connected directly to the server via USB,  the ssh session comes back to life,
spewing my keypresses back to me.  As well,  when I bang on the console USB
keyboard,   the console spews the sequence error messages that I posted in my
description.  In addition, the iSCSI connection seems to come back to life too.
 However I can't be sitting at the console and banging on the keyboard every
two minutes to ensure that my connection stays up.  :)

The behaviour is the same regardless of whether I use tgt or iscsitarget.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
