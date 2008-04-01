From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10374] sym53c8xx: weird behavior with udev
Date: Tue,  1 Apr 2008 01:58:37 -0700 (PDT)
Message-ID: <20080401085837.4BCC410803B@picon.linux-foundation.org>
References: <bug-10374-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755212AbYDAI7H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Apr 2008 04:59:07 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m318wbMi021359
	for <linux-scsi@vger.kernel.org>; Tue, 1 Apr 2008 01:58:38 -0700
In-Reply-To: <bug-10374-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10374





------- Comment #2 from seraph@xs4all.nl  2008-04-01 01:58 -------
On Tue, 1 Apr 2008 01:15:18 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
> 
> urgh.  Perhaps it's related to platform IRQ routing or something.
> 
> I'd suggest that the next step would be to send us the `dmesg -s 1000000'
> output for both good and bad kernels.  A comparison might show where things
> went bad.

Alright, here goes. Attached three files.

dmesg-2.6.22.9-good.txt is the dmesg output from 2.6.22.9 where everything
works as it should.
dmesg-2.6.24.4-bad.txt is the dmesg output from 2.6.24.4 with sym53cxx loaded
by udev and the network not responding.
dmesg-2.6.24.4-good.txt is the dmesg output from 2.6.24.4 with sym53cxx
blacklisted and the network working fine.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
