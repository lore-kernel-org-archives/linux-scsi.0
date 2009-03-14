From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12759] scsi: aic7xxx hang since v2.6.28-rc1 ...
Date: Sat, 14 Mar 2009 15:52:21 -0700 (PDT)
Message-ID: <20090314225222.0137C108042@picon.linux-foundation.org>
References: <bug-12759-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752551AbZCNWxc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Mar 2009 18:53:32 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2EMqMTd022578
	for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2009 15:52:57 -0700
In-Reply-To: <bug-12759-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12759





------- Comment #2 from anonymous@kernel-bugs.osdl.org  2009-03-14 15:52 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Sat, 2009-03-14 at 14:18 -0700, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=12759
> 
> 
> rjw@sisk.pl changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>              Status|NEW                         |CLOSED
>          Resolution|                            |CODE_FIX
> 
> 
> 
> 
> ------- Comment #1 from rjw@sisk.pl  2009-03-14 14:18 -------
> The problem seems to have been fixed, closing.

Actually, I don't think the problem is gone, it's just gone into hiding
again.  What seems to happen is that as we alter code in scsi_lib.c,
particularly along the completion paths, it reappears and then
disappears again.  It looks like some obscure timing related bug,
possibly in the aic7xxx driver, or possibly in the mid-layer 

I've rebuilt my main SCSI test box to be aic7xxx based to see if we can
somehow find it again and debug it.

So, I'd like this bug left open against SCSI please, but you can
probably remove it as a current regression (I think it's probably been
hiding for a very long time).

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
