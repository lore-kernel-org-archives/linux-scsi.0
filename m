From: Jens Axboe <axboe@suse.de>
Subject: Re: sg driver and Fedora Core 2
Date: Sat, 29 May 2004 19:29:20 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040529172916.GD18613@suse.de>
References: <40B74725.90403@torque.net> <20040528172535.GD13961@devserv.devel.redhat.com> <1085846125.2101.29.camel@mulgrave> <20040529155744.GA32621@devserv.devel.redhat.com> <1085846840.2103.47.camel@mulgrave> <20040529162912.GA5922@devserv.devel.redhat.com> <1085849399.2004.101.camel@mulgrave> <40B8C81E.3050106@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:10222 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S264337AbUE2R3g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 13:29:36 -0400
Content-Disposition: inline
In-Reply-To: <40B8C81E.3050106@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Alan Cox <alan@redhat.com>, Douglas Gilbert <dougg@torque.net>, Arjan van de Ven <arjanv@redhat.com>

On Sat, May 29 2004, Jeff Garzik wrote:
> Really what needs to happen is a generic userland tap attaches to a 
> chrdev, issues an ioctl(2) to attach to a request_queue, and then does 
> read(2)/write(2)/mmap(2) to communicate with the request_queue.
> 
> :)
> 
> Call it /dev/bsg, or somesuch.
> 
> The SG_IO ioctl won't work for all cases, since some block devices may 
> rightly wish to limit (or block) multiple openers on the blkdev itself. 
>   OTOH, the SG_IO ioctl does eliminate the userland app needing to 
> worry about _any_ target/addressing information, since that is implicit 
> in the dentry pointing to the blkdev's inode.

Hear, hear!

-- 
Jens Axboe

