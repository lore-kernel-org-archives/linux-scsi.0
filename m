From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH v2] scsi: address leak in scsi_setup_discard_cmnd error
  path
Date: Wed, 07 Jul 2010 21:46:00 +0200
Message-ID: <4C34D978.8060904@fusionio.com>
References: <20100705125651R.fujita.tomonori@lab.ntt.co.jp> <20100705134529.GA18645@redhat.com> <20100706135958.GA10772@redhat.com> <20100707194431.GA20206@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:50643 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab0GGTqB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jul 2010 15:46:01 -0400
In-Reply-To: <20100707194431.GA20206@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>

On 07/07/10 21.44, Christoph Hellwig wrote:
>> Here is a minimalist patch that 1) removes the discard request's page
>> leak 2) preserves the prep cleanup rules covered above.  Fixing the leak
>> is a priority, introducing additional error path code sharing/cleanup is
>> secondary and can come later.
> 
> I much prefer this approach.

Same here, it's the correct layering. I'll queue this up, thanks.

-- 
Jens Axboe

