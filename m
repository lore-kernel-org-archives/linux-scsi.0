From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: [PATCH] move some constants around
Date: Sat, 20 Sep 2003 20:34:58 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030920203458.A3552@pclin040.win.tue.nl>
References: <20030920133335.GA23251@lst.de> <20030920185037.A3530@pclin040.win.tue.nl> <20030920181149.GA26141@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhost.tue.nl ([131.155.2.7]:42251 "EHLO mailhost.tue.nl")
	by vger.kernel.org with ESMTP id S261932AbTITSe7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Sep 2003 14:34:59 -0400
Content-Disposition: inline
In-Reply-To: <20030920181149.GA26141@lst.de>; from hch@lst.de on Sat, Sep 20, 2003 at 08:11:49PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Andries Brouwer <aebr@win.tue.nl>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Sat, Sep 20, 2003 at 08:11:49PM +0200, Christoph Hellwig wrote:

> The current design purpose of include/scsi/ is to be for the kernel
> only.  glibc has it's own scsi/ headers.  and drivers/scsi/scsi.h
> is going away completly (slowly).

Yes, I see that that is what you are doing.
Pity.

One of the projects that has been delayed far too much is the
project of giving Linux headers that can be used in user space.
There were only few of those.

Now you are polluting even those few.

Andries


