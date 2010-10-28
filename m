From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13602] some HFS CD-ROM's can't be read
Date: Thu, 28 Oct 2010 16:06:50 GMT
Message-ID: <201010281606.o9SG6oYl014817@demeter1.kernel.org>
References: <bug-13602-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37559 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152Ab0J1QGv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2010 12:06:51 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o9SG6oNr014818
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2010 16:06:50 GMT
In-Reply-To: <bug-13602-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=13602





--- Comment #4 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2010-10-28 16:06:44 ---
Reply-To: James.Bottomley@suse.de

On Thu, 2010-10-28 at 12:53 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=13602
> 
> 
> Christoph Hellwig <hch@lst.de> changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>           Component|HFS/HFSPLUS                 |SCSI
>          AssignedTo|hch@lst.de                  |linux-scsi@vger.kernel.org
>             Product|File System                 |IO/Storage

Why is this actually a bug?  Linux has never supported filesystem block
sizes smaller than device ones ... we don't have the necessary RMW code
for it.  The sr driver supports 512 byte sectors but *only* if the CD
was burned with them (which isn't always possible depending on CD
burner) and the reader supports them.  I'd need the dmesgs to be sure
but i'd guess READ_CAPACITY on this cd returns 2048 as the block size.

James

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
