From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: PATCH: (as283) Use 192-byte ms flag for page 08
Date: Tue, 18 May 2004 12:33:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040518123306.A12344@beaverton.ibm.com>
References: <Pine.LNX.4.44L0.0405181112070.1407-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:11393 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S261711AbUERTdW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 May 2004 15:33:22 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0405181112070.1407-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Tue, May 18, 2004 at 11:30:44AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, James Bottomley <James.Bottomley@steeleye.com>

On Tue, May 18, 2004 at 11:30:44AM -0400, Alan Stern wrote:
> Patrick:
> 
> Is there any objection to applying the patch below?  It changes the name 
> of the BLIST_MS_192_BYTES_FOR_3F and use_192_bytes_for_3f flags, and uses 
> them to select the transfer length for MODE SENSE queries of page 0x08 in 
> sd.c as well as page 0x3f.
> 
> If you do accept the patch let me know, because a corresponding name 
> change will be needed in the usb-storage driver at the same time.

Looks good to me, but James has to accept it.

PS: linux-scsi is apparently not sending anything out today.

-- Patrick Mansfield
