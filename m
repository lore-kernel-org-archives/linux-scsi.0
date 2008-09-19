From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11589] Mass-storage USB Device does not show up when CONFIG_SCSI_MULTI_LUN is set
Date: Thu, 18 Sep 2008 19:40:59 -0700 (PDT)
Message-ID: <20080919024059.903C510805D@picon.linux-foundation.org>
References: <bug-11589-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754491AbYISClC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Sep 2008 22:41:02 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8J2exp8003881
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2008 19:41:00 -0700
In-Reply-To: <bug-11589-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11589





------- Comment #4 from anonymous@kernel-bugs.osdl.org  2008-09-18 19:40 -------
Reply-To: mdharm-scsi@one-eyed-alien.net

On Thu, Sep 18, 2008 at 07:12:31PM -0700, Andrew Morton wrote:
> On Thu, 18 Sep 2008 18:22:23 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> 
> > When CONFIG_SCSI_MULTI_LUN is set, the memory card does not show up as it
> > should, I only see /dev/sdd but not /dev/sdd1 - it's unable to mount it that
> > way.
> > When CONFIG_SCSI_MULTI_LUN is not set, it does show up as /dev/sdd1 but gives
> > me loads of warnings like "attempt to access beyond end of device", see dmesg
> > for that. This way it is mountable and works fine except the warnings.

If /dev/sdd shows up but not /dev/sdd1, then this is probably actually the
partition parsing code.  There was a change to reject badly formed
partitions; I believe someone is trying to revert that change.

Matt


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
