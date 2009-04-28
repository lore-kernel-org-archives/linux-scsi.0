From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13143] scsi_debug doesn't manage more than 1Tb
Date: Tue, 28 Apr 2009 08:33:48 GMT
Message-ID: <200904280833.n3S8XmVV018835@demeter.kernel.org>
References: <bug-13143-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49160 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbZD1Idt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2009 04:33:49 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n3S8Xmkk018836
	for <linux-scsi@vger.kernel.org>; Tue, 28 Apr 2009 08:33:48 GMT
In-Reply-To: <bug-13143-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13143





--- Comment #5 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2009-04-28 08:32:02 ---
Reply-To: fujita.tomonori@lab.ntt.co.jp

On Mon, 27 Apr 2009 10:41:00 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=13143
> 
> 
> 
> 
> 
> --- Comment #4 from Thierry Vignaud <tvignaud@mandriva.com>  2009-04-27 10:39:15 ---
> (In reply to comment #1)
> > it seems invalid that you tested linux 2.5 ?
> 
> Version was auto filled by bugzilla. Really was 2.6.29.1
> 
> > And could you describe it more detailed as in REPORTING-BUGS ?
> 
> All needed data was provided in initial comment. And it was enough in order to
> provide a fix.

The patch is available:

http://marc.info/?l=linux-scsi&m=124063464410711&w=2


Can you confirm that it fixes the problem?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
