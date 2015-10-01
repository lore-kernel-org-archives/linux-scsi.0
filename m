From: "Thomas D." <whissi@whissi.de>
Subject: Re: req->nr_phys_segments > queue_max_segments (was Re: kernel BUG at
 drivers/block/virtio_blk.c:172!)
Date: Thu, 1 Oct 2015 15:36:28 +0200
Message-ID: <560D36DC.5050205@whissi.de>
References: <560C87F6.4080708@whissi.de>
 <20151001114817-mutt-send-email-mst@redhat.com> <560CFAD3.1030607@suse.de>
 <CAMM=eLcyT2JeWn4NJ6gjsHcRz_D8YcixLix64Spg9cVYFexGyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.tf-network.de ([62.75.218.204]:55999 "EHLO
	borg.tf-network.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbbJANnx (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Thu, 1 Oct 2015 09:43:53 -0400
In-Reply-To: <CAMM=eLcyT2JeWn4NJ6gjsHcRz_D8YcixLix64Spg9cVYFexGyA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>

Hi,

Mike Snitzer wrote:
> This particular dm-crypt on virtio-blk issue is fixed with this commit:
> http://git.kernel.org/linus/586b286b110e94eb31840ac5afc0c24e0881fe34
> 
> Linus pulled this into v4.3-rc3.

I have this patch applied to linux-4.1.9. This could be the reason why I
don't see the issue on boot with linux-4.1.9.

So is the freeze I am experiencing with linux-4.1.9 another issue
introduced with linux-4.1.9 or another symptom/regression? Any idea?


-Thomas

