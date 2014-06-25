From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 08/14] block: Add a disk flag to block integrity profile
Date: Wed, 25 Jun 2014 07:49:18 -0400
Message-ID: <yq1d2dxfbup.fsf@sermon.lab.mkp.net>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
	<1401334128-15499-9-git-send-email-martin.petersen@oracle.com>
	<20140611164858.GC9511@infradead.org>
	<yq1ha3qrk1x.fsf@sermon.lab.mkp.net>
	<20140625102441.GA24735@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40998 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbaFYLtu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 07:49:50 -0400
In-Reply-To: <20140625102441.GA24735@infradead.org> (Christoph Hellwig's
	message of "Wed, 25 Jun 2014 03:24:41 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> On Wed, Jun 11, 2014 at 09:30:34PM -0400, Martin K. Petersen wrote:
>> /sys/block/foo/integrity/disk_is_formatted_with_pi
>> /sys/block/foo/integrity/disk_is_integrity_capable
>> /sys/block/foo/integrity/disk_supports_storing_pi
>> 
>> Or would you prefer something other than disk? target?
>> storage_device?

Christoph> I'd defintively prefer the target_ prefix and one of the
Christoph> descriptive suffixes.

OK, will tweak.

-- 
Martin K. Petersen	Oracle Linux Engineering
