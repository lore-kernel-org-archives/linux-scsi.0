From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: PATCH: (as284) Add BLIST_INQUIRY_36 to existing blacklist USB entries
Date: Wed, 19 May 2004 15:36:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040519153642.A23286@beaverton.ibm.com>
References: <20040518123306.A12344@beaverton.ibm.com> <Pine.LNX.4.44L0.0405181709180.933-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:60146 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S264670AbUESWgw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 May 2004 18:36:52 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0405181709180.933-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Tue, May 18, 2004 at 05:12:07PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, May 18, 2004 at 05:12:07PM -0400, Alan Stern wrote:
> This is a report of an earlier message that may not have gotten through...
> 
> > While I'm at it, this patch is needed to prevent existing blacklist 
> > entries from overriding the BLIST_INQUIRY_36 flag for various USB devices.
> > 
> > Alan Stern

Alan -

How is it being overridden? I don't see usb storage setting
BLIST_INQUIRY_36.

-- Patrick Mansfield
