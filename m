From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] add sysfs attributes to scan and delete scsi_devices
Date: Tue, 8 Jul 2003 22:13:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030708221350.A19804@infradead.org>
References: <20030708134016.A32161@beaverton.ibm.com> <1057697416.1825.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([195.224.96.167]:48906 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267647AbTGHU7Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jul 2003 16:59:16 -0400
Content-Disposition: inline
In-Reply-To: <1057697416.1825.10.camel@mulgrave>; from James.Bottomley@steeleye.com on Tue, Jul 08, 2003 at 03:50:15PM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Jul 08, 2003 at 03:50:15PM -0500, James Bottomley wrote:
> I'm not convinced we need a bus file for this.  What's the reason we
> can't have a per host file instead?
> 
> I'm thinking of the hotplug case where you know the sysfs path to the
> card just inserted.  Translating that to a hostid will be rather hard.

After thinking about this again I tend to agree with you that a per-host
file sounds like the better idea.

