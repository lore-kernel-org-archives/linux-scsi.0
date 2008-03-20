From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 6280] new line of Xyratex RAID products and a patch to update for 2.4.x non-sequential LUN mapping
Date: Thu, 20 Mar 2008 06:52:38 -0700 (PDT)
Message-ID: <20080320135238.818C610803B@picon.linux-foundation.org>
References: <bug-6280-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754804AbYCTNxH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2008 09:53:07 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m2KDqcHh015770
	for <linux-scsi@vger.kernel.org>; Thu, 20 Mar 2008 06:52:39 -0700
In-Reply-To: <bug-6280-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=6280





------- Comment #3 from anonymous@kernel-bugs.osdl.org  2008-03-20 06:52 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Thu, 2008-03-20 at 00:34 -0700, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=6280
> 
> 
> protasnb@gmail.com changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |protasnb@gmail.com
>          AssignedTo|scsi_drivers-other@kernel-  |linux-scsi@vger.kernel.org
>                    |bugs.osdl.org               |
> 
> 
> 
> 
> ------- Comment #2 from protasnb@gmail.com  2008-03-20 00:34 -------
> Petros,
> This bugzilla is about 2.6.XX. Do you think your patch makes sense for latest
> kernels, or this support is already implemented there?

Depends what SCSI level the array reports.  If > 2 then the REPORT_LUNS
scan will already have taken care of all of this.

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
