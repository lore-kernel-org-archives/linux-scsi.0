From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [Patch] QLogic qla2x00 driver fixes
Date: Thu, 24 Feb 2005 23:28:39 -0500
Message-ID: <421EA977.5050803@pobox.com>
References: <1109305293.27139.216.camel@compaq-rhel4.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:18565 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262446AbVBYE3B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Feb 2005 23:29:01 -0500
In-Reply-To: <1109305293.27139.216.camel@compaq-rhel4.xsintricity.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-scsi mailing list <linux-scsi@vger.kernel.org>

Doug Ledford wrote:
> Don't use cmd->request->nr_hw_segments as it may not be initialized
> (SG_IO in particular bypasses anything that initializes this and just
> uses scsi_do_req to insert a scsi_request directly on the head of the
> queue) and a bogus value here can trip up the checks to make sure that
> the number of segments will fit in the queue ring buffer, resulting in
> commands that are never completed.
> 
> Fix up several issues with PCI DMA mapping and failure to check return
> values on the mappings.
> 
> Make the check for space in the ring buffer happen after the DMA mapping
> is done since any checks done before the mapping has taken place are
> bogus.

For future patches please include a signed-off-by line, per
http://linux.yyz.us/patch-format.html

Darned lawyers...

The patch itself looks OK to me.

	Jeff


