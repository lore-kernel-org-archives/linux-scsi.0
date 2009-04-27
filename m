From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] qla4xxx: Driver Fault Recovery
Date: Mon, 27 Apr 2009 11:15:18 -0400
Message-ID: <20090427151518.GA9033@infradead.org>
References: <DBF768B1A111084580554DADE800BF9D72EA041EFD@AVEXMB2.qlogic.org> <49F5CA98.8060708@cs.wisc.edu> <20090427151349.GG1926@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45381 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227AbZD0PPW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2009 11:15:22 -0400
Content-Disposition: inline
In-Reply-To: <20090427151349.GG1926@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Karen Higgins <karen.higgins@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Apr 27, 2009 at 09:13:49AM -0600, Matthew Wilcox wrote:
> On Mon, Apr 27, 2009 at 10:09:12AM -0500, Mike Christie wrote:
> > My mailer is messing up the formatting so it looks like spaces instead 
> > of tabs are getting adedd. If that is my mailers fault then patch looks ok:
> 
> My mailer's rendering it as:
> 
> - ???????????status = QLA_ERROR;
> - ???}
> + ???DEBUG2(printk("scsi%ld: %s - Performing soft reset..\n",
> + ?????????????ha->host_no, __func__));
> 
> so there's definitely something weird going on with these patches.

As does my mailer.  I've seen the same mangling for lots of patches on
the X.org list so it must be something fashionable for graphical mailers
or similar :)

