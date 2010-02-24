From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15378] If packet writing is enabled it causes I/O errors.
Date: Wed, 24 Feb 2010 22:47:48 GMT
Message-ID: <201002242247.o1OMlm95002739@demeter.kernel.org>
References: <bug-15378-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42534 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758533Ab0BXWrt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2010 17:47:49 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1OMlm6C002740
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 24 Feb 2010 22:47:48 GMT
In-Reply-To: <bug-15378-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15378


Andrew Morton <akpm@linux-foundation.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |akpm@linux-foundation.org,
                   |                            |axboe@kernel.dk
          Component|SCSI                        |Other
         AssignedTo|linux-scsi@vger.kernel.org  |io_other@kernel-bugs.osdl.o
                   |                            |rg




--- Comment #1 from Andrew Morton <akpm@linux-foundation.org>  2010-02-24 22:47:41 ---
I'll reassign it to io-storage/other.

Nobody really maintains the packet-writing code any more ;(

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
