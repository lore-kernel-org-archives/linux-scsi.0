From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Sat, 26 Apr 2003 17:24:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030426172416.A18192@beaverton.ibm.com>
References: <UTC200304262144.h3QLiAt04450.aeb@smtp.cwi.nl> <1051396197.1768.81.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 216-99-218-173.dsl.aracnet.com ([216.99.218.173]:5108 "EHLO
	dyn9-47-17-132.beaverton.ibm.com") by vger.kernel.org with ESMTP
	id S263101AbTD0AP5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Apr 2003 20:15:57 -0400
Content-Disposition: inline
In-Reply-To: <1051396197.1768.81.camel@mulgrave>; from James.Bottomley@steeleye.com on Sat, Apr 26, 2003 at 05:29:55PM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andries.Brouwer@cwi.nl, mdharm-scsi@one-eyed-alien.net, greg@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net


> > All this is nice and well. Remains the question how usb-storage
> > makes sure that the use_10_for_rw and use_10_for_ms flags are set
> > for its devices.

> Well, this should be done in the USB storage slave_configure...that's
> almost exactly what the interface is designed for (altering scsi_device
> parameters before the SCSI subsystem starts using it).

I prefer Matt's suggestion, that we handle this similar to sd.c use of
use_10_for_rw so the alogrithm works for all devices independent of the
LLDD.

Is MODE SENSE 10 used by default in other OSes and more likely to work
than MODE SENSE 6?

-- Patrick Mansfield
