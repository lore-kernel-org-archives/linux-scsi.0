From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_scan.c EVPD code
Date: Mon, 5 May 2003 10:46:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030505174602.GA3433@beaverton.ibm.com>
References: <UTC200304250047.h3P0lhl03517.aeb@smtp.cwi.nl> <3EB619A4.5090407@torque.net> <20030505093834.B7831@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:22153 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S261182AbTEER5K
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2003 13:57:10 -0400
Content-Disposition: inline
In-Reply-To: <20030505093834.B7831@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Douglas Gilbert <dougg@torque.net>, Andries.Brouwer@cwi.nl, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net

Patrick Mansfield [patmans@us.ibm.com] wrote:
> An sgid user program that does the same thing as the code removed from the
> kernel would be very usefull. This could likely be incorporated into other
> schemes (udev), independent of other details.
> 
> Right now, we could have an sgid that runs whenever an sg is found (sg
> hotplug generated via device_register), and stores a sysfs path and the id
> returned into a flat file.

I believe devlabel's scsi_unique_id.c file does some of this, though I
have not looked at it closely.

-andmike
--
Michael Anderson
andmike@us.ibm.com

