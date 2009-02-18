From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12733] mpt fusion driver crashes with LSI22320SE installed and BIOS ACPI turned off
Date: Wed, 18 Feb 2009 07:32:09 -0800 (PST)
Message-ID: <20090218153209.1B117108045@picon.linux-foundation.org>
References: <bug-12733-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752745AbZBRPcj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2009 10:32:39 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1IFW9o4027336
	for <linux-scsi@vger.kernel.org>; Wed, 18 Feb 2009 07:32:10 -0800
In-Reply-To: <bug-12733-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12733





------- Comment #3 from anonymous@kernel-bugs.osdl.org  2009-02-18 07:32 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Tue, 2009-02-17 at 15:40 -0800, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=12733
> 
> 
> 
> 
> 
> ------- Comment #2 from mvolaski@aecom.yu.edu  2009-02-17 15:40 -------
> With an LSI 8704ELP and LSI SAS3081E-R present and ACPI off, the board works
> fine. Only the presence of an LSI 22320 causes a crash. 
> 
> I don't know about the interrupt number. When I receive the cards back, I can
> can try to find out.
> 
> Our vendor has tested at least one other manufacturer's board with the LSI
> 22320 and it, too, shows the same crashing behavior when ACPI is turned off.

But the point is that I don't think this is a MPT bug ... it's using the
IRQ line the platform code assigns to it.  If that IRQ line is wrong,
you get the symptoms you're displaying (misrouted IRQ).

I'm not even sure this is a bug:  some modern motherboards simply can't
be configured without ACPI because there's no way to get the IRQ routing
information otherwise.

If your motherboard isn't one of these, then it could be a failure of
the non-ACPI IRQ routing platform code.  None of this can be diagnosed
from the snippet of the log you posted.

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
