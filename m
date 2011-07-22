From: Andi Kleen <andi@firstfloor.org>
Subject: Linux 3.0 STILL dies on USB device hotplug - please merge fix ASAP
Date: Fri, 22 Jul 2011 19:02:14 +0200
Message-ID: <20110722170214.GR8006@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:39309 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab1GVRCQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2011 13:02:16 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, stern@rowland.harvard.edu, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, torvalds@linux-foundation.org
Cc: stable@kernel.org, Dan Williams <dan.j.williams@intel.com>


Hi,

3.0 still oopses and dies immediately on USB device hot unplug.
The same problem also triggered with SAS device according to Dan.

There was a lot of debugging on this a few weeks back and Alan Stern
posted a SCSI layer patch that fixed the problem (for both USB
and SAS):

http://68.183.106.108/lists/linux-usb/msg49001.html

But for some reason that patch didn't make it into 3.0 and 3.0 still
happily oopses as the RC*s.

Can you please merge this patch ASAP?  This should also go to stable.

At least for me it makes pure 3.0 very risky to use, because these USB 
hotunplug events are not uncommon and I end up with a dead machine.

Thanks,

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
