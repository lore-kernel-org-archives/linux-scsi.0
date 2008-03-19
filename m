From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9010] SCSI device is not offlined properly and tries to cache data from previous device
Date: Wed, 19 Mar 2008 13:24:42 -0700 (PDT)
Message-ID: <20080319202442.EF8BC10803F@picon.linux-foundation.org>
References: <bug-9010-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759636AbYCSUZX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2008 16:25:23 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m2JKP1oC010952
	for <linux-scsi@vger.kernel.org>; Wed, 19 Mar 2008 13:25:03 -0700
In-Reply-To: <bug-9010-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9010





------- Comment #25 from anonymous@kernel-bugs.osdl.org  2008-03-19 13:24 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Wed, 2008-03-19 at 01:43 -0700, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=9010
> 
> 
> protasnb@gmail.com changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |linux-scsi@vger.kernel.org
> 
> 
> 
> 
> ------- Comment #24 from protasnb@gmail.com  2008-03-19 01:43 -------
> Since bug analysis shows this is scsi layer problem - copying to SCSI devel

That's rather a long bug report; what I can't seem to find is a
description of what the problem actually is.  If I had to guess I'd say
that unplugging and replugging a different SATA drive in the same slot
doesn't properly get the parameters of the new device; is that it?

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
