From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] Use sdev_scsi2lun for SCSI parallel drivers
Date: Fri, 4 Jul 2014 06:44:37 -0700
Message-ID: <20140704134437.GA12345@infradead.org>
References: <1404474875-109997-1-git-send-email-hare@suse.de>
 <1404474875-109997-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41872 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758596AbaGDNoj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2014 09:44:39 -0400
Content-Disposition: inline
In-Reply-To: <1404474875-109997-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Fri, Jul 04, 2014 at 01:54:34PM +0200, Hannes Reinecke wrote:
> SCSI-2 defines only up to 256 LUNs with a flat namespace.
> This patch introduces an accessor 'sdev_scsi2lun' which should be
> used for these drivers to avoid problems when using 64-bit LUNs
> internally.

So what would be set in the upper 48 bits for those drivers?  We receive
the LUN over the wire to start with.

