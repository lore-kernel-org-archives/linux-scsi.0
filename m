From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11302] I get a kernel OOPS! If I try to attach an usb card reader, SD, MMC, ecc.. to my Slamd64
Date: Wed,  3 Sep 2008 06:13:03 -0700 (PDT)
Message-ID: <20080903131303.1B86B108057@picon.linux-foundation.org>
References: <bug-11302-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751640AbYICNNe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2008 09:13:34 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m83DD3Jf003161
	for <linux-scsi@vger.kernel.org>; Wed, 3 Sep 2008 06:13:04 -0700
In-Reply-To: <bug-11302-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11302


pinc_o@yahoo.it changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |pinc_o@yahoo.it




------- Comment #10 from pinc_o@yahoo.it  2008-09-03 06:13 -------
Yes,

excuse me. I probably have confused my card reader with my notebook built-in
card reader ... In fact, my Trust card reader doesn't read SDHC, it read only
SD.

For your information:

However, I have tryed on my notebook. On my notebook I have kernels 2.6.25.9
and 2.6.23.17. With kernel 2.6.25.9, using the builtin card reader, get the
same error as the kernel above. Instead, if I start the system with old kernel
2.6.23.17, my SDHC in the built-in card reader is read and wrote correctly,
instantaneous. 
Unfortunately, now I not have more time, but soon I compile the new kernel
2.6.26.3 or better, in my notebook too and try ...

Please,excuse me for the inconvenience and for my bad English.

Best Regards


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
