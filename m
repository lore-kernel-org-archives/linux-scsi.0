From: Christoph Hellwig <hch@infradead.org>
Subject: Re: map gendisk (or blockdev) -> scsi_device
Date: Wed, 13 Jul 2005 15:38:43 +0100
Message-ID: <20050713143843.GC26025@infradead.org>
References: <db1npr$c1d$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:29836 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262652AbVGMOio (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jul 2005 10:38:44 -0400
Content-Disposition: inline
In-Reply-To: <db1npr$c1d$1@sea.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Edward Falk <efalk@google.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Jul 12, 2005 at 05:38:19PM -0700, Edward Falk wrote:
> Hi all; what's the proper way to get the scsi_device structure from a 
> gendisk structure?

No.

> sd.c uses pointers through scsi_disk, but that 
> structure is private to sd.c.  Will I need to add an access function in 
> sd.c or something?

You should revisit your code to not need access to the scsi_device
structure, and follow the layering of the block and scsi subsystems.

