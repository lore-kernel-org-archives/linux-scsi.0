From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: PATCH: (as355) Fix test for valid sense data present
Date: 26 Aug 2004 12:09:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093536566.2326.61.camel@mulgrave>
References: <Pine.LNX.4.44L0.0408261154360.1089-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:23730 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269128AbUHZQJe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 12:09:34 -0400
In-Reply-To: <Pine.LNX.4.44L0.0408261154360.1089-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 2004-08-26 at 11:55, Alan Stern wrote:
> It hasn't been applied anywhere that I've looked.  Is there any problem 
> with it?

Well, it doesn't look quite right.

You haven't modified the SCSI_SENSE_VALID() macro, so DRIVER_SENSE
doesn't get set for the extra conditions you're checking for.

Even if you do fix it, You'll cause us to treat deferred sense
conditions as errors, which would be wrong.

What's the actual problem you're trying to fix?

James


