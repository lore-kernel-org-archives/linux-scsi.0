From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: verbose argument to sd_synchronize_cache
Date: Sun, 27 Oct 2002 10:35:19 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210271635.g9RGZJ111449@localhost.localdomain>
References: <hch@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id IAA11047
	for <linux-scsi@vger.kernel.org>; Sun, 27 Oct 2002 08:35:22 -0800
In-Reply-To: Message from Christoph Hellwig <hch@infradead.org>
   of "Sun, 27 Oct 2002 16:28:11 GMT." <20021027162811.A21987@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

hch@infradead.org said:
> sd_synchronize_cache() is always called with verbose=1, so this
> argument should go away.  But do we really want to be that verbose
> here?  IMHO we should remove the argumet and the printks.. 

It can take a while to synchronise the cache on monster arrays, so printing 
something while we do it on shutdown is a good idea (unless you want the "my 
machine takes ages to shut down" type of bug reports).

The non-verbose part was for exposing the synchronise via an ioctl (which I 
haven't got around to writing yet) on the grounds that anyone doing the ioctl 
knows what's going on and doesn't need a kernel message telling them.

James


