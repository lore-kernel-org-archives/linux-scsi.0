From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15007] SCSI host adapter's scatter-gather list size Issue
Date: Mon, 18 Jan 2010 09:42:00 GMT
Message-ID: <201001180942.o0I9g0qB016055@demeter.kernel.org>
References: <bug-15007-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42115 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab0ARJmB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2010 04:42:01 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0I9g0aD016056
	for <linux-scsi@vger.kernel.org>; Mon, 18 Jan 2010 09:42:00 GMT
In-Reply-To: <bug-15007-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15007


nick cheng <nick.cheng@areca.com.tw> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |WILL_NOT_FIX
         Regression|No                          |Yes




--- Comment #10 from nick cheng <nick.cheng@areca.com.tw>  2010-01-18 09:41:58 ---
(In reply to comment #9)
> Reply-To: fujita.tomonori@lab.ntt.co.jp
> 
> On Fri, 15 Jan 2010 12:23:16 GMT
> bugzilla-daemon@bugzilla.kernel.org wrote:
> 
> > What does sg_tablesize in scsi_host_template mean?
> > It means the max sg entry number which the HW can handle once?
> 
> Yes. A driver should set it to hardware limit.
> 
> Can you close this bug report on bugzilla.kernel.org? The bug is not
> in mainline. If you have any further questions related with this
> topic, please send to linux-scsi mailing list instead of using the
> kernel bug tracker.
> 
> Thanks,
OK

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
