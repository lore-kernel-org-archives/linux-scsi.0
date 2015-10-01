From: "Thomas D." <whissi@whissi.de>
Subject: Re: req->nr_phys_segments > queue_max_segments (was Re: kernel BUG at
 drivers/block/virtio_blk.c:172!)
Date: Thu, 1 Oct 2015 17:35:58 +0200
Message-ID: <560D52DE.3020303@whissi.de>
References: <560C87F6.4080708@whissi.de>
 <20151001114817-mutt-send-email-mst@redhat.com> <560CFAD3.1030607@suse.de>
 <CAMM=eLcyT2JeWn4NJ6gjsHcRz_D8YcixLix64Spg9cVYFexGyA@mail.gmail.com>
 <560D36DC.5050205@whissi.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.tf-network.de ([62.75.218.204]:43853 "EHLO
	borg.tf-network.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbbJAPgC (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Thu, 1 Oct 2015 11:36:02 -0400
In-Reply-To: <560D36DC.5050205@whissi.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>

Hi,

seems like we have two problems:

The first (origin) problem seems to be already fixed by Mike's patch.

I applied the patch against linux-4.1.8, rebooted several times without
a problem. But I'll keep testing for sure.


The second problem is a new bug within linux-4.1.9: I experience the

> NMI watchdog: BUG: soft lockup - CPU#3 stuck for 23s!

freeze now on all my systems (virtual machines *and* physical systems;
Gentoo boxes, Debian boxes, with and without dm (LUKS), with XFS or ext4
-- looks like a general problem). I will post it to LKML itself (I don't
have a trace about what's hanging).

Thanks for all your time and help!


-Thomas
