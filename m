From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] mark qlogicisp broken
Date: Thu, 10 Feb 2005 19:35:07 +0100
Message-ID: <20050210183507.GA12186@lst.de>
References: <20050210181851.GC11818@lst.de> <20050210183046.GA16753@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from verein.lst.de ([213.95.11.210]:50397 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261161AbVBJSfO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Feb 2005 13:35:14 -0500
Content-Disposition: inline
In-Reply-To: <20050210183046.GA16753@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Thu, Feb 10, 2005 at 10:30:46AM -0800, Patrick Mansfield wrote:
> On Thu, Feb 10, 2005 at 07:18:51PM +0100, Christoph Hellwig wrote:
> > It's lacking EH support and the hardware is supported by the qla1280
> > driver now.
> 
> Can we instead remove this one and the qlogicfc?

Marking it BROKEN is the first step toward that.  If no one complains
it'll be gone two kernel releases later.

