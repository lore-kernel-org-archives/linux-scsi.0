From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [usb-storage] Re: Time to conclude the Sony USB mass storage thread
Date: Sat, 15 Nov 2003 16:02:46 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031115160246.A5997@beaverton.ibm.com>
References: <20031114125648.A5811@beaverton.ibm.com> <20031114181312.A1790@beaverton.ibm.com> <20031115122052.A9275@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:3816 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262186AbTKPADD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Nov 2003 19:03:03 -0500
Content-Disposition: inline
In-Reply-To: <20031115122052.A9275@one-eyed-alien.net>; from mdharm-scsi@one-eyed-alien.net on Sat, Nov 15, 2003 at 12:20:52PM -0800
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, usb-storage@one-eyed-alien.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, Nov 15, 2003 at 12:20:52PM -0800, Matthew Dharm wrote:
> I presume your testing included mount, read, write, and umount?

Yes, with no problems.

I almost did not test mount due to build problems with vfat (I should have
rebuilt the kernel before modules after enabling and building vfat as
module), and was told write's to the device did not work with 2.4 but they
worked fine for me.

> I'm okay with the patch.  It could use some more comments, but that's not
> really necessary.

We ought to change the define names to make more sense.

-- Patrick Mansfield
