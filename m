From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/4] sd: fix cache flushing message
Date: Wed, 29 Apr 2009 16:41:48 -0400
Message-ID: <yq1my9z9oqb.fsf@sermon.lab.mkp.net>
References: <200904292206.29844.bzolnier@gmail.com>
	<1241036401.3369.57.camel@mulgrave.int.hansenpartnership.com>
	<49F8B71B.90707@garzik.org> <20090429203639.GB8822@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:30636 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465AbZD2UnE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2009 16:43:04 -0400
In-Reply-To: <20090429203639.GB8822@parisc-linux.org> (Matthew Wilcox's
	message of "Wed, 29 Apr 2009 14:36:40 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-scsi@vger.kernel.org

>>>>> "Matthew" == Matthew Wilcox <matthew@wil.cx> writes:

>> And we can argue for weeks about English text, too.  Non-disk devices
>> like SSDs have caches too, so I'd say "SCSI cache" is more accurate
>> than "disk cache".  But maybe "SCSI writeback cache" would be even
>> better.

Matthew> "drive cache" works better (and avoids the whole disc/disk
Matthew> discussion too)

Who says it's a drive and not an array?

-- 
Martin K. Petersen	Oracle Linux Engineering

