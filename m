From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_scan.c EVPD code
Date: 05 May 2003 12:01:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1052154092.1816.25.camel@mulgrave>
References: <UTC200304250047.h3P0lhl03517.aeb@smtp.cwi.nl>
	<3EB619A4.5090407@torque.net> <1052144231.1888.10.camel@mulgrave>
	<20030505155210.GB1567@beaverton.ibm.com>
	<1052151252.1888.15.camel@mulgrave>
	<20030505165739.GD1567@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:55047 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263650AbTEEQuZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2003 12:50:25 -0400
In-Reply-To: <20030505165739.GD1567@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: dougg@torque.net, Andries.Brouwer@cwi.nl, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net, Patrick Mansfield <patmans@us.ibm.com>

On Mon, 2003-05-05 at 11:57, Mike Anderson wrote:
> Yes I agree they are not exclusive to SCSI, but the same can be said of
> the block argument. Block is large set, but is not the whole set of
> possible uuid producing nodes. 
> 
> We could add it as a device default attribute (dev_default_attrs), but
> it would produce the extra overhead like power does today for nodes that
> have no uuid.

Really, we could do with an extension of the class concept.  Device
could be bare bones, then the classes of device with power management,
classes of device with unique ID etc.

However, I think such a scheme might be too complex to be workable, so
just adding it to the default device attributes would be fine by me too.

James


