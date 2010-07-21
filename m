From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16275] Kernel panic when mounting filesystem
Date: Wed, 21 Jul 2010 20:44:28 GMT
Message-ID: <201007212044.o6LKiSuN007932@demeter.kernel.org>
References: <bug-16275-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46354 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab0GUUo3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2010 16:44:29 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o6LKiST0007933
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 21 Jul 2010 20:44:28 GMT
In-Reply-To: <bug-16275-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16275





--- Comment #13 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2010-07-21 20:44:23 ---
Reply-To: James.Bottomley@suse.de

On Tue, 2010-07-20 at 09:57 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> --- Comment #9 from Pawel Staszewski <pstaszewski@artcom.pl>  2010-07-20 09:57:34 ---
> Created an attachment (id=27167)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=27167)
>  --> (https://bugzilla.kernel.org/attachment.cgi?id=27167)
> Panic first screen

Well, this validates the guess that it's the zero segment check, thanks!
so it's clearly a filesystem bug.

Which filesystem is this?  I tried looking for the 'Checking internal
tree' message, but couldn't find it in the sources.

James

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
