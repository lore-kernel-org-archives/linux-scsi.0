From: worley@alum.mit.edu (Dale R. Worley)
Subject: Re: Large disk drives
Date: Wed, 5 Nov 2014 18:30:28 -0500
Message-ID: <201411052330.sA5NUSCG019414@hobgoblin.ariadne.com>
References: <Pine.LNX.4.44L0.1411041112010.966-100000@iolanthe.rowland.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from resqmta-ch2-11v.sys.comcast.net ([69.252.207.43]:53848 "EHLO
	resqmta-ch2-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261AbaKEXcb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Nov 2014 18:32:31 -0500
In-reply-to: <Pine.LNX.4.44L0.1411041112010.966-100000@iolanthe.rowland.org>
	(stern@rowland.harvard.edu)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

> From: Alan Stern <stern@rowland.harvard.edu>

> I posted a patch to allow the user to override the reported capacity:
> 
> 	http://marc.info/?l=linux-scsi&m=140993840113445&w=2

I see the patch, and I feel confident I could install it if I needed
to.  What command do I execute to "write to the capacity_override
attribute", before I do "blockdev --rereadpt /dev/sdX"?

Dale
