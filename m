From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] block: add support for discard limits
Date: Mon, 02 Nov 2009 13:18:16 -0500
Message-ID: <yq1ocnkg593.fsf@sermon.lab.mkp.net>
References: <20091029150830.497006534@bombadil.infradead.org>
	<20091029151127.257902381@bombadil.infradead.org>
	<yq1ws2dsh4g.fsf@sermon.lab.mkp.net>
	<20091030050558.GC17714@infradead.org>
	<yq1eioh9hsr.fsf@sermon.lab.mkp.net> <4AEF02B0.2060506@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:60689 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134AbZKBSTT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2009 13:19:19 -0500
In-Reply-To: <4AEF02B0.2060506@panasas.com> (Boaz Harrosh's message of "Mon,
	02 Nov 2009 18:02:56 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, axboe@kernel.dk, matthew@wil.cx

>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:

Boaz> On 11/02/2009 03:29 PM, Martin K. Petersen wrote:
>> 
>> With heterogeneous md and dm devices there may not be a meaningful
>> value to put in the discard granularity field.  Then what?
>> 

Boaz> These alignment masks may only be base-2, no?  

Nope.  Could be the good old sector 63 offset vs. naturally aligned.


Boaz> If so then the max alignment of all devices will work for any
Boaz> device.

But even then we'd waste space on the array with smaller granularity.

-- 
Martin K. Petersen	Oracle Linux Engineering
