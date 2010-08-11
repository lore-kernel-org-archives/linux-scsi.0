From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16558] iSCSI Connection / Stability Problems
Date: Wed, 11 Aug 2010 03:35:42 GMT
Message-ID: <201008110335.o7B3ZgGa002835@demeter.kernel.org>
References: <bug-16558-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44469 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427Ab0HKDfn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2010 23:35:43 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o7B3ZgCZ002836
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Aug 2010 03:35:42 GMT
In-Reply-To: <bug-16558-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16558





--- Comment #3 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2010-08-11 03:35:40 ---
Reply-To: fujita.tomonori@lab.ntt.co.jp

On Wed, 11 Aug 2010 03:22:36 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> I have the same problem with the latter as the former, it makes no difference. 

Ok, please report it to both mailing lists respectively. But the log
that you sent is not about the latter. So please reports it with the
proper long to the latter.


> I should also mention that one particular symptom is that if I have an ssh
> connection open to the server,  it will stall. Keypresses aren't registered in
> the ssh session--- however,  if I bang on the console keyboard which is
> connected directly to the server via USB,  the ssh session comes back to life,
> spewing my keypresses back to me.

Hmm, sounds like a different problem. Needs to find what is the root
problem.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
