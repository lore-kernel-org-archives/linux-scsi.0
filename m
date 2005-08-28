From: Christoph Hellwig <hch@infradead.org>
Subject: Re: libata: clustering on or off?
Date: Sun, 28 Aug 2005 15:58:06 +0100
Message-ID: <20050828145806.GA22634@infradead.org>
References: <20050828094218.GA29145@havoc.gtf.org> <1125224541.3219.13.camel@laptopd505.fenrus.org> <20050828142018.GS4018@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:4569 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751183AbVH1O6N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Aug 2005 10:58:13 -0400
Content-Disposition: inline
In-Reply-To: <20050828142018.GS4018@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Arjan van de Ven <arjan@infradead.org>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Sun, Aug 28, 2005 at 04:20:19PM +0200, Jens Axboe wrote:
> Agree, we should just remove the ability to control clustering, as it
> really overlaps with the segment settings anyways.

What are we going to do with iscsi then?  It really doesn't like segments
over a pages size.  Best thing would probably be to switch networking to
use sg lists and dma_map_sg, but that's not a trivial task.

