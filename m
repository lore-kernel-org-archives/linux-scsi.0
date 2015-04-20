From: Torsten Luettgert <ml-lkml@enda.eu>
Subject: Re: BUG: unable to handle kernel NULL pointer deref, bisected to
 746650160
Date: Mon, 20 Apr 2015 13:24:24 +0200
Message-ID: <20150420132424.0ce7965f@goldlack.schiller106>
References: <20150408183333.493607a3@goldlack.schiller106>
	<20150413174105.GA14988@lst.de>
	<20150413202829.580e3801@goldlack.schiller106>
	<20150419165841.GA20332@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150419165841.GA20332@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux SCSI mailing list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 19 Apr 2015 18:58:41 +0200
Christoph Hellwig <hch@lst.de> wrote:

> This looks like a long standing bug in all three 3ware drivers to
> me, that the taking the host lock around the host_busy manipulation
> was hiding.
> 
> Can you test the patch below?

I'm running it right now and keeping my fingers crossed.

Thanks & regards,
Torsten
