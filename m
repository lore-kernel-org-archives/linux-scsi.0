From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13594] SMART responses for SATA disks on SAS get interpreted as
 errors
Date: Wed, 12 May 2010 17:42:18 GMT
Message-ID: <201005121742.o4CHgIO4013031@demeter.kernel.org>
References: <bug-13594-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34186 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911Ab0ELRmU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2010 13:42:20 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4CHgIZr013032
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 12 May 2010 17:42:18 GMT
In-Reply-To: <bug-13594-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=13594





--- Comment #14 from Steinar H. Gunderson <sgunderson@bigfoot.com>  2010-05-12 17:42:13 ---
On Wed, May 12, 2010 at 03:20:14PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> The originally reported problem has been fixed. See:
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=91b25002bd58f55207e4662a611a6cded4ef9834
> 
> I was told that was scheduled to go in lk 2.6.33
> 
> Reading the bugzilla entry some of the latter posts
> could be reporting some other LSI related problems.
> Anyway, the bug report should be closed.

It actually seems like that in 2.6.34-rc6, I can use SMART pretty much with
impunity. Don't know if I'm just luckier now or what happened...

/* Steinar */

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
