From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14877] MSI/MSI-X support in 2.6.31.xx and 2.6.32.xx seems
 broken
Date: Thu, 14 Jan 2010 23:02:20 GMT
Message-ID: <201001142302.o0EN2KoJ024874@demeter.kernel.org>
References: <bug-14877-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47929 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab0ANXCV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2010 18:02:21 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0EN2Kqk024875
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jan 2010 23:02:20 GMT
In-Reply-To: <bug-14877-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14877





--- Comment #3 from Andrew Morton <akpm@linux-foundation.org>  2010-01-14 23:02:19 ---
(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Thu, 14 Jan 2010 22:27:18 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=14877
> 
> 
> Andrew Morton <akpm@linux-foundation.org> changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |akpm@linux-foundation.org,
>                    |                            |james.smart@emulex.com
>           Component|PCI                         |Other
>          AssignedTo|drivers_pci@kernel-bugs.osd |scsi_drivers-other@kernel-b
>                    |l.org                       |ugs.osdl.org
>             Product|Drivers                     |SCSI Drivers
>          Regression|No                          |Yes
> 
> 
> 
> 
> --- Comment #2 from Andrew Morton <akpm@linux-foundation.org>  2010-01-14 22:27:15 ---
> Thanks.  I'll mark this as a regression, shall reassign to scsi and shall ask
> you to email a signed-off version of that patch.
> 

Oleg, please send that lpfc patch via emailed reply-to-all to this email. 
Include a brief description for the changelog and a Signed-off-by: as
per Documentation/SubmittingPatches, thanks.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
