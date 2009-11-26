From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14563] SCSI tape driver: Spurious EIO and kernel BUG
Date: Thu, 26 Nov 2009 00:27:04 GMT
Message-ID: <200911260027.nAQ0R4DC017271@demeter.kernel.org>
References: <bug-14563-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49563 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758931AbZKZA06 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Nov 2009 19:26:58 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAQ0R4fl017272
	for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2009 00:27:04 GMT
In-Reply-To: <bug-14563-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14563





--- Comment #23 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2009-11-26 00:27:03 ---
Reply-To: fujita.tomonori@lab.ntt.co.jp

On Wed, 25 Nov 2009 16:51:25 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=14563
> 
> 
> 
> 
> 
> --- Comment #22 from Joachim Breuer <linux-kernel@jmbreuer.net>  2009-11-25 16:51:21 ---
> OK, reading back the tape from #21 yields no verify errors; it seems writing
> with FUJITA Tomonori's patch works correctly for me.

Thanks a lot!

And really sorry about the bug.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
