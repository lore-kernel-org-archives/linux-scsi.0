From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14563] SCSI tape driver: Spurious EIO and kernel BUG
Date: Thu, 19 Nov 2009 07:51:08 GMT
Message-ID: <200911190751.nAJ7p8iu004256@demeter.kernel.org>
References: <bug-14563-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43759 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbZKSHvC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2009 02:51:02 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAJ7p8lT004257
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2009 07:51:08 GMT
In-Reply-To: <bug-14563-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14563





--- Comment #17 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2009-11-19 07:51:05 ---
Reply-To: fujita.tomonori@lab.ntt.co.jp

On Wed, 18 Nov 2009 16:53:53 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=14563
> 
> 
> 
> 
> 
> --- Comment #15 from Joachim Breuer <linux-kernel@jmbreuer.net>  2009-11-18 16:53:53 ---
> Allright! You hit something on the head!
> 
> With 'try_rdio=0 try_wdio=0' as parameters to the st module, writing to tape
> from amanda works correctly in 2.6.30.3.

Thanks a lot for the logs. They are very helpful.

I think that I found one bug about dio. There might be other bugs that
cause this issue though.

Can you try the patch that I've just sent.

Thanks,

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
