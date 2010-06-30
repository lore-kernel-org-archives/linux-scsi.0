From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC 1/2] block: implement an unprep function corresponding  directly to prep
Date: Wed, 30 Jun 2010 13:54:46 -0400
Message-ID: <yq1k4pg2yop.fsf@sermon.lab.mkp.net>
References: <1277917264.2839.153.camel@mulgrave.site>
	<4C2B8412.6040807@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:53153 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab0F3R4t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jun 2010 13:56:49 -0400
In-Reply-To: <4C2B8412.6040807@kernel.dk> (Jens Axboe's message of "Wed, 30
	Jun 2010 19:51:14 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: James Bottomley <James.Bottomley@suse.de>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, dm-devel@redhat.com

>>>>> "Jens" == Jens Axboe <axboe@kernel.dk> writes:

Jens> On 30/06/10 19.01, James Bottomley wrote:
>> So this is more directly what I'm thinking.  It gives us an exactly
>> correct place to hang the discard allocation in SCSI.  The next patch
>> shows a potential implementation in sd.
>> 
>> I think it should avoid all the leaks people have been seeing trying
>> to move the discard allocation/free into scsi.  I also think it
>> should facilitate sending discard through SCSI as a REQ_TYPE_FS.

Jens> This is so much better than the other hacks, thanks for doing
Jens> this.

Agreed!

-- 
Martin K. Petersen	Oracle Linux Engineering
