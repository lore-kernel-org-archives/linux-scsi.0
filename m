From: Alan Cox <alan@redhat.com>
Subject: Re: sg driver and Fedora Core 2
Date: Sat, 29 May 2004 13:35:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040529173530.GA24516@devserv.devel.redhat.com>
References: <40B74725.90403@torque.net> <20040528172535.GD13961@devserv.devel.redhat.com> <1085846125.2101.29.camel@mulgrave> <20040529155744.GA32621@devserv.devel.redhat.com> <1085846840.2103.47.camel@mulgrave> <20040529162912.GA5922@devserv.devel.redhat.com> <1085849399.2004.101.camel@mulgrave> <40B8C81E.3050106@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:22505 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S264331AbUE2Rgq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 13:36:46 -0400
Content-Disposition: inline
In-Reply-To: <40B8C81E.3050106@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Alan Cox <alan@redhat.com>, Douglas Gilbert <dougg@torque.net>, Arjan van de Ven <arjanv@redhat.com>, Jens Axboe <axboe@suse.de>

On Sat, May 29, 2004 at 01:27:58PM -0400, Jeff Garzik wrote:
> Really what needs to happen is a generic userland tap attaches to a 
> chrdev, issues an ioctl(2) to attach to a request_queue, and then does 
> read(2)/write(2)/mmap(2) to communicate with the request_queue.

Is there a reason that couldn't be part of the block layer sysfs in 2.7.x 

> :)
> Call it /dev/bsg, or somesuch.

Except that I wonder if it should be in sysfs I agree entirely. 

>   OTOH, the SG_IO ioctl does eliminate the userland app needing to 
> worry about _any_ target/addressing information, since that is implicit 
> in the dentry pointing to the blkdev's inode.

It makes it very hard to scan scsi busses, which is what the flash burner
app does, and what xsane does (although sane survives ok because there
are no kernel scanner device drivers)

Alan

