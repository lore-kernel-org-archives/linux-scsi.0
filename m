From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH/RFC 1/2] 3ware 9000 SATA-RAID driver
Date: Tue, 25 May 2004 21:19:43 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040525191943.GA25994@lst.de>
References: <HYA6QB01.INU@hadar.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:31201 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265049AbUEYTTs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 May 2004 15:19:48 -0400
Content-Disposition: inline
In-Reply-To: <HYA6QB01.INU@hadar.amcc.com>
List-Id: linux-scsi@vger.kernel.org
To: Adam Radford <aradford@amcc.com>
Cc: linux-scsi@vger.kernel.org

On Tue, May 25, 2004 at 10:46:37AM -0700, Adam Radford wrote:
> Hch,
> 
> Thanks for the feedback.  I have already made most of the changes, including
> converting the driver to pci_driver format.  I will re-post the next version
> soon.  The only thing I cannot do is mark 'extern struct timezone sys_tz' as 
> static.

Hmm, I wonder why you need that.  But I'm too lazy to look at the old
patch again and will check when you post the next revision.

