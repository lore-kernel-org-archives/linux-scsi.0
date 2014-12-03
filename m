From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/12] nobody loves the advansys driver
Date: Wed, 3 Dec 2014 16:21:41 +0100
Message-ID: <20141203152141.GA6175@lst.de>
References: <1417607105-85455-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55838 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbaLCPVp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2014 10:21:45 -0500
Content-Disposition: inline
In-Reply-To: <1417607105-85455-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

Thanks for looking into this old driver.

If you've got a few spare cycles it might make sense to simply split
the "wide board" support out - the driver literally is two different
drivers with an if/else section in every method for the totally
different narrow vs wide boards.  Having at least a clean and simple
driver for the newer wide boards would be good, and narrow ones are
probably old enough that we can let the driver for those fade away..

