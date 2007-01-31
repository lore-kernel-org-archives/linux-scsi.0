From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source device
	driver for new sequence firmware.
Date: Wed, 31 Jan 2007 10:56:04 -0600
Message-ID: <1170262564.3402.42.camel@mulgrave.il.steeleye.com>
References: <89FD792A883D4B47AD469FEA2E5D1F9B0F59B6@aime2k302.adaptec.com>
	 <20070131095603.GB3200@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:47627 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932936AbXAaQ4O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Jan 2007 11:56:14 -0500
In-Reply-To: <20070131095603.GB3200@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Wu, Gilbert" <Gilbert_Wu@adaptec.com>, linux-scsi@vger.kernel.org

On Wed, 2007-01-31 at 09:56 +0000, Christoph Hellwig wrote:
> On Tue, Jan 30, 2007 at 03:31:25PM -0800, Wu, Gilbert wrote:
> > Subject:  [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source device
> > driver for new sequence firmware.
> > 
> >  
> > 
> > Contribution:
> > 
> >    Ed Chim <ed_chim@adaptec.com>
> >    Gilbert Wu <gilbert_wu@adaptec.com>
> > 
> > Change Log:
> >  
> > 1.    Use dword instead of qword to display the value of Connection
> > State register for debug purpose.
> > 
> > 2.    There are some registers location of AIC94xx chip has been changed
> > according to the new V28 firmware. The patch has redefined the register
> > location and provided initialization.
> 
> These look like incompatible changes, so you should make sure the driver
> still works when it detects the old firmware.

Yes, there's going to be a bit of a problem if they are:  I expected the
firmware to be backward compatible, so the current driver only prints
out the firmware version, it won't refuse to use it ... what will happen
if we use the new firmware on an old driver?

James


