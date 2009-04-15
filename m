From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive
 gives EBUSY
Date: Wed, 15 Apr 2009 15:42:09 GMT
Message-ID: <200904151542.n3FFg9md031066@demeter.kernel.org>
References: <bug-12207-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38075 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZDOPmL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Apr 2009 11:42:11 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n3FFg907031067
	for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2009 15:42:09 GMT
In-Reply-To: <bug-12207-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12207





--- Comment #34 from Alan Stern <stern@rowland.harvard.edu>  2009-04-15 15:42:08 ---
On Wed, 15 Apr 2009 bugzilla-daemon@bugzilla.kernel.org wrote:

> Dear all,
> 
> Thanks for discussing.
> Against my expectations the story was aimed more generic goal. It is fine.
> 
> 
> > Your patch affects the max_sectors attribute file for all devices, not just for tape devices.
> 
> Yes, I know my code is experimental.
> It should check the type of a target device to affect only for tape devices.
> 
> 
> > So there is no _tape_ device which can operate with larger block size.  
> > But maybe a non-tape device can.
> 
> But, usually, accepting very large block size is used to improve the
> performance with a tape device.
> 
> So,,, at least about my circumstance, changing only scsiglue.c is a nice
> solution.

This sort of issue should be discussed by email, not on Bugzilla.  If 
you want to continue talking about it, post your messages to 
<usb-storage@lists.one-eyed-alien.net> and CC: anyone who might be 
particularly interested.

Alan Stern

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
