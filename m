From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V7 1/9] [SCSI] aacraid: Fix for logical device name and
 UID not exposed to the OS
Date: Thu, 27 Aug 2015 08:08:26 -0700
Message-ID: <1440688106.2196.114.camel@HansenPartnership.com>
References: <1440672667-8203-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
	 <1440672667-8203-2-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52515 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753733AbbH0PI1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2015 11:08:27 -0400
In-Reply-To: <1440672667-8203-2-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Cc: JBottomley@Parallels.com, linux-scsi@vger.kernel.org, thenzl@redhat.com, Murthy.Bhat@pmcs.com, Karthikeya.Sunkesula@pmcs.com, aacraid@pmc-sierra.com, Harry.Yang@pmcs.com, Rich.Bono@pmcs.com

On Thu, 2015-08-27 at 06:50 -0400, Mahesh Rajashekhara wrote:
> Description:
> 	Driver sends the right size of the response buffer.
> 
> Changes from V2:
> None
> 
> Reviewed By: Tomas Henzl <thenzl@redhat.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Karthikeya Sunkesula <Karthikeya.Sunkesula@pmcs.com>
> 
> Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

You've had hundreds of upstream confirmation emails over the years.
They've all had one line per tag with no spaces.  Next time can we
please use the right format so I don't have to keep editing your commit
messages.  That is:

Subject: One line summary

Detailed Description of the change (without a Description: prefix)

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Murthy Bhat <Murthy.Bhat@pmcs.com>
Reviewed-by: Karthikeya Sunkesula <Karthikeya.Sunkesula@pmcs.com>
Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

---

Version notices and other context relevant only to the upstream process
come here after the three dashes so it doesn't appear in the patch
detailed description

James
 

