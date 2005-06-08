From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block pc requests and
 simplify hw handlers
Date: Wed, 08 Jun 2005 07:46:50 -0500
Message-ID: <42A6E8BA.4090603@cs.wisc.edu>
References: <1117847972.23638.62.camel@mina> <1117901234.5005.9.camel@mulgrave> <20050607121020.GA6458@infradead.org> <1118146802.4998.3.camel@mulgrave> <1118158614.42a5bf160d317@webmail.cs.wisc.edu> <20050607180942.GC8172@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:19640 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261514AbVFHSs0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2005 14:48:26 -0400
In-Reply-To: <20050607180942.GC8172@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

Jens Axboe wrote:
> On Tue, Jun 07 2005, Michael Christie wrote:
> 
>>Quoting James Bottomley <James.Bottomley@SteelEye.com>:
>>
>>
>>>On Tue, 2005-06-07 at 13:10 +0100, Christoph Hellwig wrote:
>>>
>>>>shouldn't blk_rq_map_kern handle a 0 buffer and do nothing more than
>>>>blk_get_request?  It's not exactly a criticial fastpath and that would make
>>>
>>>life
>>>
>>>>easier for the callers.
>>>
>>>Yes ... and it should probably do bio bouncing as well, since there's
>>>nothing special we have to do on completion to clean it up.
>>
>>ok. I just made it like the existing blk_rq_map_user which made the caller do
>>those things.
> 
> 
> I agree with Christoph, makes it nicer for blk_rq_map_user as well. I'll
> change the latter if you fix the former.

ok will do.
