From: Andy Whitcroft <apw@shadowen.org>
Subject: Re: [patch 1/3] ps3: Disk Storage Driver
Date: Tue, 24 Jul 2007 12:44:16 +0100
Message-ID: <46A5E610.7000508@shadowen.org>
References: <20070716161539.075822000@pademelon.sonytel.be>	<20070716162206.392129000@pademelon.sonytel.be> <20070718163637.3f0e0164.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hellhawk.shadowen.org ([80.68.90.175]:3799 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbXGXLof (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2007 07:44:35 -0400
In-Reply-To: <20070718163637.3f0e0164.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, Paul Mackerras <paulus@samba.org>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Geoff Levand <geoffrey.levand@am.sony.com>, Jens Axboe <jens.axboe@oracle.com>

Andrew Morton wrote:

>> +	start_sector = req->sector*priv->blocking_factor;
>> +	sectors = req->nr_sectors*priv->blocking_factor;
> 
> s/*/ * /.  checkpatch missed this.

Ok, this is something we need to decide on.  Currently we only ask for
consistent spacing on all the mathematic operators.  This is mostly as
we do see a large number of non-spaced uses in defines and the like.

I am happy to expand these tests so they are always spaced on both sides
style if that is the preference.

-apw
