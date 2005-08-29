From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Mon, 29 Aug 2005 13:09:14 -0500
Message-ID: <1125338955.5089.78.camel@mulgrave>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A4B@xbl3.ma.emulex.com>
	 <430B5CDB.9070204@s5r6.in-berlin.de> <430BB91F.7000406@vger.kernel.org>
	 <20050824091230.GB26447@infradead.org> <430F398A.30200@adaptec.com>
	 <20050829171629.GB7875@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:44694 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751270AbVH2SJd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 14:09:33 -0400
In-Reply-To: <20050829171629.GB7875@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>

On Mon, 2005-08-29 at 18:16 +0100, Christoph Hellwig wrote:
> No need to do silly renaming, but yes, moving creating of scsi_target
> structures to the transport does make sense.  It's kinda implicit
> in the todo list I posted.  I also don't really see the point of
> the embedded kobject.

You might want to dust off the Mike Christie patch that did this.  The
one that eventually went in the tree was James Smarts to stop FC drivers
oopsing on remove/add lun.

There already is an embedded kobject in the scsi_target structure (it's
in struct device) and that's what we use to make it visible in the sysfs
tree.

James


