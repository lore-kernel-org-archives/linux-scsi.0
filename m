From: Jens Axboe <axboe@suse.de>
Subject: Re: sense visible despite ide-floppy in 2.6 maybe
Date: Thu, 17 Jun 2004 21:12:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040617191203.GJ9446@suse.de>
References: <20040613200048.GB2566@suse.de> <1087499022.3135.31.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:4044 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261987AbUFQTSb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2004 15:18:31 -0400
Content-Disposition: inline
In-Reply-To: <1087499022.3135.31.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

On Thu, Jun 17 2004, Pat LaVarre wrote:
> > ide-scsi is deprecated for any
> > ATAPI type device using SG_IO,
> > other uses may vary.
> 
> I will next try SG_IO with PATAPI in 2.6.7,
> i.e. that's my guess unless corrected of how I can best help next now.

Just hold of until tomorrow, you still need the update ide-floppy SG_IO
patch (which I didn't do yet). Or you can look into completing it
yourself, if you have time to spend on that today.

-- 
Jens Axboe

