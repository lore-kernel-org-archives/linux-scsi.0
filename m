From: James Bottomley <jejb@steeleye.com>
Subject: Re: [PATCH] mark qlogicisp broken
Date: Thu, 10 Feb 2005 13:35:00 -0500
Message-ID: <1108060500.7361.24.camel@mulgrave>
References: <20050210181851.GC11818@lst.de>
	 <20050210183046.GA16753@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:9127 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261165AbVBJSfz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Feb 2005 13:35:55 -0500
In-Reply-To: <20050210183046.GA16753@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2005-02-10 at 10:30 -0800, Patrick Mansfield wrote:
> On Thu, Feb 10, 2005 at 07:18:51PM +0100, Christoph Hellwig wrote:
> > It's lacking EH support and the hardware is supported by the qla1280
> > driver now.
> 
> Can we instead remove this one and the qlogicfc?

Dave Miller still has a problem with the devfs interaction issues
between qla2xxx and qlogicfc, but I see no reason we can't get rid of
qlogicisp.

James


