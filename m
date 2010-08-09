From: Christoph Hellwig <hch@lst.de>
Subject: Re: tcm/pscsi: Removal of struct scsi_disk access from pscsi_do_task()..?
Date: Mon, 9 Aug 2010 20:49:46 +0200
Message-ID: <20100809184946.GB3424@lst.de>
References: <1281153710.9098.0.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:54815 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557Ab0HISuB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Aug 2010 14:50:01 -0400
Content-Disposition: inline
In-Reply-To: <1281153710.9098.0.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Fri, Aug 06, 2010 at 09:01:50PM -0700, Nicholas A. Bellinger wrote:
> *) Is passing NULL for struct gendisk *gd into blk_execute_rq_nowait() and hence
>    a NULL struct request->rd_disk acceptable for struct request->rq_flags=REQ_TYPE_BLOCK_PC
>    usage in pscsi_blk_init_request() and pscsi_blk_get_request()..?

Yes.

> *) Is there a more sane way to locate struct gendisk *gd from struct scsi_device
>    for the typical backing struct block_device TYPE_DISK case..?

No.

