From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] scsi: need to reset unprep_rq_fn in sd_remove
Date: Mon, 05 Jul 2010 08:56:04 +0200
Message-ID: <4C318204.2090904@fusionio.com>
References: <20100703230650Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:54722 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494Ab0GEG4G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jul 2010 02:56:06 -0400
In-Reply-To: <20100703230650Q.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "hch@lst.de" <hch@lst.de>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2010-07-03 16:07, FUJITA Tomonori wrote:
> This is for block's for-2.6.36.
> 
> We need to reset q->unprep_rq_fn in sd_remove. Otherwise we hit kernel
> oops if we access to a scsi disk device via sg after removing scsi
> disk module.

Thanks, applied.

-- 
Jens Axboe
