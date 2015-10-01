From: "Thomas D." <whissi@whissi.de>
Subject: Re: req->nr_phys_segments > queue_max_segments (was Re: kernel BUG at
 drivers/block/virtio_blk.c:172!)
Date: Thu, 1 Oct 2015 18:06:19 +0200
Message-ID: <560D59FB.7020501@whissi.de>
References: <560C87F6.4080708@whissi.de>
 <20151001114817-mutt-send-email-mst@redhat.com> <560CFAD3.1030607@suse.de>
 <CAMM=eLcyT2JeWn4NJ6gjsHcRz_D8YcixLix64Spg9cVYFexGyA@mail.gmail.com>
 <560D36DC.5050205@whissi.de> <560D52DE.3020303@whissi.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.tf-network.de ([62.75.218.204]:36760 "EHLO
	borg.tf-network.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbbJAQGV (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Thu, 1 Oct 2015 12:06:21 -0400
In-Reply-To: <560D52DE.3020303@whissi.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>

Hi

> seems like we have two problems:
> 
> The first (origin) problem seems to be already fixed by Mike's patch.
> 
> I applied the patch against linux-4.1.8, rebooted several times without
> a problem. But I'll keep testing for sure.

I already experienced one freeze with linux-4.1.8 and Mike's patch (same
like in 4.1.9). Doesn't mean that this is related to Mike's patch (I see
the same freezes with vanilla 4.1.9 not containing the patch with a
higher frequency).


-Thomas


