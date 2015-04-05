From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 15/21] lpfc: Implement support for wire-only DIF devices
Date: Sun, 5 Apr 2015 09:06:13 -0700
Message-ID: <20150405160613.GA8622@infradead.org>
References: <1428095580.6933.44.camel@myfc17>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45523 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbbDEQGN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Apr 2015 12:06:13 -0400
Content-Disposition: inline
In-Reply-To: <1428095580.6933.44.camel@myfc17>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

On Fri, Apr 03, 2015 at 05:13:00PM -0400, James Smart wrote:
> Implement support for wire-only DIF devices
> 
> This patch adds the ability to support auto-enablement of wire-only DIF
> (DIF is generated on TX to target, stripped on RX; OS unaware DIF in use)
> for a select set of devices. Currently, there is only 1 device vendor
> supported: 3PARdata. When the feature is enabled, Inquiry commands are
> trapped, the vendor matched, and DIF enablement checked. In 3Par's case,
> there's a vendor specific check to see if the LUN supports DIF.
> If supported, DIF will be enabled on a per-lun basis.  The driver will
> trap READS/WRITEs from the OS, check for LUN DIF enablement, and if set,
> turns on write-only DIF.

NAK. We do support proper DIF, and anyone who wants it should enable
the real thing.

And even if we would want to support a hack like this we'd do it
genericly an not in a driver.
