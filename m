From: James Bottomley <jejb@steeleye.com>
Subject: Re: [PATCH] aic7xxx: user scsi_device host private data
Date: Mon, 23 May 2005 10:34:41 -0500
Message-ID: <1116862481.5021.6.camel@mulgrave>
References: <20050523151422.GA3668@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:5569 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261884AbVEWPev (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2005 11:34:51 -0400
In-Reply-To: <20050523151422.GA3668@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-05-23 at 17:14 +0200, Christoph Hellwig wrote:
> -	BUG_ON(dev == NULL);

Leave that one, just in case ... I think it's completely impossible now,
but I'm still suspicious of the aic untagged queues and whether they can
spit back a command.

> -	BUG_ON(dev->active);

Ditto this one .. although I'm less sanguine that this won't be tripped.
 
James


