From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4/4] libata: Fix garbled Trim payload
Date: Sat, 21 Nov 2009 14:50:35 -0500
Message-ID: <yq16393slmc.fsf@sermon.lab.mkp.net>
References: <1258771524-26673-1-git-send-email-martin.petersen@oracle.com>
	<1258771524-26673-5-git-send-email-martin.petersen@oracle.com>
	<20091121104701.GA30153@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:52734 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbZKUTwf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Nov 2009 14:52:35 -0500
In-Reply-To: <20091121104701.GA30153@infradead.org> (Christoph Hellwig's
	message of "Sat, 21 Nov 2009 05:47:01 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, rwheeler@redhat.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> On Fri, Nov 20, 2009 at 09:45:24PM -0500, Martin K. Petersen wrote:
>> ata_set_lba_range_entries confused indexes into a u64 buffer with
>> byte offsets.  Fix this up and document the return value.
>> 
>> Update the libata write same translation to reflect this.

Christoph> Once we fix up this beast we should also change the current
Christoph> max argument to encode the buffer size, not the maximum
Christoph> number of entries which is a rather confusing interface.

What threw me off yesterday was that `max' starts out being a cap on the
number of 8-byte entries in the buffer. And then towards the end it
suddenly turns into a number-of-bytes entity as a result of the ALIGN
macro.

I agree that we should fix this up to be consistent. I'll do that.

-- 
Martin K. Petersen	Oracle Linux Engineering
