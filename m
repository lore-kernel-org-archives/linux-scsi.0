From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] cleanup code for /proc add/remove single device
Date: Thu, 21 Nov 2002 10:10:09 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021121101009.A18201@eng2.beaverton.ibm.com>
References: <20021121022314.A8931@lst.de> <20021121092115.A17363@eng2.beaverton.ibm.com> <20021121185548.A15559@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021121185548.A15559@lst.de>; from hch@lst.de on Thu, Nov 21, 2002 at 06:55:48PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Thu, Nov 21, 2002 at 06:55:48PM +0100, Christoph Hellwig wrote:
> On Thu, Nov 21, 2002 at 09:21:15AM -0800, Patrick Mansfield wrote:
> > current scsi-misc-2.5) to get the add to work correctly. Otherwise, this
> > worked fine.
> 
> Duh! thanks for the fix.  The other patch also looks okay, although I
> wonder why you need hardirq.h.

For the in_atomic check in scsi_init_io.

-- Patrick Mansfield
