From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15278] lockdep warning for iscsi in 2.6.33-rc6
Date: Fri, 12 Feb 2010 03:29:11 GMT
Message-ID: <201002120329.o1C3TBBR012752@demeter.kernel.org>
References: <bug-15278-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53588 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab0BLD3M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2010 22:29:12 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1C3TB6L012753
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 12 Feb 2010 03:29:11 GMT
In-Reply-To: <bug-15278-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15278





--- Comment #1 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2010-02-12 03:29:10 ---
Reply-To: michaelc@cs.wisc.edu

On 02/11/2010 02:05 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
> This entry is being used for tracking a regression from 2.6.32.  Please don't
> close it until the problem is fixed in the mainline.
>

Hey Tao,

So did you narrow this down to being a regression starting in 2.6.32?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
