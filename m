From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: scsi_device::single_lun name change
Date: Tue, 15 Feb 2005 19:53:59 -0600
Message-ID: <1108518839.5539.93.camel@mulgrave>
References: <42129A83.7010207@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:56807 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261967AbVBPByF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Feb 2005 20:54:05 -0500
In-Reply-To: <42129A83.7010207@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-02-16 at 10:57 +1000, Douglas Gilbert wrote:
> "scsi_target: representation of a scsi target, for now,
>   this is only used for single_lun devices." This is just above
> the definition of the scsi_target structure in scsi_device.h

Yes, I suppose that's historical junk now.

> Elsewhere in that file scsi_device::single_lun is defined
> with this comment:
> "Indicates we should only allow I/O to one of the luns for
>   the device at a time."
> That implies that the target must have multiple lus when
> single_lun is set :-)
> 
> Is it too late to rename that field to something like:
>     serialize_lu_io  or single_lu_io ?

Well, it corresponds to BLIST_SINGLELUN flag, so the naming scheme is
currently internally consistent.

James


