From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: suspending I/Os to a device
Date: Mon, 26 Apr 2004 09:40:21 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040426094021.A3442@beaverton.ibm.com>
References: <8D43EFD7CCBDB24980134BE078C227E704E37A82@xcm.emulex.com> <1082762917.1615.17.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:33171 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S263032AbUDZQk5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Apr 2004 12:40:57 -0400
Content-Disposition: inline
In-Reply-To: <1082762917.1615.17.camel@mulgrave>; from James.Bottomley@steeleye.com on Fri, Apr 23, 2004 at 07:28:30PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Infante, Jon" <Jon.Infante@Emulex.Com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>

On Fri, Apr 23, 2004 at 07:28:30PM -0400, James Bottomley wrote:

> Actually, there is no interface because no-one has had any prior
> requirements for this.
> 
> This is effectively a FC specific thing, and I believe you know because
> you get a lip event telling you the target has gone, so it sounds like
> the ideal thing to handle in the FC transport class (since it would
> apply to all FC HBAs) The target reconnect timeout would then be a
> transport class property and we'd start failing I/Os when it expired.  I
> would guess there needs to be an additional state in the device state
> model like SUSPEND (QUIESCE doesn't quite fit because it allows the
> pending queue to drain and the error handler to operate), but we can
> accomodate that.

Attaching your USB or firewire device to another port is not much
different.

We should someday allow removal and re-attachment of any disk, or the
replacement of the transport (like hotplug pci card, or the cables),
without having to close or unmount the disk.

-- Patrick Mansfield
