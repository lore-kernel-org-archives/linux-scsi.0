From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14159] AIC79xx is not working properly with an attached scsi
 tape since 2.6.29
Date: Tue, 15 Sep 2009 13:53:40 GMT
Message-ID: <200909151353.n8FDreU8008650@demeter.kernel.org>
References: <bug-14159-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42050 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbZIONxh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2009 09:53:37 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n8FDrect008651
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2009 13:53:41 GMT
In-Reply-To: <bug-14159-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14159





--- Comment #9 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2009-09-15 13:53:40 ---
Reply-To: James.Bottomley@suse.de

On Tue, 2009-09-15 at 07:05 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=14159

cc'ing linux-acpi

James

> --- Comment #7 from g.giorgetti@teamsystem.com  2009-09-15 07:05:46 ---
> Hi Bjorn and James,
> 
> pci=noacpi is not working, so even before reading Bjorn's reply, we tried
> "noapic" and the suddenly the tape device was working again. No more timeouts
> on initialization and so on.
> 
> I haven't tried pci=noioapicquirk yet, since the server is up for production
> and other people is working. 
> So I'm gonna do that later in the day.
> 
> Thank you very much for now.
> 
> Regards,
>  Gabriele
>

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
