From: Christoph Hellwig <hch@infradead.org>
Subject: [Achim_Leubner@adaptec.com: RE: HEADS UP for gdth driver users]
Date: Fri, 9 Jun 2006 12:36:09 +0100
Message-ID: <20060609113609.GA19388@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:61825 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S965226AbWFILgK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jun 2006 07:36:10 -0400
Received: from hch by pentafluge.infradead.org with local (Exim 4.62 #1 (Red Hat Linux))
	id 1FofHd-00052u-Sc
	for linux-scsi@vger.kernel.org; Fri, 09 Jun 2006 12:36:09 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

----- Forwarded message from "Leubner, Achim" <Achim_Leubner@adaptec.com> -----

Date:	Fri, 9 Jun 2006 13:03:08 +0200
From:	"Leubner, Achim" <Achim_Leubner@adaptec.com>
Subject: RE: HEADS UP for gdth driver users
To:	"Christoph Hellwig" <hch@lst.de>
Cc:	<linux-kernel@vger.kernel.org>

Hi Christoph,

Attached you find a patch to remove the scsi_request interface from the
gdth driver. The patch contains your first patch, the changes for
removing the scsi_request interface and some changes to preserve the
2.4.x compatibility.
We tested it and it should work fine. It would be great if it could be
integrated in the 2.6.18 cycle.

Many thanks and Regards,
Achim

=======================
Achim Leubner
Software Engineer / RAID drivers
ICP vortex GmbH / Adaptec Inc.
Phone: +49-351-8718291
 
-----Original Message-----
From: Christoph Hellwig [mailto:hch@lst.de] 
Sent: Dienstag, 25. April 2006 12:33
To: Leubner, Achim
Cc: Christoph Hellwig; linux-kernel@vger.kernel.org
Subject: Re: HEADS UP for gdth driver users

On Mon, Apr 24, 2006 at 02:21:00PM +0200, Leubner, Achim wrote:
> Is there any news on that? Can we use the scsi_get/put_command()
functions for allocating a "struct scsi_cmnd" or should we allocate it
with kmalloc() or somehow like that? Or, Christoph, did you already make
the second patch for the gdth driver? 
> We want to bring the gdth driver up to date as soon as possible. Any
help is greatly appreciated! 
Sorry, I didn't have time to look at this yet.  scsi_get/put_command()
sems ok for now, if you have time to look at this now it would be good
if you could look at it.  It's too late for 2.6.17 already, but having
it early in the 2.6.18 cycle would be very helpful.





----- End forwarded message -----
