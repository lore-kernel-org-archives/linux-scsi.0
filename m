From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: SCSI API generics (was Re: [PATCH] add block/unblock to iscsi class)
Date: Wed, 23 Feb 2005 10:17:05 -0800
Message-ID: <20050223181705.GA8694@plap.qlogic.org>
References: <421C3CA4.8070009@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from avexch01.qlogic.com ([198.70.193.200]:44502 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261521AbVBWSQk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2005 13:16:40 -0500
Content-Disposition: inline
In-Reply-To: <421C3CA4.8070009@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 23 Feb 2005, Mike Christie wrote:

> The attached patch copies the code from the fc transport
> class which allows a LLD to block and unblock a device.
> The block/unblock code is used by the iscsi-sfnet
> driver in replacement of a internal timer doing the
> same thing.
> 
> I understand that the target code is under construction
> and our group as well as the HW iSCSI guys are trying to move
> to something closer to the fc's rport model, so I was not
> sure if it is better to wait or get this basic functionality in
> first so we (and other SW and HW iSCSI drivers) can kill some
> of our duplicated code sooner and then incrementally update
> the class.
> 

Speaking of which, are there any major objections to the patches
proposed here:

Add scsi_target_[un]block() and scsi_target_remove() generics
http://marc.theaimsgroup.com/?l=linux-scsi&m=110867050306738&w=2

[RFC] adding per scsi-host workqueues for defered processing
http://marc.theaimsgroup.com/?l=linux-scsi&m=110903148407438&w=2

which add some infrastructure changes for the transport classes.

--
AV
