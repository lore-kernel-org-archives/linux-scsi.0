From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] bind bsg to request_queue instead of gendisk
Date: Wed, 14 Feb 2007 16:14:05 -0500
Message-ID: <45D37B9D.5030806@emulex.com>
References: <20070213095318G.fujita.tomonori@lab.ntt.co.jp> <20070214205605.GA20967@osc.edu>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:35835 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932614AbXBNVOo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Feb 2007 16:14:44 -0500
In-Reply-To: <20070214205605.GA20967@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Wyckoff <pw@osc.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, hch@infradead.org


Pete Wyckoff wrote:
> The only place that bsg_register_rq is called is via
> blk_register_queue, which is only called by add_disk.  But not all
> devices have a block interface or need the gendisk that these
> functions assume.

FYI - very shortly, we expect dynamic transport entities to start calling
bsg_register_rq() as well.

-- james s

