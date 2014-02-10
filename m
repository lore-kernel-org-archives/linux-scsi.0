From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 00/15] A different approach for using blk-mq in the SCSI
 layer
Date: Mon, 10 Feb 2014 11:38:41 -0800
Message-ID: <1392061121.17867.13.camel@haakon3.risingtidesystems.com>
References: <20140205124118.332902571@bombadil.infradead.org>
	 <20140210113552.GA27357@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:49282 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbaBJTfw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Feb 2014 14:35:52 -0500
In-Reply-To: <20140210113552.GA27357@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

On Mon, 2014-02-10 at 03:35 -0800, Christoph Hellwig wrote:
> On Wed, Feb 05, 2014 at 04:41:18AM -0800, Christoph Hellwig wrote:
> > A git tree is also available at
> > 
> >   git://git.infradead.org/users/hch/scsi.git#scsi-mq-wip
> 
> I've pushed various fixes to the branch, most importantly the ata_piix
> driver including CDROM support has now been tested with blk-mq, and
> timeouts and basic EH now work properly.

Nice work hch!

--nab

