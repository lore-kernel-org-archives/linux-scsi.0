From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: IO buffer alignment for block devices
Date: 13 Sep 2004 11:28:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095089305.1762.73.camel@mulgrave>
References: <41459729.5060106@il.marvell.com>
	<1095084876.1762.8.camel@mulgrave>  <4145B9DF.7020408@il.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:44765 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267841AbUIMP23 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2004 11:28:29 -0400
In-Reply-To: <4145B9DF.7020408@il.marvell.com>
List-Id: linux-scsi@vger.kernel.org
To: Saeed Bishara <Saeed.Bishara@il.marvell.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-09-13 at 11:16, Saeed Bishara wrote:
>     isn't the default 512, this is what I see in blk_queue_make_request.
> 
> <http://lxr.linux.no/ident?v=2.6.8.1;i=blk_queue_make_request>

In the block layer, yes.  In SCSI we tune that down to be 8 for backward
compatibility with 2.4, I think, but LLDs can tune it up again.

> any Ideas about lk 2.4?

Not really; since it's end of life, you could probably get away with not
back porting to 2.4

James


