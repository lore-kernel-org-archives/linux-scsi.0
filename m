From: Willem Riede <osst@riede.org>
Subject: Re: [PATCH] osst: don't use obsolete SCSI APIs
Date: Sun, 23 Jan 2005 22:44:47 +0000
Message-ID: <1106520287l.5898l.2l@serve.riede.org>
References: <20050103155305.GA24521@lst.de>
	<20050120114950.GA619@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc12.comcast.net ([204.127.202.56]:34279 "EHLO
	sccrmhc12.comcast.net") by vger.kernel.org with ESMTP
	id S261368AbVAWWmQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jan 2005 17:42:16 -0500
In-Reply-To: <20050120114950.GA619@infradead.org> (from hch@infradead.org on
	Thu Jan 20 06:49:50 2005)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On 01/20/2005 06:49:50 AM, Christoph Hellwig wrote:
> On Mon, Jan 03, 2005 at 04:53:05PM +0100, Christoph Hellwig wrote:
> > this patch gets rid of the need for scsi.h, similar to the recent patch
> > to the st driver.  (applies ontop of Willem's patches)
> 
> ping?

If I appeared slow in responding, I'm sorry. I wanted to compile osst with  
these changes and do a quick regression test. I'm happy to report that is 
now completed successfully. I agree with these changes, and as far as I'm  
concerned, they can be applied.

Signed-off-by: Willem Riede <osst@riede.org>
 
> > 
> > 
> > 
> > ===== drivers/scsi/osst.c 1.65 vs edited =====
> > --- 1.65/drivers/scsi/osst.c	2005-01-02 04:04:08 +01:00
> > +++ edited/drivers/scsi/osst.c	2005-01-02 21:49:05 +01:00



