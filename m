From: Alan Cox <alan@redhat.com>
Subject: Re: sg driver and Fedora Core 2
Date: Sat, 29 May 2004 13:46:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040529174626.GA27405@devserv.devel.redhat.com>
References: <40B74725.90403@torque.net> <20040528172535.GD13961@devserv.devel.redhat.com> <1085846125.2101.29.camel@mulgrave> <20040529155744.GA32621@devserv.devel.redhat.com> <1085846840.2103.47.camel@mulgrave> <20040529162912.GA5922@devserv.devel.redhat.com> <1085849399.2004.101.camel@mulgrave> <40B8C81E.3050106@pobox.com> <1085852299.2004.206.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:1262 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265312AbUE2Rr3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 13:47:29 -0400
Content-Disposition: inline
In-Reply-To: <1085852299.2004.206.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Alan Cox <alan@redhat.com>, Douglas Gilbert <dougg@torque.net>, Arjan van de Ven <arjanv@redhat.com>, Jens Axboe <axboe@suse.de>

On Sat, May 29, 2004 at 12:38:18PM -0500, James Bottomley wrote:
> > worry about _any_ target/addressing information, since that is implicit 
> > in the dentry pointing to the blkdev's inode.
> 
> Yes, the mapping issues is the huge problem where users keep shooting
> themselves in the foot.

That is actually a dying issue (aside from the whole /dev/sg debate). Users
select the CD burner by vendor/device name from the pull down menu in real
world computing. The underlying question is how the GUI application does the
scan and how it figures out what burner ties to what cd-rom device in the
file manager. SG_IO is wonderful here and has solved the latter part nicely.
sysfs has solved the former part.

Alan

