From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] kill of ->command
Date: Mon, 9 Jun 2003 09:41:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030609094130.A14870@beaverton.ibm.com>
References: <20030609162056.GA1857@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:38345 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264279AbTFIQcA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2003 12:32:00 -0400
Content-Disposition: inline
In-Reply-To: <20030609162056.GA1857@lst.de>; from hch@lst.de on Mon, Jun 09, 2003 at 06:20:56PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Mon, Jun 09, 2003 at 06:20:56PM +0200, Christoph Hellwig wrote:
> It's unused now.  Also kill off the stupid = NULL initializations
> in usb-storage that made this not compile the first time..

It looks like drivers/scsi/NCR53c406a.c and drivers/scsi/arm/arxescsi.c
can still set can_queue = 0. Correct?

Those two ought to be modified, and anyone setting can_queue = 0 disabled
in hosts.c (scsi_add_host?).

-- Patrick Mansfield
