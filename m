From: Andrew Morton <akpm@osdl.org>
Subject: Re: 2.6.6-mm5
Date: Sat, 22 May 2004 02:26:39 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040522022639.4a8e1f0e.akpm@osdl.org>
References: <20040522013636.61efef73.akpm@osdl.org>
	<40AF18E7.4040509@pobox.com>
	<20040522092237.GA3417@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:44193 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S265152AbUEVJ3s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 May 2004 05:29:48 -0400
In-Reply-To: <20040522092237.GA3417@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

hch@infradead.org wrote:
>
> On Sat, May 22, 2004 at 05:09:59AM -0400, Jeff Garzik wrote:
> > Andrew Morton wrote:
> > >- Added a new SATA RAID driver from 3ware.  From a quick peek it seem to
> > >  need a little work yet.
> > 
> > 
> > It's not too bad... but it looks more like a 2.2 driver forward ported 
> > to 2.4, than a 2.6.x driver.  Needs some luvin' from the 2.6 scsi api crew.
> > 
> > Overall, it appears to be a message-based firmware engine like 
> > drivers/block/carmel.c, that hides the SATA details in the firmware.
> 
> In addition driver submission should always go through linux-scsi.  Please
> tell them to submit it to linux-scsi so we can have a public review process
> there.

Adam did attempt to cc linux-scsi but at 140kbytes the email probably got
spat out.
