From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] cleanup code for /proc add/remove single device
Date: Thu, 21 Nov 2002 18:55:48 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021121185548.A15559@lst.de>
References: <20021121022314.A8931@lst.de> <20021121092115.A17363@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021121092115.A17363@eng2.beaverton.ibm.com>; from patmans@us.ibm.com on Thu, Nov 21, 2002 at 09:21:15AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Thu, Nov 21, 2002 at 09:21:15AM -0800, Patrick Mansfield wrote:
> current scsi-misc-2.5) to get the add to work correctly. Otherwise, this
> worked fine.

Duh! thanks for the fix.  The other patch also looks okay, although I
wonder why you need hardirq.h.

