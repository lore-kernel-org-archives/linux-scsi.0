From: hch@infradead.org
Subject: Re: 2.6.6-mm5
Date: Sat, 22 May 2004 05:22:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040522092237.GA3417@infradead.org>
References: <20040522013636.61efef73.akpm@osdl.org> <40AF18E7.4040509@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.217.7]:30214 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S264936AbUEVJWt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 May 2004 05:22:49 -0400
Content-Disposition: inline
In-Reply-To: <40AF18E7.4040509@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, May 22, 2004 at 05:09:59AM -0400, Jeff Garzik wrote:
> Andrew Morton wrote:
> >- Added a new SATA RAID driver from 3ware.  From a quick peek it seem to
> >  need a little work yet.
> 
> 
> It's not too bad... but it looks more like a 2.2 driver forward ported 
> to 2.4, than a 2.6.x driver.  Needs some luvin' from the 2.6 scsi api crew.
> 
> Overall, it appears to be a message-based firmware engine like 
> drivers/block/carmel.c, that hides the SATA details in the firmware.

In addition driver submission should always go through linux-scsi.  Please
tell them to submit it to linux-scsi so we can have a public review process
there.
