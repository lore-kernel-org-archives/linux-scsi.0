From: James Bottomley <jejb@steeleye.com>
Subject: Re: [PATCH] aic7xxx: user scsi_device host private data
Date: Mon, 23 May 2005 15:04:13 -0500
Message-ID: <1116878653.5021.27.camel@mulgrave>
References: <20050523151422.GA3668@lst.de>
	 <1116862481.5021.6.camel@mulgrave>  <20050523191629.GA8365@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:41413 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261937AbVEWUEY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2005 16:04:24 -0400
In-Reply-To: <20050523191629.GA8365@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-05-23 at 21:16 +0200, Christoph Hellwig wrote:
> This doesn't make sense as we never reset the hostdata, so this is a
> real can't happen.

Then you should ... at the place where the old code released the device
in slave_destroy.

James


