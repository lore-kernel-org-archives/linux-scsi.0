From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 4/5] scsi_debug: change SCSI command parser to table
 driven
Date: Tue, 25 Nov 2014 08:27:35 -0800
Message-ID: <20141125162735.GB31478@infradead.org>
References: <5474000A.2030501@interlog.com>
 <1416928359.2194.23.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40408 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaKYQ1h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Nov 2014 11:27:37 -0500
Content-Disposition: inline
In-Reply-To: <1416928359.2194.23.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dgilbert@interlog.com, SCSI development list <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@ORACLE.COM>

On Tue, Nov 25, 2014 at 07:12:39AM -0800, James Bottomley wrote:
> Perhaps, also, it's time to reconsider whether we do actually need a
> core and drivers branch separation.

The current split doesn't work.  Either it needs to be one tree,
or I need to merge the core into the driver tree somewhat frequently,
similar to what Jens does for the block tree.
