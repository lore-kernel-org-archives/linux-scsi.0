From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15950] Hang in dc395x driver
Date: Mon, 10 May 2010 20:28:52 GMT
Message-ID: <201005102028.o4AKSq4A025712@demeter.kernel.org>
References: <bug-15950-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34515 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594Ab0EJU3A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2010 16:29:00 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4AKSvtK026207
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 10 May 2010 20:28:57 GMT
In-Reply-To: <bug-15950-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15950





--- Comment #4 from Guennadi Liakhovetski <g.liakhovetski@gmx.de>  2010-05-10 19:59:25 ---
On Mon, 10 May 2010, bugzilla-daemon@bugzilla.kernel.org wrote:

> I downloaded the .1 versions of kernel's 2.6.22 through 2.6.26, and
> found that 2.6.25 and above had no changes in the dc395x.c file, but
> that a variety of changes were introduced in 2.6.24 and below.  Since
> the older dc395x.c doesn't drop into my current 2.6.31 kernel, I tried
> recompiling and running 2.6.24 without success.  On Gentoo, the
> current udev doesn't work with that older kernel, so things like
> networking and X fail to run properly and I was unable to test the
> scanner.  Suggestions?

You can use the command-line sane interface scanimage (from the sane-utils 
package).

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
