From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13452] When log in a iscsi target it's fail and there is a bug
 scsi related
Date: Thu, 4 Jun 2009 17:09:40 GMT
Message-ID: <200906041709.n54H9e7O029341@demeter.kernel.org>
References: <bug-13452-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53425 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbZFDRJk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jun 2009 13:09:40 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n54H9ejt029342
	for <linux-scsi@vger.kernel.org>; Thu, 4 Jun 2009 17:09:40 GMT
In-Reply-To: <bug-13452-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13452





--- Comment #1 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2009-06-04 17:09:38 ---
Reply-To: michaelc@cs.wisc.edu

> I'm using a 2.6.27.5-hg Xen kernel. Modules iscsi_tcp and libiscsi are loaded
> but when I log in a target iscsi syslog says that there is a kernel bug in
> /var/xen/linux-2.6.27-xen.hg/drivers/scsi/scsi_lib.c:1759. I have download a
> mainline kernel 2.6.27.5 and the source code differs.
> 

What is hg xen?

This is close to
http://groups.google.com/group/open-iscsi/browse_thread/thread/c4ddd07c06546864/791c69f2e2a0d46d?lnk=gst&q=oops+xen#791c69f2e2a0d46d

scsi_alloc_queue calls blk_queue_bounce_limit so it could be the same 
bug but moved around due to differences on those kernels.

Is there a newer kernel? I do not remember the problem or solution. It 
was in the xen code. I will do some more searching, but if there is a 
newer kernel could you give it a try?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
