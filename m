From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/3] SCSI: rearrange code in scsi_io_completion
Date: Wed, 1 Oct 2008 09:50:16 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0810010948580.2421-100000@iolanthe.rowland.org>
References: <yq1od25jjyj.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60513 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751516AbYJANuT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2008 09:50:19 -0400
In-Reply-To: <yq1od25jjyj.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 30 Sep 2008, Martin K. Petersen wrote:

> >>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:
> 
> Alan> Are there types of failure for which we really don't want to
> Alan> print anything?  For example, what about UNIT ATTENTION for
> Alan> media changes or the DIX/DIF failures (should those both be
> Alan> DIF?)?
> 
> ILLEGAL REQUEST + 10/[123] indicates that the HBA rejected the request
> (DIX).
> 
> ABORTED COMMAND + 10/[123] indicates that the device found a
> corruption error (DIF).

That answer the parenthetical question.  Do you know the answer to the 
main question?  That is, when either of these events occurs do we want 
to skip adding an error message to the system log?

Alan Stern

