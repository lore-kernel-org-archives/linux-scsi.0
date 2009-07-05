From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Bug 13716] New: The AIC-7892P controller does not work any
	more
Date: Sun, 5 Jul 2009 13:51:26 -0600
Message-ID: <20090705195126.GT5480@parisc-linux.org>
References: <bug-13716-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:48755 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbZGETvX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jul 2009 15:51:23 -0400
Content-Disposition: inline
In-Reply-To: <bug-13716-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Sun, Jul 05, 2009 at 07:23:18PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=13716
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

That sounds like you have an interrupt routing problem, not a problem
with the AIC driver.  Can you bisect this down to a particular commit?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
