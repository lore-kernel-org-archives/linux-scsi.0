From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] scsi_device refcounting and list lockdown
Date: 28 Oct 2003 09:52:42 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067356364.1862.5.camel@mulgrave>
References: <20031027155713.GA28140@lst.de>
	<20031028023235.GE1151@beaverton.ibm.com>  <20031028090755.GB7370@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:12806 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264015AbTJ1Pw4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 10:52:56 -0500
In-Reply-To: <20031028090755.GB7370@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-10-28 at 03:07, Christoph Hellwig wrote:
> > Don't we still want to set SDEV_DEL to keep callers to scsi_device_get
> > from do more gets.
> 
> Indeed!  James, can you add this back when applying?

OK, this should be in place on the scsi-bugfixes-2.6 tree if you could
check it out.

James


