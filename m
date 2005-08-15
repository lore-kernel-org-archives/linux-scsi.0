From: James Bottomley <jejb@steeleye.com>
Subject: Re: [PATCH] allow a transport to pre-initialize starget_data
Date: Mon, 15 Aug 2005 10:23:51 -0500
Message-ID: <1124119431.5089.9.camel@mulgrave>
References: <20050815134210.GA19426@lst.de>  <4300B232.9000308@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:9420 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964795AbVHOPYA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 11:24:00 -0400
In-Reply-To: <4300B232.9000308@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-08-15 at 11:18 -0400, Luben Tuikov wrote:
> While you're at it, rip out the extremely broken "channel" and "id",
> and leave only the opaque token.

Unfortunately, I just found an actual use for channel (exposing
underlying physical discs of raid devices) and, unfortunately, we're
still not yet at the point where we can use an opaque token for ID, but
if someone wants to look into what it would take to convert the rest of
SCSI ...

James


