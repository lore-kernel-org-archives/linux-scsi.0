From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] move some constants around
Date: Sat, 20 Sep 2003 20:11:49 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030920181149.GA26141@lst.de>
References: <20030920133335.GA23251@lst.de> <20030920185037.A3530@pclin040.win.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:44932 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261925AbTITSLx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Sep 2003 14:11:53 -0400
Content-Disposition: inline
In-Reply-To: <20030920185037.A3530@pclin040.win.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <aebr@win.tue.nl>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Sat, Sep 20, 2003 at 06:50:37PM +0200, Andries Brouwer wrote:
> On Sat, Sep 20, 2003 at 03:33:35PM +0200, Christoph Hellwig wrote:
> 
> > We should try to keep all constants in include/scsi/scsi.h instead
> > of drivers/scsi/scsi.h.  Also tidy up include/scsi/scsi.h a bit.
> 
> The original design purpose of include/scsi/scsi.h versus
> drivers/scsi/scsi.h was to have constants that are meaningful
> in user space (such as constants defined in the SCSI standard)
> in <scsi/scsi.h>, while kernel-internal stuff lived in
> drivers/scsi/scsi.h.

The current design purpose of include/scsi/ is to be for the kernel
only.  glibc has it's own scsi/ headers.  and drivers/scsi/scsi.h
is going away completly (slowly).

