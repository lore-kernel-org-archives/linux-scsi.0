From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after
 2.6.20
Date: Thu, 28 Jan 2010 23:35:59 GMT
Message-ID: <201001282335.o0SNZxKL009122@demeter.kernel.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48436 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab0A1Xf7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2010 18:35:59 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o0SNZxJ4009123
	for <linux-scsi@vger.kernel.org>; Thu, 28 Jan 2010 23:35:59 GMT
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646





--- Comment #29 from Csillag Tamas <cstamas@digitus.itk.ppke.hu>  2010-01-28 23:35:43 ---
I upgraded to this kernel @ 2010-01-18:
Linux somehost 2.6.24-9-pve #1 SMP PREEMPT Tue Nov 17 09:34:41 CET 2009 x86_64 
GNU/Linux

and I experienced this issue again.

In some forum I get the idea to upgrade the cards firmware (ISP2422):

$ md5sum qlgc_flash_image_multiboot143.img
1f43310c7bb24db53d561b60080b5211  qlgc_flash_image_multiboot143.img

I do not have a problem since I did the upgrade (2010-01-20).

YMMV

--
Regards, 
  cstamas

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
