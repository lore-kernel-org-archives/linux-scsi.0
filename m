From: "Miller, Mike (OS Dev)" <mike.miller@hp.com>
Subject: RE: [PATCH 2.6] cciss typo fix
Date: Mon, 10 Jan 2005 09:45:44 -0600
Message-ID: <D4CFB69C345C394284E4B78B876C1CF107DC0188@cceexc23.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262297AbVAJPrQ@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> > > -		*block_size = be32_to_cpu(*((__be32 *) 
> > &buf->block_size[0]));
> > > +		*total_size = be32_to_cpu(*((__u32 *) 
> > &buf->total_size[0]))+1;
>


> From: Jens Axboe [mailto:axboe@suse.de]
> Hmm odd, no one should have complained, it should just have been added
> to the compat header.

Even if it were added to the compat header; is using __be32 correct in this context?

mikem
