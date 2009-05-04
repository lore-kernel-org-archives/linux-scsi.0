From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: New TRIM/UNMAP tree published (2009-05-02)
Date: Mon, 04 May 2009 15:23:56 +0000
Message-ID: <1241450637.3315.32.camel@mulgrave.int.hansenpartnership.com>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com>
	 <49D8A3D7.5070507@panasas.com> <20090503061150.GF10704@linux.intel.com>
	 <20090503071619.GP8822@parisc-linux.org>
	 <Pine.LNX.4.64.0905031346350.29671@blonde.anvils>
	 <20090503144847.GR8822@parisc-linux.org> <49FDB21B.3080301@panasas.com>
	 <20090503154216.GU8822@parisc-linux.org> <49FDC786.6070309@panasas.com>
	 <49FDE3BB.505@garzik.org>  <49FDE50A.4060503@garzik.org>
	 <1241377472.5596.88.camel@mulgrave.int.hansenpartnership.com>
	 <49FDEE64.5090302@garzik.org>
	 <1241379476.5596.92.camel@mulgrave.int.hansenpartnership.com>
	 <49FEF5C5.6010404@interlog.com>
	 <1241448038.3315.19.camel@mulgrave.int.hansenpartnership.com>
	 <49FF05AB.5020801@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46766 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754011AbZEDPX6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2009 11:23:58 -0400
In-Reply-To: <49FF05AB.5020801@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, Hugh Dickins <hugh@veritas.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <lkml@rtr.ca>

On Mon, 2009-05-04 at 17:11 +0200, Douglas Gilbert wrote:
> Another aspect, especially if a large amount of storage
> is to be trimmed, is how long will it take? This relates
> to the timeout value we should associate with such an
> invocation. The FORMAT UNIT and START STOP UNIT commands
> have an IMMED bit, but not WRITE SAME.

I was assuming it would be more or less instantaneous ... if it's not
then the plan of trying to keep thin provisioning happy just by sending
down a maximal trim from the filesystem is going to run into trouble.

> Speaking of FORMAT UNIT, some words were added into sbc3r18
> that suggest a FORMAT UNIT command could be interpreted as
> unmap/trim the whole disk.

Seems reasonable ... if you format the device it could be argued you're
not relying on the data contents any more ...

James


