From: Alan Cox <alan@redhat.com>
Subject: Re: sg driver and Fedora Core 2
Date: Sun, 30 May 2004 06:41:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040530104145.GA3172@devserv.devel.redhat.com>
References: <40B74725.90403@torque.net> <20040528172535.GD13961@devserv.devel.redhat.com> <1085846125.2101.29.camel@mulgrave> <20040529155744.GA32621@devserv.devel.redhat.com> <1085846840.2103.47.camel@mulgrave> <20040529162912.GA5922@devserv.devel.redhat.com> <1085849399.2004.101.camel@mulgrave> <40B8C81E.3050106@pobox.com> <20040529172916.GD18613@suse.de> <40B9B95A.40304@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:32385 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262103AbUE3Km0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 May 2004 06:42:26 -0400
Content-Disposition: inline
In-Reply-To: <40B9B95A.40304@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Jens Axboe <axboe@suse.de>, Jeff Garzik <jgarzik@pobox.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Alan Cox <alan@redhat.com>, Arjan van de Ven <arjanv@redhat.com>

On Sun, May 30, 2004 at 08:37:14PM +1000, Douglas Gilbert wrote:
> configuring the SAS domain. Expanders are SAS devices but
> not SCSI devices (i.e. they are neither initiators nor
> targets ***). It seems obvious that the management of a SAS
> domain should be done from the user space. Only those
> expanders and devices directly attached to a SAS Host Bus
> Adapter should automatically be visible.

Is there any reason that the SAS domain should in itself be a character
device file. I've always thought of it as a network and anticipated
a network layer interface for such things. That might just be my background
however.
