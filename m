From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] QStor SATA/RAID driver for 2.6.9-rc3
Date: Thu, 7 Oct 2004 15:07:09 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041007150709.B12688@infradead.org>
References: <4161A06D.8010601@rtr.ca> <416547B6.5080505@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baythorne.infradead.org ([81.187.226.107]:30473 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266175AbUJGOHK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Oct 2004 10:07:10 -0400
Content-Disposition: inline
In-Reply-To: <416547B6.5080505@rtr.ca>; from lsml@rtr.ca on Thu, Oct 07, 2004 at 09:42:14AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lsml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Thu, Oct 07, 2004 at 09:42:14AM -0400, Mark Lord wrote:
> Okay, last call for comment on this driver.
> 
> Any other issues before initial kernel inclusion?

Yes, there's lots of issues, but I need some time to write them all up.
You could start by removing all the silly typedefs and the EXPORT_SYMBOLs
that have been vetoed.

