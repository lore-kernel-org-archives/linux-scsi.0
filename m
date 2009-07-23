From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13783] udev causes high cpu usage
Date: Thu, 23 Jul 2009 00:22:54 GMT
Message-ID: <200907230022.n6N0MsaH001657@demeter.kernel.org>
References: <bug-13783-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36948 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbZGWAWy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jul 2009 20:22:54 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n6N0MsFB001658
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2009 00:22:54 GMT
In-Reply-To: <bug-13783-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13783


Andrew Morton <akpm@linux-foundation.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |akpm@linux-foundation.org




--- Comment #10 from Andrew Morton <akpm@linux-foundation.org>  2009-07-23 00:22:52 ---
(In reply to comment #9)
> I guess something goes crazy with the media-changed detection.
> Sometimes not-tested-in-such-setup/broken firmware for optical drives
> does not like us.

Seems a reasonable guess.

Do we know which device driver is being used for that drive?

In the ubuntu report at least three people are seeing the same problem.  Is
there a common point where we can address this?  Maybe a blacklist?  Or are we
dealing with three separate low-level drivers?

Thanks.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
