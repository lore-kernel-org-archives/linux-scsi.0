From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Bug 16558] New: iSCSI Connection / Stability Problems
Date: Wed, 11 Aug 2010 11:33:59 +0900
Message-ID: <20100811113231N.fujita.tomonori@lab.ntt.co.jp>
References: <bug-16558-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:56882 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757937Ab0HKCek (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Aug 2010 22:34:40 -0400
In-Reply-To: <bug-16558-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

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
