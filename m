From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: [PATCH] move some constants around
Date: Sat, 20 Sep 2003 18:50:37 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030920185037.A3530@pclin040.win.tue.nl>
References: <20030920133335.GA23251@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhost.tue.nl ([131.155.2.7]:2323 "EHLO mailhost.tue.nl")
	by vger.kernel.org with ESMTP id S261909AbTITQuk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Sep 2003 12:50:40 -0400
Content-Disposition: inline
In-Reply-To: <20030920133335.GA23251@lst.de>; from hch@lst.de on Sat, Sep 20, 2003 at 03:33:35PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Sat, Sep 20, 2003 at 03:33:35PM +0200, Christoph Hellwig wrote:

> We should try to keep all constants in include/scsi/scsi.h instead
> of drivers/scsi/scsi.h.  Also tidy up include/scsi/scsi.h a bit.

The original design purpose of include/scsi/scsi.h versus
drivers/scsi/scsi.h was to have constants that are meaningful
in user space (such as constants defined in the SCSI standard)
in <scsi/scsi.h>, while kernel-internal stuff lived in
drivers/scsi/scsi.h.

Thus, I do not see this move as an improvement.

Andries

>  /*
>   * This header file contains public constants and structures used by
>   * the scsi code for linux.
>   */

