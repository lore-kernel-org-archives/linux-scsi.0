From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Time to conclude the Sony USB mass storage thread
Date: Fri, 14 Nov 2003 09:58:23 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031114095823.A3597@beaverton.ibm.com>
References: <1068825146.2134.6.camel@mulgrave> <20031114092644.A2794@beaverton.ibm.com> <20031114093503.B19467@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:49043 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S264558AbTKNR6i
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 12:58:38 -0500
Content-Disposition: inline
In-Reply-To: <20031114093503.B19467@one-eyed-alien.net>; from mdharm-scsi@one-eyed-alien.net on Fri, Nov 14, 2003 at 09:35:03AM -0800
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, usb-storage@one-eyed-alien.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Nov 14, 2003 at 09:35:03AM -0800, Matthew Dharm wrote:
> I'm strongly attempted to agree with you guys.... blacklisting looks like
> the way to go.
> 
> I'm concerned about the names, tho.... BLIST_MS_SKIP_PAGE_08 sounds more
> general than it is -- as I understand it, this flag will only affect sd.c,
> tho it looks much more general.

We can change the name.

> I think I'd rather tweak the structure in slave_configure, where it will be
> easier to add more logic if people decide we need it in the future.

Unlike scsi_devinfo/dev_flags, we can't override slave_configure changes
(unless you add other code).

-- Patrick Mansfield
