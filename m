From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 08/14] block: Add a disk flag to block integrity profile
Date: Wed, 11 Jun 2014 21:30:34 -0400
Message-ID: <yq1ha3qrk1x.fsf@sermon.lab.mkp.net>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
	<1401334128-15499-9-git-send-email-martin.petersen@oracle.com>
	<20140611164858.GC9511@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46019 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaFLBbK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 21:31:10 -0400
In-Reply-To: <20140611164858.GC9511@infradead.org> (Christoph Hellwig's
	message of "Wed, 11 Jun 2014 09:48:58 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Hey Christoph,

>> Add a flag to the block integrity profile that indicates whether the
>> disk has been formatted with protection information.

Christoph> I'm totally confused on why the sysfs file and flag are named
Christoph> 'disk'.  What does it stand for given that we already have a
Christoph> very established use of the term 'disk' in block I/O land..

The flag indicates whether or not the disk itself is integrity capable.
I.e. whether the protection extends beyond the HBA or not.

I'm open to suggestions for a better name. When I originally did this I
found it hard to come up with something that didn't sound convoluted or
redundant. The file resides in /sys/block/foo/integrity/ and I guess I
found "disk" sufficient given the context.

/sys/block/foo/integrity/disk_is_formatted_with_pi
/sys/block/foo/integrity/disk_is_integrity_capable
/sys/block/foo/integrity/disk_supports_storing_pi

Or would you prefer something other than disk? target? storage_device?

-- 
Martin K. Petersen	Oracle Linux Engineering
