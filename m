From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 13716] New: The AIC-7892P controller does not work any
 more
Date: Sun, 05 Jul 2009 14:54:16 -0500
Message-ID: <1246823656.4158.20.camel@mulgrave.site>
References: <bug-13716-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39894 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191AbZGETyR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jul 2009 15:54:17 -0400
In-Reply-To: <bug-13716-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

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


