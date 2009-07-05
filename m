From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13716] The AIC-7892P controller does not work any more
Date: Sun, 5 Jul 2009 19:54:23 GMT
Message-ID: <200907051954.n65JsNpA023078@demeter.kernel.org>
References: <bug-13716-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43368 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbZGETyU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jul 2009 15:54:20 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n65JsNPv023079
	for <linux-scsi@vger.kernel.org>; Sun, 5 Jul 2009 19:54:23 GMT
In-Reply-To: <bug-13716-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13716





--- Comment #2 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2009-07-05 19:54:23 ---
Reply-To: James.Bottomley@HansenPartnership.com

On Sun, 2009-07-05 at 19:23 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=13716
> 
>            Summary: The AIC-7892P controller does not work any more
>            Product: SCSI Drivers
>            Version: 2.5
>     Kernel Version: 2.6.31-rc1. 2.6.31-rc1-git10
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: Other
>         AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
>         ReportedBy: andrej@podzimek.org
>         Regression: Yes
> 
> 
> The usual probe fails with an error message saying that no IRQ could be
> assigned to the controller, possibly due to a corrupt MP table.
> 
> The controller works fine with 2.6.30.1 and below.
> 
> This is how the adapter is normally initialized (messages from 2.6.29.6):
>     aic7xxx 0000:01:03.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
>     scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
>     <Adaptec aic7892 Ultra160 SCSI adapter>
>     aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
> 
> With 2.6.31-rc1, the kernel freezes with an error message and tries to restart
> the controller periodically, which always fails.

OK, so I have a 7896 which acts as the root controller of my SCSI test
system and it's not showing any such problems.  Does this actually work
at all, or does it never work (this could indicate an interrupt routing
problem).  

We're also going to need the kernel logs, with the initialisation
sequence and the actual errors, please.

Thanks,

James

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
