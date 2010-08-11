From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16558] iSCSI Connection / Stability Problems
Date: Wed, 11 Aug 2010 03:11:47 GMT
Message-ID: <201008110311.o7B3Blfu031462@demeter.kernel.org>
References: <bug-16558-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43624 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758096Ab0HKDLs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2010 23:11:48 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o7B3BlTL031463
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Aug 2010 03:11:47 GMT
In-Reply-To: <bug-16558-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16558





--- Comment #1 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2010-08-11 03:11:44 ---
Reply-To: fujita.tomonori@lab.ntt.co.jp

On Tue, 10 Aug 2010 23:31:19 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=16558
> 
>            Summary: iSCSI Connection / Stability Problems
>            Product: IO/Storage
>            Version: 2.5
>     Kernel Version: 2.6.32-02063215
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: SCSI
>         AssignedTo: linux-scsi@vger.kernel.org
>         ReportedBy: peepstein@gmail.com
>         Regression: No
> 
> 
> Created an attachment (id=27400)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=27400)
>  --> (https://bugzilla.kernel.org/attachment.cgi?id=27400)
> Output of lspci -vv and dmesg
> 
> Hi All,  I am using the Atto Xtend SAN Initiator on a couple of Mac OS X
> computers (one desktop, one laptop).  I've also tried using the globalSAN
> initiator on the laptop and with both initiators I've had the same problem.
> 
> The target is running on a fresh Ubuntu Server 10.04.1 install, and I have the
> problem regardless of whether I run the Ubuntu kernel (2.6.32-24-server) or the
> mainline kernel from the Ubuntu Mainline package (2.6.32-02063215).
> 
> The server hardware is a new build of new components and I am trying to rule
> out flaky hardware as well so if you see anything that might indicate that
> please let me know.
> 
> I have the same problem regardless of whether I use my PCI Intel Gigabit NIC or
> the PCI-Express built-in Realtek NIC. I've also installed and tried with the
> latest drivers downloaded from the Realtek site.
> 
> I've tried with both the standalone iscsi-target 1.4.20.2 kernel module and
> with the tgt userspace iSCSI tool without the iscsi-target module-- so using

iscsi-target 1.4.20 is an out-of-tree kernel module. So reporting the
problem to linux-scsi doesn't help. Use
iscsitarget-devel@lists.sourceforge.net instead.


> whatever kernel hooks exist for iSCSI that, I believe, have been in the kernel
> since 2.6.20 (according to stgt.sourceforge.net).

You confuse two different iSCSI implementations. Seems that Ubuntu
supports two different implementations:

iscsitarget.sourceforge.net
stgt.sourceforge.net

The log says that you use the former. If you use the latter and hit a
problem, please report it to stgt@vger.kernel.org.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
