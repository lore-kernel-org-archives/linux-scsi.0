From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Sysfs attribute file for max_sectors
Date: Tue, 6 Jan 2004 13:11:05 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040106131105.A12358@beaverton.ibm.com>
References: <1073413440.2221.47.camel@mulgrave> <Pine.LNX.4.44L0.0401061427230.6168-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:39832 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S265283AbUAFVLz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jan 2004 16:11:55 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0401061427230.6168-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Tue, Jan 06, 2004 at 02:31:10PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

Alan -

Given that we currently don't have any user level intitiated scanning, how
can you modify max_sectors in user space prior to the scsi_alloc_queue()
call done during scan?

Is there a block interface to modify max_sectors?

-- Patrick Mansfield
